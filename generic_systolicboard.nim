# Did at uni computer lab, 19.10.2026
# Edited so that Board has to be NxN rather than arbitrary RxC and also finished block multiplication (UNTESTED!) at 26.10.2026, again at computer labs
import std/strformat

type Matrix*[R, C: static[int], T] = object
    data*: array[R*C, T]

proc `[]`*[R, C: static[int], T](m: Matrix[R, C, T], r, c: int): T =
    return m.data[r * C + c]

proc `[]=`*[R, C: static[int], T](m: var Matrix[R, C, T], r, c: int, v: T) =
    m.data[r * C + c] = v

proc `+`*[R, C: static[int], T](m1: Matrix[R, C, T], m2: Matrix[R, C, T]): Matrix[R, C, T] =
    for i in 0..<R*C:
        result.data[i] = m1.data[i] + m2.data[i]
    
proc `+=`*[R, C: static[int], T](m1: var Matrix[R, C, T], m2: Matrix[R, C, T]) =
    for i in 0..<R*C:
        m1.data[i] += m2.data[i]

##################################################################

type PE* = ref object
    next_north*: float
    next_west*: float
    north*: float
    west*: float
    east*: PE
    south*: PE
    accumulated*: float

proc accumulate_and_pass*(pe: PE) =
    pe.accumulated += pe.north * pe.west
    if not pe.east.isNil:
        pe.east.next_west = pe.west
    if not pe.south.isNil:
        pe.south.next_north = pe.north

proc shift_inputs*(pe: PE) =
    pe.north = pe.next_north
    pe.west = pe.next_west
    pe.next_north = -100.0
    pe.next_west = -100.0

proc clear*(pe: PE) =
    pe.next_north = -100.0
    pe.next_west = -100.0
    pe.north = 0.0
    pe.west = 0.0
    pe.accumulated = 0.0

proc new*(_: typedesc[PE]): PE =
    return PE(next_north: 0.0, next_west: 0.0, north: 0.0, west: 0.0, east: nil, south: nil, accumulated: 0.0)

##################################################################

type Board*[N: static[int]] = Matrix[N, N, PE]

proc initBoard*[N: static[int]](): Board[N] =
    for i in 0..<N*N:
        result.data[i] = PE.new()
    
    for r in 0..<N:
        for c in 0..<N:
            if r < (N-1): result[r, c].south = result[r + 1, c]
            if c < (N-1): result[r, c].east = result[r, c + 1]

proc `$`[N: static[int]](board: Board[N]): string =
    for r in 0..<N:
        for c in 0..<N:
            result &= $board[r, c].accumulated & " "
        result &= "\n"

proc tick*[N: static[int]](board: Board[N]) =
    for cell in board.data:
        cell.accumulate_and_pass
    for cell in board.data:
        cell.shift_inputs

proc clear*[N: static[int]](board: Board[N]) =
    for cell in board.data:
        cell.clear

proc do_matrix_equal*[N: static[int]](board: Board[N], m1: Matrix[N, N, float], m2: Matrix[N, N, float], m0: var Matrix[N, N, float]) =
    for clock in 0..<(N + N + N - 2 + 1):
        # west 
        for i in 0..<N:
            board[i, 0].west = if (i <= clock) and (clock <= (N-1+i)): m1[i, clock-i]
                                else: 0.0
        # north
        for i in 0..<N:
            board[0, i].north = if (i <= clock) and (clock <= (N-1+i)): m2[clock-i, i]
                                else: 0.0
        board.tick
    for i in 0..<N*N:
        m0.data[i] = board.data[i].accumulated

# please do not judge me for this inefficiency
proc do_matrix_blocks*[N, R0, N0, C0: static[int]](board: Board[N], m1: Matrix[R0, N0, float], m2: Matrix[N0, C0, float], m0: var Matrix[R0, C0, float]) =
    static:
        doAssert(R0 mod N == 0, "Row must be divisible by board's row.")
        doAssert(C0 mod N == 0, "Column must be divisible by board's column")
        doAssert(N0 mod N == 0, "Inner dimension must be divisible by board's row.")
    const BR = R0 div N
    const IN = N0 div N
    const BC = C0 div N
    
    var blocks_i1 = Matrix[BR, BC, Matrix[N, N, float]]()
    var blocks_i2 = Matrix[BR, BC, Matrix[N, N, float]]()
    var blocks_o0 = Matrix[BR, BC, Matrix[N, N, float]]()

    template chunk_matrix(block_rows, block_cols, inpm, outm) =
        for block_r in 0..<block_rows:
            for block_c in 0..<block_cols:
                var blockm = Matrix[N, N, float]()
                for r in 0..<N:
                    for c in 0..<N:
                        blockm[r, c] = inpm[r + block_r * N, c + block_c * N]
                outm[block_r, block_c] = blockm
    
    chunk_matrix(BR, IN, m1, blocks_i1)
    chunk_matrix(IN, BC, m2, blocks_i2)
    
    # Now output.
    for block_r in 0..<BR:
        for block_c in 0..<BC:
            for k in 0..<IN:
                board.clear()
                var block_mul_output = Matrix[N, N, float]()
                board.do_matrix_equal(blocks_i1[block_r, k], blocks_i2[k, block_c], block_mul_output)
                blocks_o0[block_r, block_c] = blocks_o0[block_r, block_c] + block_mul_output
    
    for block_r in 0..<BR:
        for block_c in 0..<BC:
            for r in 0..<N:
                for c in 0..<N:
                    m0[r + block_r * N, c + block_c * N] = blocks_o0[block_r, block_c][r, c]


##################################################################

proc do_matrix*[N, R0, N0, C0: static[int]](board: Board[N], m1: Matrix[R0, N0, float], m2: Matrix[N0, C0, float], m0: var Matrix[R0, C0, float]) =
    when (R0 == N) and (C0 == N):
        do_matrix_equal(board, m1, m2, m0)
    else:
        do_matrix_blocks(board, m1, m2, m0)

##################################################################

var board = initBoard[5]()

block b_5x5_on_board:
    var m0 = Matrix[5, 5, float]()
    var m1 = Matrix[5, 5, float](data:[
        1.0, 2.0, 3.0, 4.0, 5.0,
        6.0, 7.0, 8.0, 9.0, 10.0,
        11.0, 12.0, 13.0, 14.0, 15.0,
        16.0, 17.0, 18.0, 19.0, 20.0,
        21.0, 22.0, 23.0, 24.0, 25.0
    ])
    board.do_matrix(m1, m1, m0)
    echo m0

block b_10x10_on_board:
    var m3 = Matrix[10, 10, float]()
    var m2 = Matrix[10, 10, float](data:[
        1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0,
        11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 17.0, 18.0, 19.0, 20.0,
        21.0, 22.0, 23.0, 24.0, 25.0, 26.0, 27.0, 28.0, 29.0, 30.0,
        31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0,
        41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0,
        51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0,
        61.0, 62.0, 63.0, 64.0, 65.0, 66.0, 67.0, 68.0, 69.0, 70.0,
        71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0,
        81.0, 82.0, 83.0, 84.0, 85.0, 86.0, 87.0, 88.0, 89.0, 90.0,
        91.0, 92.0, 93.0, 94.0, 95.0, 96.0, 97.0, 98.0, 99.0, 100.0
    ])
    board.clear
    board.do_matrix(m2, m2, m3)
    echo m3

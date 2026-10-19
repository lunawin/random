# Did at uni computer lab, 19.10.2026
import std/strformat

type Matrix*[R, C: static[int], T] = object
    data*: array[R*C, T]

proc `[]`*[R, C: static[int], T](m: Matrix[R, C, T], r, c: int): T =
    return m.data[r * C + c]

proc `[]=`*[R, C: static[int], T](m: var Matrix[R, C, T], r, c: int, v: T) =
    m.data[r * C + c] = v

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

type Board*[R, C: static[int]] = Matrix[R, C, PE]

proc initBoard*[R, C: static[int]](): Board[R, C] =
    for i in 0..<R*C:
        result.data[i] = PE.new()
    
    for r in 0..<R:
        for c in 0..<C:
            if r < (R-1): result[r, c].south = result[r + 1, c]
            if c < (C-1): result[r, c].east = result[r, c + 1]

proc `$`[R, C: static[int]](board: Board[R, C]): string =
    for r in 0..<R:
        for c in 0..<C:
            result &= $board[r, c].accumulated & " "
        result &= "\n"

proc tick*[R, C: static[int]](board: Board[R, C]) =
    for cell in board.data:
        cell.accumulate_and_pass
    for cell in board.data:
        cell.shift_inputs

proc clear*[R, C: static[int]](board: Board[R, C]) =
    for cell in board.data:
        cell.clear

proc do_matrix_equal*[R, N, C: static[int]](board: Board[R, C], m1: Matrix[R, N, float], m2: Matrix[N, C, float], m0: var Matrix[R, C, float]) =
    for clock in 0..<(R + N + C - 2 + 1):
        # west 
        for i in 0..<R:
            board[i, 0].west = if (i <= clock) and (clock <= (N-1+i)): m1[i, clock-i]
                                else: 0.0
        # north
        for i in 0..<C:
            board[0, i].north = if (i <= clock) and (clock <= (N-1+i)): m2[clock-i, i]
                                else: 0.0
        board.tick
    for i in 0..<R*C:
        m0.data[i] = board.data[i].accumulated

proc do_matrix_blocks*[R, C, R0, N0, C0: static[int]](board: Board[R, C], m1: Matrix[R0, N0, float], m2: Matrix[N0, C0, float], m0: var Matrix[R0, C0, float]) =
    static:
        doAssert(R0 mod R == 0, "Row must be divisible by board's row.")
        doAssert(C0 mod C == 0, "Column must be divisible by board's column")
        doAssert(N0 mod R == 0, "Inner dimension must be divisible by board's row.")
        doAssert(N0 mod C == 0, "Inner dimension must be divisible by board's column.")
    echo fmt"BOARD={R} x {C}, Matrix1 = {R0} x {N0}, Matrix2 = {N0} x {C0}, OUT = {R0} x {C0}"
    # TODO: Block multiplication
    # O = A x B [where A is R x N and B is N x C then O = R x C]
    # Oij = sum[k = 0 to N] Aik * Bkj

##################################################################

proc do_matrix*[R, C, R0, N0, C0: static[int]](board: Board[R, C], m1: Matrix[R0, N0, float], m2: Matrix[N0, C0, float], m0: var Matrix[R0, C0, float]) =
    when (R0 == R) and (C0 == C):
        do_matrix_equal(board, m1, m2, m0)
    else:
        do_matrix_blocks(board, m1, m2, m0)

##################################################################

var board = initBoard[5, 5]()

var m0 = Matrix[5, 5, float]()
var m1 = Matrix[5, 5, float](data:[
    1.0, 2.0, 3.0, 4.0, 5.0,
    6.0, 7.0, 8.0, 9.0, 10.0,
    11.0, 12.0, 13.0, 14.0, 15.0,
    16.0, 17.0, 18.0, 19.0, 20.0,
    21.0, 22.0, 23.0, 24.0, 25.0
])
echo m0
board.do_matrix(m1, m1, m0)
echo m0

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
echo board

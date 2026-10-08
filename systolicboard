# Attempt at 5.10.2026, at uni computer labs

type DPU = ref object
    west: float
    north: float
    next_west: float
    next_north: float
    east: DPU
    south: DPU
    accumulator: float

type SystolicBoard = ref object
    units: seq[DPU]
    row_size: int
    col_size: int

type Matrix[A, B: static[int]] = array[A*B, float]

proc `[]`*[R, C: static[int]](matrix: Matrix[R, C], r: int, c: int): float =
    return matrix[r * C + c]

proc `[]`*(sb: SystolicBoard, r: int, c: int): DPU =
    return sb.units[r * sb.col_size + c]

proc new*(_: typedesc[DPU]): DPU =
    result = DPU(west: 0.0, north: 0.0, next_west: 0.0, next_north: 0.0, east: nil, south: nil, accumulator: 0.0)

proc new*(_: typedesc[SystolicBoard], row: int, col: int): SystolicBoard =
    result = SystolicBoard(
        units: @[],
        row_size: row,
        col_size: col
    )
    for _ in 0..<(row*col):
        result.units.add(DPU.new())
    
    for i in 0..<row:
        for j in 0..<col:
            if j < (col-1):
                result[i, j].east = result[i, j+1]
            if i < (row-1):
                result[i, j].south = result[i+1, j]
    
proc `$`(sb: SystolicBoard): string =
    result = ""
    for i in 0..<sb.row_size:
        for j in 0..<sb.col_size:
            result &= $sb[i, j].accumulator
            result &= " "
        result &= "\n"

proc process*(u: DPU) =
    u.accumulator += u.west * u.north
    if not u.east.isNil:
        u.east.next_west = u.west
    if not u.south.isNil:
        u.south.next_north = u.north

proc swap*(u: DPU) =
    u.west = u.next_west
    u.north = u.next_north
    u.next_west = -0.5 # make it noticeable just incase it leaks
    u.next_north = -0.5

proc tick*(board: SystolicBoard) =
    for dpu in board.units:
        dpu.process()
    for dpu in board.units:
        dpu.swap()

################################################################################

# gonna just write sloppy code here (as if above isnt sloppy...)
# Hardcoded for 3x3 ...
proc do_matrix_example*() =
    var sb = SystolicBoard.new(3, 3)
    var m1 = @[ 
        1.0, 2.0, 3.0,
        4.0, 5.0, 6.0,
        7.0, 8.0, 9.0
    ]
    var m2 = @[
        10.0, 11.0, 12.0,
        13.0, 14.0, 15.0,
        16.0, 17.0, 18.0
    ]
    # for M x K * K x N, clock = M + N + K - 2
    # since both are 3x3 * 3x3
    # one more cycle for values to settle into final numbers
    var total_clock_needed = 3 + 3 + 3 - 2 + 1
    var clock = 0

    while clock < total_clock_needed:
        # entering inputs

        # left side
        sb[0, 0].west = if (0 <= clock) and (clock <= 2): m1[0 * 3 + (clock - 0)]
                        else: 0.0
        sb[1, 0].west = if (1 <= clock) and (clock <= 3): m1[1 * 3 + (clock - 1)]
                        else: 0.0
        sb[2, 0].west = if (2 <= clock) and (clock <= 4): m1[2 * 3 + (clock - 2)]
                        else: 0.0
        # now up side
        sb[0, 0].north = if (0 <= clock) and (clock <= 2): m2[(clock - 0) * 3 + 0]
                        else: 0.0
        sb[0, 1].north = if (1 <= clock) and (clock <= 3): m2[(clock - 1) * 3 + 1]
                        else: 0.0
        sb[0, 2].north = if (2 <= clock) and (clock <= 4): m2[(clock - 2) * 3 + 2]
                        else: 0.0
        
        sb.tick()
        echo sb
        clock.inc
        
# Actual, generalized function
proc do_matrix[M, N, K: static[int]](sb: SystolicBoard, m1: Matrix[M, K], m2: Matrix[K, N]) =
    const clocks_needed = M + N + K - 2 + 1
    var clock = 0
    while clock < clocks_needed:
        discard # 16.17: had to leave cus of lab ending

var sb = SystolicBoard.new(5, 5)
var m1: Matrix[5,5] = [
    1.0, 2.0, 3.0, 4.0, 5.0,
    6.0, 7.0, 8.0, 9.0, 10.0,
    11.0, 12.0, 13.0, 14.0, 15.0,
    16.0, 17.0, 18.0, 19.0, 20.0,
    21.0, 22.0, 23.0, 24.0, 25.0
]
var m2: Matrix[5,5] = [
    1.0, 2.0, 3.0, 4.0, 5.0,
    6.0, 7.0, 8.0, 9.0, 10.0,
    11.0, 12.0, 13.0, 14.0, 15.0,
    16.0, 17.0, 18.0, 19.0, 20.0,
    21.0, 22.0, 23.0, 24.0, 25.0
]
sb.do_matrix(m1, m2)
echo sb
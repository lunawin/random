# did in uni computer labs, ceng1009
# at 2/10/2026

import std/math
import std/os

const permutations = @[
    151, 160, 137,  91,  90,  15, 131,  13, 201,  95,  96,  53, 194, 233,   7, 225,
    140,  36, 103,  30,  69, 142,   8,  99,  37, 240,  21,  10,  23, 190,   6, 148,
    247, 120, 234,  75,   0,  26, 197,  62,  94, 252, 219, 203, 117,  35,  11,  32,
     57, 177,  33,  88, 237, 149,  56,  87, 174,  20, 125, 136, 171, 168,  68, 175,
     74, 165,  71, 134, 139,  48,  27, 166,  77, 146, 158, 231,  83, 111, 229, 122,
     60, 211, 133, 230, 220, 105,  92,  41,  55,  46, 245,  40, 244, 102, 143,  54,
     65,  25,  63, 161,   1, 216,  80,  73, 209,  76, 132, 187, 208,  89,  18, 169,
    200, 196, 135, 130, 116, 188, 159,  86, 164, 100, 109, 198, 173, 186,   3,  64,
     52, 217, 226, 250, 124, 123,   5, 202,  38, 147, 118, 126, 255,  82,  85, 212,
    207, 206,  59, 227,  47,  16,  58,  17, 182, 189,  28,  42, 223, 183, 170, 213,
    119, 248, 152,   2,  44, 154, 163,  70, 221, 153, 101, 155, 167,  43, 172,   9,
    129,  22,  39, 253,  19,  98, 108, 110,  79, 113, 224, 232, 178, 185, 112, 104,
    218, 246,  97, 228, 251,  34, 242, 193, 238, 210, 144,  12, 191, 179, 162, 241,
     81,  51, 145, 235, 249,  14, 239, 107,  49, 192, 214,  31, 181, 199, 106, 157,
    184,  84, 204, 176, 115, 121,  50,  45, 127,   4, 150, 254, 138, 236, 205,  93,
    222, 114,  67,  29,  24,  72, 243, 141, 128, 195,  78,  66, 215,  61, 156, 180,

    151, 160, 137,  91,  90,  15, 131,  13, 201,  95,  96,  53, 194, 233,   7, 225,
    140,  36, 103,  30,  69, 142,   8,  99,  37, 240,  21,  10,  23, 190,   6, 148,
    247, 120, 234,  75,   0,  26, 197,  62,  94, 252, 219, 203, 117,  35,  11,  32,
     57, 177,  33,  88, 237, 149,  56,  87, 174,  20, 125, 136, 171, 168,  68, 175,
     74, 165,  71, 134, 139,  48,  27, 166,  77, 146, 158, 231,  83, 111, 229, 122,
     60, 211, 133, 230, 220, 105,  92,  41,  55,  46, 245,  40, 244, 102, 143,  54,
     65,  25,  63, 161,   1, 216,  80,  73, 209,  76, 132, 187, 208,  89,  18, 169,
    200, 196, 135, 130, 116, 188, 159,  86, 164, 100, 109, 198, 173, 186,   3,  64,
     52, 217, 226, 250, 124, 123,   5, 202,  38, 147, 118, 126, 255,  82,  85, 212,
    207, 206,  59, 227,  47,  16,  58,  17, 182, 189,  28,  42, 223, 183, 170, 213,
    119, 248, 152,   2,  44, 154, 163,  70, 221, 153, 101, 155, 167,  43, 172,   9,
    129,  22,  39, 253,  19,  98, 108, 110,  79, 113, 224, 232, 178, 185, 112, 104,
    218, 246,  97, 228, 251,  34, 242, 193, 238, 210, 144,  12, 191, 179, 162, 241,
     81,  51, 145, 235, 249,  14, 239, 107,  49, 192, 214,  31, 181, 199, 106, 157,
    184,  84, 204, 176, 115, 121,  50,  45, 127,   4, 150, 254, 138, 236, 205,  93,
    222, 114,  67,  29,  24,  72, 243, 141, 128, 195,  78,  66, 215,  61, 156, 180 
]


# 6t^5 - 15t^4 + 10t^3
func fade(t: float): float = t * t * t * (t * (t * 6 - 15) + 10)
func lerp(t, a, b: float): float = a + t * (b - a)

func grad(hash: int, x, y, z: float): float =
    var h = hash and 15
    var u = if h < 8: x
            else: y
    
    var v = if h < 4: y
            elif (h == 12) or (h == 14): x
            else: z
    
    var part1 = if (h and 1) == 0: u
                else: -u
    var part2 = if (h and 2) == 0: v
                else: -v
    return part1 + part2

func perlin(ix, iy, iz: float): float =
    var X = floor(ix).toInt and 255
    var Y = floor(iy).toInt and 255
    var Z = floor(iz).toInt and 255

    var x = ix - floor(ix)
    var y = iy - floor(iy)
    var z = iz - floor(iz)

    var u = fade(x)
    var v = fade(y)
    var w = fade(z)

    var A  = permutations[X  ] + Y
    var AA = permutations[A  ] + Z
    var AB = permutations[A+1] + Z
    var B  = permutations[X+1] + Y
    var BA = permutations[B  ] + Z
    var BB = permutations[B+1] + Z

    var part_000 = grad(permutations[AA+0], x - 0, y - 0, z - 0)
    var part_001 = grad(permutations[BA+0], x - 1, y - 0, z - 0)
    var part_010 = grad(permutations[AB+0], x - 0, y - 1, z - 0)
    var part_011 = grad(permutations[BB+0], x - 1, y - 1, z - 0)
    var part_100 = grad(permutations[AA+1], x - 0, y - 0, z - 1)
    var part_101 = grad(permutations[BA+1], x - 1, y - 0, z - 1)
    var part_110 = grad(permutations[AB+1], x - 0, y - 1, z - 1)
    var part_111 = grad(permutations[BB+1], x - 1, y - 1, z - 1)

    return lerp(
        w,
        lerp(
            v,
            lerp(u, part_000, part_001),
            lerp(u, part_010, part_011)
        ),
        lerp(
            v,
            lerp(u, part_100, part_101),
            lerp(u, part_110, part_111)
        ),
    )

func perlin_fbm(ix, iy, iz: float, octaves = 4, freq_mul = 2.0, ampl_mul = 0.5): float =
    var total = 0.0
    var cur_ampl = 1.0
    var cur_freq = 1.0
    var normalization_val = 0.0

    for _ in 0..<octaves:
        total += cur_ampl * perlin(
            ix * cur_freq,
            iy * cur_freq,
            iz * cur_freq
        )
        normalization_val += cur_ampl
        cur_ampl *= ampl_mul
        cur_freq *= freq_mul
    return total / normalization_val

    
proc render_simple(w, h: int, z: float, scale: float) =
    var chars = " .:-=+*#%@"
    for y in 0..<h:
        for x in 0..<w:
            var output = perlin(x.toFloat * scale, y.toFloat * scale, z)
            output += 1.0;
            output /= 2.0
            output *= chars.len.toFloat - 0.01
            var character = chars[floor(output).toInt]
            stdout.write(character)
        stdout.write("\n")

proc render_fbm(w, h: int, z: float, scale: float, octaves = 4, freq_mul = 2.0, ampl_mul = 0.5) =
    var chars = " .:-=+*#%@"
    for y in 0..<h:
        for x in 0..<w:
            var output = perlin_fbm(x.toFloat * scale, y.toFloat * scale, z, octaves, freq_mul, ampl_mul)
            output += 1.0;
            output /= 2.0
            output *= chars.len.toFloat - 0.01
            var character = chars[floor(output).toInt]
            stdout.write(character)
        stdout.write("\n")

when isMainModule:
    var t = 0.0
    while true:
        stdout.write("\e[H\e[2J")
        render_fbm(100, 30, t, 0.02, 5, 2.5, 0.45)
        sleep(1000 div 60)
        t += 0.03
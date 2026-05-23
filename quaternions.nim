#[
written at 11/07/2025
uploaded at 23/05/2026

jk = -kj = i
ki = -ik = j
ij = -ji = k

i² = j² = k² = -1
ijk = -1

q0 = a0 + b0i + c0j + d0k
q1 = a1 + b1i + c1j + d1k

q0 * q1 = (a0 + b0i + c0j + d0k) * (a1 + b1i + c1j + d1k)

a0  * (a1 + b1i + c1j + d1k) = a0a1  + a0b1i + a0c1j + a0d1k
                             = a0a1 + a0b1i + a0c1j + a0d1k
b0i * (a1 + b1i + c1j + d1k) = b0a1i - b0b1  + b0c1k - b0d1j
                             = -b0b1 + b0a1i - b0d1j + b0c1k
c0j * (a1 + b1i + c1j + d1k) = c0a1j - c0b1k - c0c1  + c0d1i
                             = -c0c1 + c0d1i + c0a1j - c0b1k
d0k * (a1 + b1i + c1j + d1k) = d0a1k + d0b1j - d0c1i - d0d1
                             = -d0d1 - d0c1i + d0b1j + d0a1k

 a0a1 + a0b1i + a0c1j + a0d1k
-b0b1 + b0a1i - b0d1j + b0c1k
-c0c1 + c0d1i + c0a1j - c0b1k
-d0d1 - d0c1i + d0b1j + d0a1k

(a0a1 - b0b1 - c0c1 - d0d1)  +
(a0b1 + b0a1 + c0d1 - d0c1)i +
(a0c1 - b0d1 + c0a1 + d0b1)j +
(a0d1 + b0c1 - c0b1 + d0a1)k

q0* = a0 - b0i - c0j - d0k

q0 * q0* = (a0 + b0i + c0j + d0k)(a0 - b0i - c0j - d0k)
       a0  * (a0 - b0i - c0j - d0k) = a0a0 - a0b0i - a0c0j - a0d0k
       b0i * (a0 - b0i - c0j - d0k) = b0b0 + b0a0i + b0d0j - b0c0k
       c0j * (a0 - b0i - c0j - d0k) = c0c0 - c0d0i + c0a0j + c0b0k
       d0k * (a0 - b0i - c0j - d0k) = d0d0 + d0c0i - d0b0j + d0a0k

(a0a0 + b0b0 + c0c0 + d0d0)   = a^2 + b^2 + c^2 + d^2 +
(-a0b0 + b0a0 - c0d0 + d0c0)i = 0i = 0 +
(-a0c0 + b0d0 + c0a0 - d0b0)j = 0j = 0 + 
(-a0d0 - b0c0 + c0b0 + d0a0)k = 0k = 0 +
= a^2 + b^2 + c^2 + d^2
= q0q0* = ||q0||^2


qq^-1 = 1
 q^-1 = q*/||q0||^2
q * q*/||q0||^2 = ||q0||^2/||q0||^2 = 1
------------------------------------------------------------------------------
q_rotation = cos(theta/2) + sin(theta/2)u for u axis vector in ai + bj + ck
||q_rotation|| = 1
cos(theta/2)^2 + sin(theta/2)^2x^2 + sin(theta/2)^2y^2 + sin(theta/2)^2z^2
cos(theta/2)^2 + sin(theta/2)^2 [x^2 + y^2 + z^2]
                                     ^ = 1
cos(theta/2)^2 + sin(theta/2)^2 = 1
hence ||q_rotation|| = 1 if ||u|| = 1
           ^ so it is sufficient to check ||u|| = 1


q = cos(theta/2) + sin(theta/2)u
q^-1 = [cos(theta/2) - sin(theta/2)u]/||q|| = cos(theta/2) - sin(theta/2)u
q^-1 = q* if ||q|| = 1, which is always true in rotation quaternions, so in rotation quaternions
q^-1 = q*

if a and b are pure quaternions (no scalar)
ab = -a.b + a x b
a.b = (ab + ba) / 2
a x b = (ab - ba)/2
a^2 = -a . a = -||a||^2

v_rotated = qvq^-1
v_rotated = [cos(theta/2) + sin(theta/2)u] * v * [cos(theta/2) - sin(theta/2)u]
 
for ease of writing, A = cos(theta/2), B = sin(theta/2)
v_rotated = (A+Bu)v(A-Bu)
          = (Av + Buv)(A-Bu)
          = (AAv - ABvu + ABuv - BBuvu)
          = AAv - ABvu + ABuv - BBuvu
          = AB[uv - vu] + [AAv - BBuvu]
       AB[uv - vu] = 2AB(u x v)
       AAv - BBuvu
       u(vu) = u[-v.u + v x u]
              -u(v.u) + u(v x u)
              -(v.u)u - u.(v x u) + u x (v x u)
                         v x u is perp, so dot product 0
                                      u x (v x u) = v(u.u) - u(u. v)
                                                       u.u = 1
                                                     v - u(u.v)
             -(v.u)u + v - u(u.v)
        u(vu) = v - 2(v.u)u
        AAV - BBuvu
        AAV - BB[v - 2(v.u)u]
v_rotated = 2AB(u x v) + AAv - BB[v - 2(v.u)u]
          = 2AB(u x v) + AAv - BBv + BB2(v.u)u
          = v(AA - BB) + 2AB(u x v) + BB2(v.u)u
A = cos(theta/2)
B = sin(theta/2)
          = v(cos^2(theta/2) - sin^2(theta/2)) + 2cos(theta/2)sin(theta/2)(u x v) + 2sin^2(theta/2)(v.u)u
                                                                                2sin^2(theta/2) = 1-cos(theta)
v_rotated = cos(theta)v + sin(theta)(u x v) + (1-cos(theta))(v.u)u

easier to do v_rotated = qvq^-1 for q = cos(theta/2) + sin(theta/2)u for u unit axis vector, but it is good to know this
]#

import std/strformat
import math

type Quaternion* = ref object
   a*: float64
   b*: float64
   c*: float64
   d*: float64

proc `+`*(number: float64, v: Quaternion): Quaternion {.inline.} =
   result = Quaternion(
      a: number + v.a,
      b: v.b,
      c: v.c,
      d: v.d
   )

proc `+`*(v: Quaternion, number: float64): Quaternion {.inline.} =
   result = number + v

proc `+`*(v1, v2: Quaternion): Quaternion {.inline.} =
   result = Quaternion(
      a: v1.a + v2.a,
      b: v1.b + v2.b,
      c: v1.c + v2.c,
      d: v1.d + v2.d
   )

proc `-`*(number: float64, v: Quaternion): Quaternion {.inline.} =
   result = Quaternion(
      a: number - v.a,
      b: -v.b,
      c: -v.c,
      d: -v.d
   )

proc `-`*(v: Quaternion, number: float64): Quaternion {.inline.} =
   result = Quaternion(
      a: v.a - number,
      b: v.b,
      c: v.c,
      d: v.d
   )

proc `-`*(v1, v2: Quaternion): Quaternion {.inline.} =
   result = Quaternion(
      a: v1.a - v2.a,
      b: v1.b - v2.b,
      c: v1.c - v2.c,
      d: v1.d - v2.d
   )

proc `*`*(scalar: float64, v: Quaternion): Quaternion {.inline.} =
   result = Quaternion(
      a: scalar * v.a,
      b: scalar * v.b,
      c: scalar * v.c,
      d: scalar * v.d
   )

proc `*`*(v: Quaternion, scalar: float64): Quaternion {.inline.} =
   result = scalar * v

proc `*`*(v1, v2: Quaternion): Quaternion {.inline.} = 
   let a = (v1.a * v2.a) - (v1.b * v2.b) - (v1.c * v2.c) - (v1.d * v2.d)
   let b = (v1.a * v2.b) + (v1.b * v2.a) + (v1.c * v2.d) - (v1.d * v2.c)
   let c = (v1.a * v2.c) - (v1.b * v2.d) + (v1.c * v2.a) + (v1.d * v2.b)
   let d = (v1.a * v2.d) + (v1.b * v2.c) - (v1.c * v2.b) + (v1.d * v2.a)
   
   result = Quaternion(
      a: a,
      b: b,
      c: c,
      d: d
   )

proc `/`*(v: Quaternion, num: float64): Quaternion {.inline.} =
   result = Quaternion(
      a: v.a / num,
      b: v.b / num,
      c: v.c / num,
      d: v.d / num
   )

proc `==`*(v1, v2: Quaternion): bool {.inline.} =
   if not almostEqual(v1.a, v2.a): return false
   if not almostEqual(v1.b, v2.b): return false
   if not almostEqual(v1.c, v2.c): return false
   if not almostEqual(v1.d, v2.d): return false
   return true

proc norm_squared*(v: Quaternion): float64 {.inline.} =
   return (v.a*v.a) + (v.b*v.b) + (v.c*v.c) + (v.d*v.d)

proc norm*(v: Quaternion): float64 {.inline.} =
   return sqrt((v.a*v.a) + (v.b*v.b) + (v.c*v.c) + (v.d*v.d))

proc conj*(v: Quaternion): Quaternion {.inline.} =
   result = Quaternion(
      a: v.a,
      b: -v.b,
      c: -v.c,
      d: -v.d
   )

proc inverse*(v: Quaternion): Quaternion {.inline.} =
   result = v.conj / v.norm_squared

proc `$`*(v: Quaternion): string {.inline.} =
   result = fmt"{v.a}"

   if v.b >= 0.0:
      result &= fmt" + {v.b}i"
   else:
      result &= fmt" - {-v.b}i"
   
   if v.c >= 0.0:
      result &= fmt" + {v.c}j"
   else:
      result &= fmt" - {-v.c}j"
   
   if v.d >= 0.0:
      result &= fmt" + {v.d}k"
   else:
      result &= fmt" - {-v.d}k"

proc makeRotation*(theta: float64, v_x, v_y, v_z: float64): Quaternion {.inline.} =
   # to be used as v_rot = qvq^-1
   let magn = sqrt(v_x*v_x + v_y*v_y + v_z*v_z)

   result = Quaternion(
      a: cos(theta/2),
      b: sin(theta/2) * v_x / magn,
      c: sin(theta/2) * v_y / magn,
      d: sin(theta/2) * v_z / magn,
   )

when isMainModule:
   # convenience
   let i* = Quaternion(a:0, b:1, c:0, d:0)
   let j* = Quaternion(a:0, b:0, c:1, d:0)
   let k* = Quaternion(a:0, b:0, c:0, d:1)

   let qu = 1 + 0*i + 0*j + 0*k

   let q1 =  2 + 1*i - 3*j + 4*k
   let q2 = -1 + 5*i + 2*j - 0.5*k

   echo fmt"   q1: {q1}"
   echo fmt"   q2: {q2}"
   
   echo fmt"""
   q1 + q2   : {q1 + q2}
   q1 - q2   : {q1 - q2}
   2.5 * q1  : {2.5 * q1}
   q1 * q2   : {q1 * q2}
   ||q1||    : {q1.norm}
   conj(q1)  : {q1.conj}
   q^-1      : {q1.inverse}
   5 + q1    : {5 + q1}
   q1 + 5    : {q1 + 5}
   5 - q1    : {5 - q1}
   q1 - 5    : {q1 - 5}
   q1q1^-1   : {q1 * q1.inverse}
   q1^-1q1   : {q1.inverse * q1}  
   """

   let q_r = makeRotation(PI, 1.0, 1.0, 1.0)
   let q3 = 1*i + 5*j + 4*k
   let result = (q_r * q3) * q_r.inverse
   echo fmt"q3: {q3}"
   echo fmt"rotation quaternion: {q_r}"
   echo result

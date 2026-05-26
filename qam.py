"""
written in 26/05/2026

1024 QAM. Meaning we will send 10 bits. (2**10 = 1024)
Physically, orthogonal waves do not interfere.
We can represent that by complex numbers
where we have 2 coordinations: I*a + Q*b
That means we can send 5 bits each without them interfering
each other.

So we have 10 bit.
We split that into two 5 bit pairs.
Because we are sending over analog signal which is noisy,
we have wave itself spaced between -31 to +31. Skipping the evens.
(2 * n - 31 where n starts from 0b00000)

However rather than doing that, we instead use gray codes.
Essentially they are codes where neighbours only change in 1 bit.
For 2 bits: 00, 01, 11, 10 or 00, 10, 11, 01.
If we list those down then reflect and add 0 to top and 1 to bottom:
000
001
011
010
--
110
111
101
100
We get gray code for 3 bits.

Note that this is one of many methods to produce gray codes, this is called reflect method.
There are multiple ways to do gray codes for specific bits afterall.
One simple is n ^ (n >> 1).

Once we convert each 5 digit into gray code then into analog equivalent, we simply send them as waves.
Then in receiving side, we map  [-31, 31] back into [0, 31] by applying reverse ((n + 31)/2)
Then undo the gray code.
Then merge the bits and we get 10 bits of data.
"""

def gray_of_binary(num):
    return num ^ (num >> 1)
def binary_of_gray(gray):
    get_bit = lambda s: ((gray & (1 << s)) >> s)
    first_digit  = get_bit(4) ^ 0; # Technically previous digit is 0...
    second_digit = get_bit(3) ^ first_digit
    third_digit  = get_bit(2) ^ second_digit
    fourth_digit = get_bit(1) ^ third_digit
    fifth_digit  = get_bit(0) ^ fourth_digit
    binary = 0
    binary |= first_digit  << 4
    binary |= second_digit << 3
    binary |= third_digit  << 2
    binary |= fourth_digit << 1
    binary |= fifth_digit  << 0
    return binary

def radio_of_num(num):
    return 2 * num - 31
def num_of_radio(radio):
    return int((radio + 31) // 2)

#data = 0b10100_10100
def IQ_of_D10B(data):
    assert ((data >> 10) == 0), f"{data} is not 10 bits."
    high_half = data >> 5
    lower_half = data & 0b11111

    I = radio_of_num(gray_of_binary(high_half))
    Q = radio_of_num(gray_of_binary(lower_half))
    return complex(I, Q)

def D10B_of_IQ(IQ):
    I = IQ.real
    Q = IQ.imag

    high_half = binary_of_gray(num_of_radio(I))
    lower_half = binary_of_gray(num_of_radio(Q))
    return (high_half << 5) | lower_half

test = lambda n: (n == D10B_of_IQ(IQ_of_D10B(n)))
assert test(0)
assert test(560)

while True:
    d10b = int(input("> "))
    if (d10b >> 10):
        print("Not 10 bit!")
        continue
    IQ = IQ_of_D10B(d10b)
    print(f"{IQ}")
    assert d10b == D10B_of_IQ(IQ)

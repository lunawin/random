# thought and written at 24/06/2026
# Same document from qam1024.py
# This is simply generalized version of it

def gray_of_num(num):
    return num ^ (num >> 1)

def num_of_gray(gray):
    num = 0
    while gray > 0:
        num ^= gray
        gray >>= 1
    return num

class QAM:
    def __init__(self, data_size: int):
        if (data_size % 2):
            raise ValueError(f"QAM cannot encode odd bits. Got {data_size}.")
        self.total_bitsize = data_size
        self.data_size = self.total_bitsize // 2
        self.peak = 2**self.data_size - 1

    def __encode_half(self, num: int):
        gray = gray_of_num(num)
        return 2 * gray - self.peak

    def encode(self, num: int):
        if (num < 0):
            raise ValueError(f"Cannot take negative values. Got {num}")
        if num >= 2**self.total_bitsize:
            raise ValueError(f"<QAM{self.total_bitsize}> can only encode up to {2**self.total_bitsize - 1}, got {num}")

        num_I = num >> self.data_size
        num_Q = num - (num_I << self.data_size)

        I = self.__encode_half(num_I)
        Q = self.__encode_half(num_Q)

        return complex(I, Q)

    def __decode_half(self, encoded: float):
        int_part = int(round(encoded))
        gray = (int_part + self.peak) // 2
        return num_of_gray(gray)

    def decode(self, iq: complex):
        I = max(-self.peak, min(iq.real, self.peak))
        Q = max(-self.peak, min(iq.imag, self.peak))

        num_I = self.__decode_half(I)
        num_Q = self.__decode_half(Q)

        return (num_I << self.data_size) | (num_Q)

qam = QAM(int(input("QAM Size? >")))
while True:
    action = input("D or E > ")
    num = int(input("NUM > "))

    if (action.lower() == "e"):
        print(qam.encode(num))
    else:
        q = int(input("q >"))
        print(qam.decode(complex(num, q)))
    print("")

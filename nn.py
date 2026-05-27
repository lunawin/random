"""
written at 23/05/2026
uploaded at 23/05/2026

L = Loss o Layer2 o Layer1 o V
z2 = m2 z1 + b2
z1 = m1 V  + b1

Loss(output) = (output - target)^2
dLoss(output)/doutput = 2(output - target)
dLoss(z2)/dz2 = 2(z2 - target)
^-----------^
  alias as d2


z2 = m2 z1 + b2
dz2/db2 = 0 + 1 = 1

dLoss/db2 = dLoss/dz2 * dz2/db2
          = d2 * 1
          = d2
dLoss/dm2 = dLoss/dz2 * dz2/dm2
          = d2 * z1^T (transpose because delta is row vector, so z1 must be column vector)

going from L2 to L1
dz2/dz1 = d(m2 z1 + b2)/dz1 = m2
dLoss/z1 = dLoss/dz2 * dz2/dz1
^------^    = d2    * m2^T (transpose, same reason)
alias as d1

pass d1 to layer1
dLoss/db1 = dLoss/dz1 * dz1/db1
          =    d1     * 1
          = d1
dLoss/dm1 = dLoss/dz1 * dz1/dm1
          =    d1     * V^T
"""

import numpy as np

layers = []

def add_layer(matrix, bias):
    layers.append([matrix, bias])

def relu(v):
    return np.where(v > 0, v, v * 0.01)

def forward_pass(v1):
    v = v1
    for i, layer in enumerate(layers):
        m = layer[0]
        b = layer[1]
        v = np.dot(m, v) + b
        if (i < (len(layers) - 1)):
            v = relu(v)
    return v

def forward_pass_verbose(v1):
    acts = [v1]
    vs = []
    v = v1
    for i, layer in enumerate(layers):
        m = layer[0]
        b = layer[1]
        v = np.dot(m, v) + b
        vs.append(v)
        if (i < (len(layers) - 1)):
            v = relu(v)
        acts.append(v)
    return (acts, vs)

def change_ends(v, to):
    return str(v).replace("\n", f"\n{to}")

def print_layers():
    for i, layer in enumerate(layers):
        m = layer[0]
        b = layer[1]
        print(f"Layer L{i+1}->L{i+2}:")
        print(f"   M:", change_ends(m, "      "))
        print(f"   B:", change_ends(b, "      "))

def calc_loss(out, tar):
    return np.mean((out - tar) ** 2)

def train_network(iv, ov, repeat, eps, lr):
    for curloop in range(repeat):
        cur_out = forward_pass(iv)
        cur_loss = calc_loss(cur_out, ov)

        updates = []
        for layer in layers:
            m = layer[0]
            b = layer[1]

            m_grad = np.zeros_like(m)
            b_grad = np.zeros_like(b)

            for r in range(m.shape[0]):
                for c in range(m.shape[1]):
                    m[r, c] += eps
                    new_out = forward_pass(iv)
                    new_loss = calc_loss(new_out, ov)
                    m_grad[r, c] = (new_loss - cur_loss) / eps
                    m[r, c] -= eps

            for r in range(b.shape[0]):
                b[r, 0] += eps
                new_out = forward_pass(iv)
                new_loss = calc_loss(new_out, ov)
                b_grad[r, 0] = (new_loss - cur_loss) / eps
                b[r, 0] -= eps

            updates.append((m_grad, b_grad))

        for i, layer in enumerate(layers):
            update = updates[i]
            layer[0] -= lr * update[0]
            layer[1] -= lr * update[1]

def train_network_bp(iv, ov, repeat, lr):
    for curloop in range(repeat):
        acts, vs = forward_pass_verbose(iv)

        updates = [None] * len(layers)
        delta = 2 * (acts[-1] - ov)

        for i in reversed(range(len(layers))):
            m = layers[i][0]
            b = layers[i][1]

            v_inp = acts[i]
            b_grad = np.sum(delta, axis=1, keepdims=True)
            m_grad = np.dot(delta, v_inp.T)
            updates[i] = (m_grad, b_grad)

            if i > 0:
                delta = np.dot(m.T, delta)
                delta *= np.where(vs[i-1] > 0, 1.0, 0.01)

        for i, layer in enumerate(layers):
            update = updates[i]
            layer[0] -= lr * (update[0] / ov.size)
            layer[1] -= lr * (update[1] / ov.size)


# L1 -> L2 (3 -> 3)
m12 = np.array([
    [ 0.612,  0.418, -0.153],
    [-0.204,  0.785,  0.521],
    [ 0.112, -0.340,  0.901]
])
b12 = np.array([
    [ 0.100],
    [ 0.050],
    [-0.020]
])
add_layer(m12, b12)

# L2 -> L3 (3 -> 3)
m23 = np.array([
    [ 0.416, -0.959,  0.123],
    [ 0.940,  0.665, -0.456],
    [-0.575, -0.636,  0.789]
])
b23 = np.array([
    [-0.120],
    [ 0.450],
    [ 0.220]
])
add_layer(m23, b23)

sv = np.array([
    [ 0.157,  0.820, -0.340 ],
    [ 0.219,  0.015,  0.711 ],
    [ 0.513, -0.450,  0.120 ]
])
tv = np.array([
    [ 0.239, -0.110,  0.950 ],
    [-0.210,  0.430,  0.010 ],
    [ 0.200,  0.880, -0.620 ]
])

print_layers()
out = forward_pass(sv)

print(f"SV: ", change_ends(sv, "     "))
print(f"TV: ", change_ends(tv, "     "))
print(f"FP: ", change_ends(out, "     "))

while (True):
    inp = input("> ")
    splt = inp.split(" ")
    cmd = splt[0]
    if (cmd == "train"):
        train_network(sv, tv, int(splt[1]), 1e-5, float(splt[2]))
        out = forward_pass(sv)
        print("TV: ", change_ends(tv , "     "))
        print("SP: ", change_ends(out, "     "))
    elif (cmd == "trainc"):
        train_network_bp(sv, tv, int(splt[1]), float(splt[2]))
        out = forward_pass(sv)
        print("TV: ", change_ends(tv , "     "))
        print("SP: ", change_ends(out, "     "))
    elif (cmd == "exit"):
        break

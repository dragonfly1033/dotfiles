
import sys

if __name__ == "__main__":
    H = float(sys.argv[1])
    S = float(sys.argv[2])/100
    L = float(sys.argv[3])/100


def do(H, S, L):
    C = (1-abs(2*L-1))*S
    X = C * (1-abs((H/60)%2 - 1))
    m = L - C/2

    if   0   <= H <= 60:  Rp, Gp, Bp = C, X, 0
    elif 60  <= H <= 120: Rp, Gp, Bp = X, C, 0
    elif 120 <= H <= 180: Rp, Gp, Bp = 0, C, X
    elif 180 <= H <= 240: Rp, Gp, Bp = 0, X, C
    elif 240 <= H <= 300: Rp, Gp, Bp = X, 0, C
    elif 300 <= H <= 360: Rp, Gp, Bp = C, 0, X

    R, G, B = (Rp+m)*255, (Gp+m)*255, (Bp+m)*255
    R, G, B = round(R), round(G), round(B)

    hexx = hex(R)[2:] + hex(G)[2:] + hex(B)[2:]

    print(hexx)

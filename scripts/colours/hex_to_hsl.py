
import sys

if __name__ == "__main__":
    hexx = sys.argv[1]
    r, g, b = hexx[:2], hexx[2:4], hexx[4:]

def do(r, g, b):
    R = int(f'0x{r}', 16)
    G = int(f'0x{g}', 16)
    B = int(f'0x{b}', 16)
    M = max(R, G, B)
    m = min(R, G, B)
    C = M - m

    if C == 0:   H = 0
    elif M == R: H = 60*(((G-B)/C)%6)
    elif M == G: H = 60*(((B-R)/C)+2)
    elif M == B: H = 60*(((R-G)/C)+4)

    L = (M+m)/(2*255)

    if L == 1 or L == 0: S = 0
    else: S = (C/255)/(1-abs(2*L-1))

    print(round(H), round(100*S), round(100*L))


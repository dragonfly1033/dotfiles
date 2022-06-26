from PIL import Image
import sys
from rgb_to_hex import do as rgb2hex

def dist2(c1, c2):
    dr = c1[0] - c2[0]
    dg = c1[1] - c2[1]
    db = c1[2] - c2[2]
    return (dr**2+dg**2+db**2)

if len(sys.argv) == 0:
    print('script <image> <colour thresh> <sample skip>')
elif sys.argv[1] == '--help':
    print('script <image> <colour thresh> <sample skip>')

im = Image.open(sys.argv[1])
pix = im.load()

cols = set()

thresh = int(sys.argv[2])
skip = int(sys.argv[3])

for y in range(0, im.size[1], skip):
    for x in range(0, im.size[0], skip):
        for c in cols:
            if dist2(pix[x, y], c) < thresh**2:
                break
        else:
            cols.add(pix[x, y])

for i in cols:
    print(rgb2hex(*i))

#!/usr/bin/env python3

import sys

def clamp(n, smallest, largest): 
    return max(smallest, min(n, largest))

color = sys.argv[1]

if not len(color) == 7:
    exit(1)

r = color[1:3]
g = color[3:5]
b = color[5:7]

rgb = (int(r, base=16), int(g, base=16), int(b, base=16))
light = (clamp(int(rgb[0] * 1.2), 0, 255), clamp(int(rgb[1] * 1.2), 0, 255), clamp(int(rgb[2] * 1.2), 0, 255))

print("#" + str(hex(light[0]))[2:] + str(hex(light[1]))[2:] + str(hex(light[2]))[2:])

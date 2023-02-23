#!/usr/bin/env python3

import sys

color = sys.argv[1]

r = int(color[1:3], base=16)
g = int(color[3:5], base=16)
b = int(color[5:7], base=16)

print("rgba(", r, ",", g, ",", b, ", 100%)")

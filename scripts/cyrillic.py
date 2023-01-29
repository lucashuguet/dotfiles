#!/usr/bin/env python3

import sys
import cyrtranslit

args = sys.argv

print(cyrtranslit.to_cyrillic(args[1], "ru"))

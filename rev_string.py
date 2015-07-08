import os
import sys

DLM = ';'

for line in sys.stdin:
    print DLM.join(reversed(line.strip().split(DLM)))

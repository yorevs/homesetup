#!/usr/bin/env python

import sys

total_result = 0
op = '+'

for tm in sys.argv[1:]:
    if tm in [ '+', '-', '*', '/' ]:
        op = tm
    else:
        parts = [int(s) for s in tm.split(':')]
        tm_amount = ((parts[0] * 60 + parts[1]) * 60 + parts[2])
        if op == '+':
            total_result += tm_amount
        else:
            total_result -= tm_amount

total_result, seconds = divmod(total_result, 60)
hours, minutes = divmod(total_result, 60)

print('{0:02d}:{1:02d}:{2:02d}'.format(hours, minutes, seconds))
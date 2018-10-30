#!/usr/bin/env python

#  Script: tcalc.py
# Purpose: Provides time calculations.
# Created: Aug 26, 2017
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: yorevs@hotmail.com
#    Site: https://github.com/yorevs/homesetup

import sys

total_seconds = 0
op = '+'

for tm in sys.argv[1:]:
    if tm in [ '+', '-']:
        op = tm
    else:
        parts = [int(s) for s in tm.split(':')]
        tm_amount = ((parts[0] * 60 + parts[1]) * 60 + parts[2])
        if op == '+':
            total_seconds += tm_amount
        else:
            total_seconds -= tm_amount

total_seconds, seconds = divmod(total_seconds, 60)
hours, minutes = divmod(total_seconds, 60)

print('{0:02d}:{1:02d}:{2:02d}'.format(hours, minutes, seconds))

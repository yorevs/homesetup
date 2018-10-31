#!/usr/bin/env python

"""
  @package: -
   @script: tcalc.py
  @purpose: Provides time calculations.
  @created: Aug 26, 2017
   @author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
   @mailto: yorevs@hotmail.com
      Site: https://github.com/yorevs/homesetup
"""

import sys

total_seconds = 0
op = '+'

for tm in sys.argv[1:]:
    if tm in [ '+', '-' ]:
        op = tm
    else:
        parts = [int(s) for s in tm.split(':')]
        f_hours = parts[0] if len(parts) > 0 else 0
        f_mins = parts[1] if len(parts) > 1 else 0
        f_secs = parts[2] if len(parts) > 2 else 0
        tm_amount = ((f_hours * 60 + f_mins) * 60 + f_secs )
        if op == '+':
            total_seconds += tm_amount
        else:
            total_seconds -= tm_amount

total_seconds, seconds = divmod(total_seconds, 60)
hours, minutes = divmod(total_seconds, 60)

print('{0:02d}:{1:02d}:{2:02d}'.format(hours, minutes, seconds))

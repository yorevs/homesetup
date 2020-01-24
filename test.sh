#!/bin/bash

a=({1..10})
IFS=':' read -r -a b <<< "a:b:c:d:e:f:g:h:i:j"

a+=(11)
b+=(k)

b[0]+="'malia  mada'"
read -r -a c <<< "${b[@]}"

IFS=$'\n' read -d '' -r -a lines <<< `grep -E '^((Mon|Tue|Wed|Thu|Fri|Sat|Sun) )(([0-9]+-?)+) =>.*' "$HHS_PUNCH_FILE"`

echo "a => ${a[*]}"
echo "b => ${b[*]}"
echo "c => ${c[*]}"
echo "lines ${#lines[@]} => ${lines[*]}"
echo "IFS=$IFS"
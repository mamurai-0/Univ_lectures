#!/bin/sh

find . -name "*.c" | xargs wc | sort -n -k 1,1 | sed -e 's/  */ /g' | cut -d" " -f5 | cut -d"/" -f3 | sed '$d' > result.txt

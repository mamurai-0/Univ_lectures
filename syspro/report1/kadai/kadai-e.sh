#!/bin/sh

strace /bin/cat /proc/meminfo > data1.txt
strace -o data2.txt /bin/cat /proc/meminfo
strace -o data3.txt /bin/cat /proc/meminfo >> data3.txt


#!/bin/sh

for i in `seq 0 9`
do
		wget "http://syspro.is.s.u-tokyo.ac.jp/2016/resume/kadai1/1.pdf.0$i"
done

for i in `seq 10 99`
do
		wget "http://syspro.is.s.u-tokyo.ac.jp/2016/resume/kadai1/1.pdf.$i"
done

find -name "1.pdf.*" | sort | sed -e 's!^.*/!!' | xargs cat > 1.pdf

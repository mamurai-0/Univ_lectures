#!/bin/sh

for file in *.cpp
do
		sed -i -e "s/NEET/Hideaki Imamura/" $file
		sed -i -e "s/neet3@example.com/gohome.x105.gn@gmail.com/" $file
		sed -i -e '/^ *$/d' $file
done

for nm in *.cpp
do
		mv $nm ${nm%.cpp}.cc
done


#!/bin/bash


Letters=('a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 'u' 'v' 'w' 'x' 'y' 'z')

for j in {1..11}; do
for i in "${Letters[@]}"; do
	echo "$i" >> $j$i.txt
done
done

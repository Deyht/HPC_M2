#!/bin/sh
FILE=${1%*.f90}
# rm $FILE

mpifort -O3 -Wall -Wno-tabs -Wno-unused-variable $FILE.f90 -o $FILE

mpirun --oversubscribe -n $2 $FILE

#!/bin/bash

TESTS_NUM=10
MAX_THREADS_NUM=16
SYS_INFO_FILE=./data/system_info.txt

if [ ! -f "$SYS_INFO_FILE" ]
then
	echo "Getting system info..."

	lsb_release -a > $SYS_INFO_FILE 2>/dev/null

	echo -e "\n\n" >> $SYS_INFO_FILE
	lscpu >> $SYS_INFO_FILE

	echo -e "\n\n" >> $SYS_INFO_FILE
	free -h >> $SYS_INFO_FILE

	echo -e "\n\n" >> $SYS_INFO_FILE
	echo | cpp -fopenmp -dM | grep -i openmp >> $SYS_INFO_FILE
fi
 
cd src

echo "Compiling"
#gcc -o lab lab.c ../func.c -DTESTS_NUM=$TESTS_NUM -DMAX_THREADS_NUM=$MAX_THREADS_NUM -Wall -O3 -fopenmp

echo "Working..."
#./lab > /tmp/lab_log.txt

echo "Making plots..."
#python3 ./script.py $MAX_THREADS_NUM

echo "Constructing report..."
latexmk -pdf ./report.tex -output-directory="../" 1>/dev/null 2>/dev/null

cd ..

echo "Cleaning..."
latexmk -c ./src/report.tex 2>/dev/null
#rm /tmp/lab_log.txt 2>/dev/null
rm ./lab 2>/dev/null

#!/bin/bash

TESTS_NUM=1
MAX_THREADS_NUM=1
SYS_INFO_FILE=./data/system_info.txt

function create_sys_info_file {
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
}

function compile {
	echo "Compiling"
	gcc -o lab lab.c ../func.c -DTESTS_NUM=$TESTS_NUM -DMAX_THREADS_NUM=$MAX_THREADS_NUM -Wall -O3 -fopenmp
}

function work {
	echo "Working..."
	./lab > /tmp/lab_log.txt
}

function make_plots {
	echo "Making plots..."
	python3 ./script.py $MAX_THREADS_NUM
}

function build_report {
	echo "Building report..."
	latexmk -pdf ./report.tex -output-directory="../" 1>/dev/null 2>/dev/null
}

function cleanup {
	echo "Cleaning..."
	latexmk -c ./src/report.tex 2>/dev/null
	rm /tmp/lab_log.txt 2>/dev/null
	rm ./src/lab 2>/dev/null
}

function main {
	create_sys_info_file
	cd src
	compile
	work
	make_plots
	build_report
	cd ..
	cleanup
}

main
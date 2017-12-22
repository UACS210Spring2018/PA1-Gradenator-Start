#!/bin/sh
# grade.sh is a shell script that runs the given main class
# on all of the inputs (*.in files) in the given input directory.
# Does all this by copying the src/*.java files into TestingTemp/
# and running the tests in TestingTemp/.
#
# usage examples:
#   ./grade.sh JavaHelloWorld PublicTestCases
#   ./grade.sh PA1Main MyTestCases
#
# It is also possible to run the script on an individual file:
#   ./grade.sh JavaHelloWorld PublicTestCases file1.in
#
# The assumption is that each main is operating on standard input.
# The input files in PublicTestCases/ will be redirected into the
# program.  Here are the operations regress.sh performs:
#
#   javac JavaHelloWorld.java
#   java JavaHelloWorld < PublicTestCases/file1.in
#   java JavaHelloWorld < PublicTestCases/file2.in
#
# Another assumption is that all of the source files are in the 
# default package and are in the src/ subdirectory.
#
# FIXME: will also want to be doing a diff 

# Check if we got enough parameters, we need at least 2.
if [ $# -gt 1 ]
then
	# naming command-line parameters to script
    main=$1
    inputdir=$2
    
    # copying over all the source files into TestingTemp/
    # and then moving into that directory.
    cp src/*.java TestingTemp/
    cd TestingTemp/
    
    # compiling the driver and any local files it imports
    echo
    echo "==== compiling $main"
    javac $main.java
    if [ $? -ne 0 ]
    then
    	echo "******************************************"
    	echo "grade.sh ERROR: java compilation failed."
    	#echo "If works in Eclipse, then please contact CS 210 staff."
    	exit 1
	fi

    # if that worked then run it on each file in the given directory
	for infile in `ls ../$inputdir/*.in`
	do
		echo "java $main < $infile"
		java $main < $infile
	done

# Not enough parameters given to script.
else
    echo
    echo "usage: ./grade.sh JavaHelloWorld PublicTestCases"
fi
echo
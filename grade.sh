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
# FIXME: This is not available yet.
# It is also possible to run the script on an individual file:
#   ./grade.sh JavaHelloWorld PublicTestCases file1.in
#
# The assumption is that each main is operating on a given file.
# The input files in the specified input directory will be 
# given to the program.  Here are the operations performed:
#
#   javac JavaHelloWorld.java
#   java JavaHelloWorld PublicTestCases/file1.in
#   java JavaHelloWorld PublicTestCases/file2.in
#	...
#
# Another assumption is that all of the source files are in the 
# default package and are in the src/ subdirectory.
#
#***************************

# Check we need at least 2.
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
    echo ""
    echo "==== compiling $main ===="
    javac $main.java
    if [ $? -ne 0 ]
    then
    	echo "******************************************"
    	echo "grade.sh ERROR: java compilation failed."
    	exit 1
	fi
    
    #gets the total number of tests from the PublicTest directory
    TOTAL_TESTS=$(ls ../$inputdir/*.in | wc -l)
    TESTS_PASSED=0

    echo ""
    # if compilation worked then run it on each file in the given directory
	for infile in `ls -v ../$inputdir/*.in`
	do

        
		java $main $infile > out #runs current test and throws captures output

        #checks if there is a difference between "user output" and "test output"
        #if there is not add one to TESTS_PASSED and print that they passed
        #if not print that they failed and show the failing diff
        #
        #(note) the redirecting to silent is only there to keep the diff op
        #from displaying to stdout
        if diff -B -Z -q out "../$inputdir/$(basename $infile .in).out" > silent
        then
            echo "Passed $main test \"$(basename $infile .in).in\""
            echo ""
            TESTS_PASSED=$((TESTS_PASSED+1))
        else
            echo Failed $main test \"$(basename $infile .in).in\"
            echo "*********** OUTPUT: Actual output followed by expected."
            diff -B -Z out "../$inputdir/$(basename $infile .in).out"
            echo  "*******************************"
            echo ""
        fi
        rm silent
	done
    echo "**** Passed $TESTS_PASSED / $TOTAL_TESTS tests for $main ****"
    echo ""

    #if all passed exit with status 0
    #if not exit with status 1
    if [ "$TOTAL_TESTS" -ne "$TESTS_PASSED" ]
    then
        exit 1
    else
        exit 0
    fi

# Not enough parameters given to script.
else
    echo
    echo "usage: ./grade.sh PA1Main PublicTestCases"
fi
echo

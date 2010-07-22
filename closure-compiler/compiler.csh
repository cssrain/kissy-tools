#!/bin/tcsh
#
# TCSH script for Google compiler
#
# @author mingcheng<i.feelinglucky#gmail.com>
# @date   2009-12-23
# @link   http://www.gracecode.com/

# Jar file path
set COMPILER_JAR = 'compiler.jar'

# Command extra params
set EXTRA_PARAMS = ""

# Error single
set ERROR_NO_JAVA  = 5
set FILE_NOT_MATCH = 10
set JAR_NOT_EXIST  = 15
set COMPRESS_FAILD = 20

# Check Java wether installed
if (`printenv JAVA_HOME` == "") then 
    echo "JAVA_HOME is missing, maybe Java SDK not installed?"
    exit $ERROR_NO_JAVA
endif

# reset jar file with the same path by script 
set -r COMPILER_JAR = "`dirname $0`/$COMPILER_JAR"

# check $COMPILER_JAR whether exit
if (-r $COMPILER_JAR != 1) then
    echo "$COMPILER_JAR not exist"; exit $JAR_NOT_EXIST
endif

# Check input file
if ($1 == "" || -r $1 != 1 || $1 !~ \*.js) then
    echo "file '$1' not exist, or '$1' is not javascript file"
    exit $FILE_NOT_MATCH
endif

set compressed_file = `echo $1 | sed "s/\(.*\)\(\.js\)/\1-min\2/"`

# Run Google Compiler
java -jar $COMPILER_JAR --js $1 --js_output_file $compressed_file $EXTRA_PARAMS 

# Is success?
if (-r $compressed_file) then
    set from_size = `stat -f %z $1`
    set to_size   = `stat -f %z $compressed_file`
    echo "finished, compressed $1($from_size bytes) to $compressed_file($to_size bytes)."
    exit 0
else
    echo "compress faild"; exit COMPRESS_FAILD 
endif

# vim: set et sw=4 ts=4 sts=4 fdm=marker ff=unix fenc=utf8 nobomb:

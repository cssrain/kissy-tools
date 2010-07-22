#!/bin/tcsh
#
# TCSH Script for YUI Compressor
#
# @author mingcheng<i.feelinglucky#gmail.com>
# @date   2009-12-23
# @link   http://www.gracecode.com/

# Jar file path
set COMPRESSOR_JAR = "yuicompressor.jar"

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
set -r COMPRESSOR_JAR = "`dirname $0`/$COMPRESSOR_JAR"

# check $COMPRESSOR_JAR whether exit
if (-r $COMPRESSOR_JAR != 1) then
    echo "$COMPRESSOR_JAR not exist"; exit $JAR_NOT_EXIST
endif

# Check input file @todo check file type
if ($1 == "" || -r $1 != 1) then
    echo "file '$1' not exist, or '$1' is not javascript/css file"
    exit $FILE_NOT_MATCH
endif


# Generate compressed file
set compressed_file = `echo $1 | sed "s/\(\.*\)\(\.[css|js]\)/\1-min\2/"`

# Run YUI Compressor
java -jar $COMPRESSOR_JAR $EXTRA_PARAMS $1 -o $compressed_file

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

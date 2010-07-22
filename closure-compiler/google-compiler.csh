#!/bin/tcsh
#
# TCSH script for Google compiler
#
# @author mingcheng<i.feelinglucky#gmail.com>
# @date   2009-12-23
# @link   http://www.gracecode.com/

# set compiler script path
set COMPILER_SCRIPT = "`dirname $0`/compiler.csh"

if (-r $COMPILER_SCRIPT != 1) then
    echo "$COMPILER_SCRIPT not exists"
endif

foreach files ($argv)
    if (-r $files) then
        $COMPILER_SCRIPT $files
    else
        echo "$files : not exists"
    endif
end

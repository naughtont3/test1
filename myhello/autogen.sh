#!/bin/sh
# $Id: autogen.sh 2095 2012-05-03 19:55:24Z tjn3 $

if [ "$1" = "clean" ] ; then

     # 
     # Run 'make clean' (if possible)
     #
    if [ -f "Makefile" ] ; then
        make clean
    fi

     #
     # Delete files
     #
    delete_files=`find . -name Makefile \
                 -o -name Makefile.in \
                 -o -name configure   \
                 -o -name depcomp     \
                 -o -name install-sh  \
                 -o -name compile     \
                 -o -name missing     \
                 -o -name aclocal.m4  \
                 -o -name missing     \
                 -o -name stamp-h1    \
                 -o -name "config.*"`

    for file in ${delete_files} ; do
        echo "Remove: $file" 
        rm -f $file
    done

     #
     # Delete directories
     #
    delete_dirs=`find . -name .deps`
    delete_dirs="${delete_dirs} autom4te.cache"

    for dir in ${delete_dirs} ; do 
        echo "Remove: $dir" 
        rm -rf $dir
    done

else
    #
    # Run configure setup utilities...
    #
    autoreconf --install
fi

exit 0

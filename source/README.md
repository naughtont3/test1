
SUMMARY
-------
Simple 'hello world' test project for autotools, etc.

The pthread example is just to demonstrate having a 
library dependency for autotool-ing.

URL: https://github.com/naughtont3/myhello

BUILD
-----

     # 1) Generate configure script
    $ ./autogen.sh

      # 2a) Configure (with default install path), build and install
    $ ./configure && make && make install
     
     #
     #   --OR--
     #

     # 2b) Configure (with CUSTOM install path), build and install
    $ ./configure --prefix=$PWD/mylocal && make && make install


RUN
---

    $ ./mylocal/bin/myhello 
    Hello World
    This is myhello 1.0.0-rUnversioned directory.


    $ ./mylocal/bin/simple_pthread 
    [29371] mytid is 140735284126464
    [29371] Hello from main():line 28
    [29371] hello-from-foo
    [29371] mytid is 4499353600
    [29371] Done.


CLEAN
-----

     # Clean just the build
    $ make clean

     # Clean everything (build & configure's auto-generated droppings)
    $ ./autogen.sh clean



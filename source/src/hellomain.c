/* 
 * Note: git import taken from hellomain.c @ r1821. 
 *
 * Based on Autotool Tutorial by Alexandre Duret-Lutz (updated: May 16, 2010)
 *
 *    "Using GNU Autotools", 
 *    by Alexandre Duret-Lutz
 *    http://www.lrde.epita.fr/~adl/autotools.html
 *
 * Tutorial examples based on:
 *  GNU Autoconf 2.65
 *  GNU Automake 1.11.1
 *  GNU Libtool  2.2.6b
 *  GNU Gettext  0.17
 */
#include <config.h>
#include <stdio.h>
#include <stdlib.h>

int main (int argc, char **argv)
{
    printf("Hello World\n");
    printf("This is %s.\n", PACKAGE_STRING);

    return (EXIT_SUCCESS);
}


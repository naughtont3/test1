AC_INIT([myhello], 
        m4_join([-r], [1.0.0], m4_normalize(esyscmd([sh -c "svnversion"]))), 
        [bug-report@address.com])
AC_PREREQ([2.65])
# TJN: FWIW...I know that above m4 macros are 
#      _not_ supported by AC 2.61, but are supported by AC 2.63.
#  m4_normalize() cuts any trailing newline

# Safety check to ensure configure run from proper location
AC_CONFIG_SRCDIR([src/hellomain.c])

# Auxiliary scripts (install-sh, etc.) should be in 'config/' dir
AC_CONFIG_AUX_DIR([config])

AM_INIT_AUTOMAKE([foreign tar-ustar -Wall -Werror])

AC_PROG_CC
#
# NOTE: AC_PROG_CXX, AC_PROG_F77, AC_PROG_SED, AC_PROG_YACC, AC_PROG_LEX...
#       AC_PROG_SED checks for 'sed' and if found, sets $SED
#
AC_CHECK_PROGS([PERL], [perl], [:])
if test "$PERL" = :; then
    AC_MSG_ERROR([This package needs perl.], [1])
fi

AC_CONFIG_HEADERS([config.h])

#
# NOTES:
#  o AC_DEFINE([VARIABLE], [VALUE], [DESCRIPTION])
#    Output the following to 'config.h'
#       /* DESCRIPTION */
#       #define VARIABLE VALUE
#
#  o AC_SUBST([VARIABLE], [VALUE])
#    Define $(VARIABLE) as VALUE in 'Makefile'
#      
#  o AC_CHECK_LIB([LIBRARY], [FUNCT], [ACT-IF-FOUND], [ACT-IF-NOT])
#    Ex.  AC_CHECK_LIB([efence], [malloc], [EFENCELIB=-lefence])
#         AC_SUBST([EFENCELIB])
#    And later use $(EFENCELIB) in link rule
#
#    NOTE: If ACT-IF-FOUND not set, and library if found, AC_CHECK_LIB
#          will do LIBS="-l<LIBRARY> $LIBS" and #define HAVE_LIB<LIBRARY>
#          e.g., will do LIBS="-lefence $LIBS" and #define HAVE_LIBefence
#          an Automake uses $LIBS for linking everything.
#          (TJN: not sure if will be lower or upper case?)
#
#  o AC_CHECK_HEADERS([HEADER ...])
#    Checks for <HEADER> and #define HAVE_<HEADER>_H, e.g.,
#       AC_CHECK_HEADERS([sys/param.h unistd.h])
#    which might #define HAVE_SYS_PARAM_H, HAVE_UNISTD_H 
#    And you would later use as
#       #if HAVE_UNISTD_H
#       # include <unistd.h>
#       #endif
#

####
#
# NOTE: AC_CONFIG_FILES() Creates FILE for all FILE.in. 
#       Expanding any AC_SUBST items in each FILE.in for the FILE(s) listed,
#       i.e., subst the @XYZ@ placeholders for AC_SUBST([XYZ]) definitions.
#       Note, can be used with non-Makefile cases, e.g., in shell script 
#       that use 'sed',
#           SED='@SED@'
#           for f ; do "$SED" ....
#     
# NOTE: You can process the FILE.in and rename it with following syntax,
#          AC_CONFIG_FILES([script.sh:script.in])
#       which would process the various @variable@ instances and create
#       the resulting file 'script.sh'.
#
# NOTE: You can also set the mode on files, possibly useful if doing 
#       above renaming.  
#
#        AC_CONFIG_FILES([pmd/scripts/pmdpp], 
#                [chmod +x pmd/scripts/pmdpp])
#
#       This manages file via autconf, instead of say by one of 
#       the automake directives (e.g., dist_pkgdata_SCRIPTS).
#       Note as per Automake manual (sect 9.1 Executable Scripts):
#
#          "Although this looks simpler, building scripts this 
#           way has one drawback: directory variables such 
#           as $(datadir) are not fully expanded and may
#           refer to other directory variables."
####

# NOTE: If the ACT-IF-FOUND item is not set, then the lib is added to LIBS,
#       and later Automake used $LIBS for linking.
#
AC_CHECK_LIB([pthread], [pthread_create],
             [], [AC_MSG_ERROR([This package needs pthreads], [1])])

AC_CONFIG_FILES([\
                Makefile \
                src/Makefile \
                ])
AC_OUTPUT


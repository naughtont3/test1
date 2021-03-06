#!/bin/bash -x

BUILD_DIR=$(pwd)
echo $BUILD_DIR

cat > $BUILD_TAG.pbs << EOF
#!/bin/bash
#PBS -A CSC040
#PBS -N $BUILD_TAG
#PBS -j oe
#PBS -l walltime=1:00:00,nodes=1
#PBS -d $BUILD_DIR
#PBS -l partition=rhea


# Arg1 retval
# Arg2 err-string
die () {
    echo "ERROR: \$2 (rc=\$1)"
    exit \$1
}


echo "================================================="
echo -n "   Started test at: "
date
echo "================================================="

cd $BUILD_DIR

module unload PE-intel
module unload openmpi

module load PE-gnu/5.3.0-1.10.2
module load git

# Load/Show our Autotools last
source /ccs/home/csc040ci_auser/local/env_gnu.sh
which m4
which autoconf
which automake
which libtool


echo "# INFO: ENVIRONMENT (--begin--)"
env
module list
echo "# INFO: ENVIRONMENT (-- end --)"

echo "# INFO: HOST"
hostname

echo "# INFO: DATE"
date

echo "# INFO: PWD (START)"
pwd


echo "# INFO: SOURCE VERSION"
git log --oneline | head -2
git branch -vv


echo ""
echo ""
echo "starting new test"
echo ""
echo ""

cd source/

echo "# DBG: PWD (BUILD)"
pwd

rc=0

echo "# DBG: Run autogen.sh"
./autogen.sh \
    || die 1 "ERROR: autogen.sh failed. exiting."

echo "# DBG: Run configure"
./configure \
    || die 2 "ERROR: configure failed. exiting."

echo "# DBG: Run make"
make \
    || die 3 "ERROR: make failed. exiting."

# TODO: Add make install
# TODO: Add make check

echo "# INFO: SUCCESS. exiting."

echo "================================================="
echo -n "  Finished test at: "
date
echo "================================================="

exit 0
EOF

/ccs/home/csc040ci_auser/openshift-ci/blocking_qsub $BUILD_DIR $BUILD_TAG.pbs
job_rc=$?

echo "================================================="
echo " JOB_RC=$job_rc"
echo "================================================="

cp $BUILD_DIR/$BUILD_TAG.o* ../

## this end of job logic could probably be more elegant
## hacks to get us going

cp $BUILD_DIR/$BUILD_TAG.o* ../

echo "================================================="
echo "#  LOG: $BUILD_TAG.o*"
echo "================================================="
cat ../$BUILD_TAG.o*
echo "================================================="

# explicitly check for correct test output from all builds
#[ $(grep '100% tests passed, 0 tests failed out of [0-9]*' ../$BUILD_TAG.o* | wc -l) -eq 4 ]

# TODO: IMPROVE OUR CHECK OF THE BUILD/TEST OUTPUT (see above for example)
if [ 0 -ne $job_rc ] ; then
    # Failed job
    echo "CI-STATUS: $BUILD_TAG JOB-FAILED (job_rc=$job_rc)"
    exit $job_rc
fi
# TJN: Crudely check for 'ERROR' in the log output
if [ $(grep 'ERROR:' ../$BUILD_TAG.o* | wc -l) -gt 0 ] ; then
    # Failed
    echo "CI-STATUS: $BUILD_TAG FAILED"
    exit 1
fi
if [ $(grep 'error:' ../$BUILD_TAG.o* | wc -l) -gt 0 ] ; then
    # Failed
    echo "CI-STATUS: $BUILD_TAG FAILED"
    exit 1
fi
if [ $(grep 'Error:' ../$BUILD_TAG.o* | wc -l) -gt 0 ] ; then
    # Failed
    echo "CI-STATUS: $BUILD_TAG FAILED"
    exit 1
fi

# Success
echo "CI-STATUS: $BUILD_TAG PASSED"
exit 0

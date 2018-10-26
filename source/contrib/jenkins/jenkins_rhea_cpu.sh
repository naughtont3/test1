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
./autogen.sh
rc=$?
if [ 0 -ne $rc ] ; then
  echo "autogen.sh failed. exiting."
  exit 1
fi

echo "# DBG: Run configure"
./configure
rc=$?
if [ 0 -ne $rc ] ; then
  echo "configure failed. exiting."
  exit 2
fi

echo "# DBG: Run make"
make
rc=$?
if [ 0 -ne $rc ] ; then
  echo "make failed. exiting."
  exit 3
fi

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

# explicitly check for correct test output from all builds
#[ $(grep '100% tests passed, 0 tests failed out of [0-9]*' ../$BUILD_TAG.o* | wc -l) -eq 4 ]
# TODO: IMPROVE OUR CHECK OF THE BUILD/TEST OUTPUT (see above for example)
if [ 0 -eq $job_rc ] ; then
    # Success
    echo "CI-STATUS: $BUILD_TAG PASSED"
    exit 0
else
    # Failed
    echo "CI-STATUS: $BUILD_TAG FAILED"
    exit $job_rc
fi

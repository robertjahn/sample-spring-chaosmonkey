#!/bin/bash
# Starts a JMeter test that is passed via command line arguments

showUsage()
{
  echo "usage: ./run_test.sh [testscript.jmx] [result path] [endpoint url] [VUCount] [LoopCount] [DT Name]"
}

if [ -z "$1" ]; then
  echo "Usage: Arg 1 [testscript.jmx] required"
  showUsage
  exit 1
fi
if [ -z "$2" ]; then
  echo "Usage: Arg 2 [result path] required"
  showUsage
  exit 1
fi
if [ -z "$3" ]; then
  echo "Usage: Arg 3 [endpoint url] required"
  showUsage
  exit 1
fi
VUCount=$4
if [ -z "$4" ]; then
  VUCount=1
fi
LoopCount=$5
if [ -z "$5" ]; then
  LoopCount=1
fi
DT_LTN=$6
if [ -z "$6" ]; then
  DT_LTN=MyLoadTestName
fi

echo "Running $1 with SERVER_URL=$3, VUCount=$VUCount, LoopCount=$LoopCount, DT_LTN=$DT_LTN"

rm -rf report
mkdir report
rm -f -r $2
mkdir $2

#docker run --name jmeter-test -v "${PWD}/scripts":/scripts -v "${PWD}/$2":/results --rm -d jmeter ./jmeter/bin/jmeter.sh -n -t /scripts/$1 -e -o /results -l result.tlf -JSERVER_URL="$3" -JDT_LTN="$DT_LTN" -JVUCount="$VUCount" -JLoopCount="$LoopCount"
/usr/local/bin/jmeter -n -t $1 -l $2/result.tlf -e -o report -JSERVER_URL="$3" -JDT_LTN="$DT_LTN" -JVUCount="$VUCount" -JLoopCount="$LoopCount"

#!/bin/bash

# args
#
# target platform ${timestamp}z label realtauser realtapass deleteFlag

if [ "$4" = "" ]; then echo Missing target dir, platform, dateZ, dateTime, user, password arguments ; exit 1 ; fi

if [ ! -d $1 ]; then mkdir $1 ; fi
if [ ! -d $1/ndr-UBL-$2-$3 ]; then mkdir $1/ndr-UBL-$2-$3 ; fi
if [ ! -d $1/ndr-UBL-$2-$3/archive-only-not-in-final-distribution/ ]; then mkdir $1/ndr-UBL-$2-$3/archive-only-not-in-final-distribution/ ; fi

set +x
if [ -f $1/ndr.console.$3.txt ]; then rm $1/ndr.console.$3.txt ; fi
touch $1/ndr.console.$3.txt

echo UBL Governance 1.1...                               | tee -a $1/ndr.console.$3.txt
bash packageGovernance.sh $1 cn01 $3 $4 $5 $6       | tee -a $1/ndr.console.$3.txt
UBLGovReturn=${PIPESTATUS[0]}
echo UBL 2.1 JSON 2.0...                                | tee -a $1/ndr.console.$3.txt
bash packageUBLJSON.sh $1 2.1 2.0 cn01 $3 $4 $5 $6 | tee -a $1/ndr.console.$3.txt
UBL21Return=${PIPESTATUS[0]}
echo UBL 2.2 JSON 1.0...                                | tee -a $1/ndr.console.$3.txt
bash packageUBLJSON.sh $1 2.2 1.0 cn01 $3 $4 $5 $6 | tee -a $1/ndr.console.$3.txt
UBL22Return=${PIPESTATUS[0]}
echo UBL 2.3 JSON 1.0...                                | tee -a $1/ndr.console.$3.txt
bash packageUBLJSON.sh $1 2.3 1.0 cn01 $3 $4 $5 $6 | tee -a $1/ndr.console.$3.txt
UBL23Return=${PIPESTATUS[0]}
echo UBL NDR 3.1...                                     | tee -a $1/ndr.console.$3.txt
bash packageUBLNDR.sh $1 cn01 $3 $4 $5 $6          | tee -a $1/ndr.console.$3.txt
UBLNDRReturn=${PIPESTATUS[0]}
echo BDNDR 1.1...                                       | tee -a $1/ndr.console.$3.txt
bash packageBDNDR11.sh $1 cs03 $3 $4 $5 $6         | tee -a $1/ndr.console.$3.txt
BDNDRReturn=${PIPESTATUS[0]}

mv $1/ndr.console.$3.txt $1/ndr-UBL-$2-$3/archive-only-not-in-final-distribution/
echo Governance:$UBLGovReturn UBL21:$UBL21Return UBL22:$UBL22Return UBL23:$UBL23Return UBLNDR:$UBLNDRReturn BDNDR:$BDNDRReturn  >$1/ndr-UBL-$2-$3/archive-only-not-in-final-distribution/ndr.exitcodes.$3.txt

# move created packages to download zip
mv $1/*.zip $1/ndr-UBL-$2-$3

# reduce GitHub storage costs by zipping results and deleting intermediate files
pushd $1
7z a ndr-UBL-$2-$3.zip ndr-UBL-$2-$3
popd

if [ "$1" = "target" ]
then
if [ "$2" = "github" ]
then
if [ "$7" = "DELETE-REPOSITORY-FILES-AS-WELL" ] #secret undocumented failsafe
then
# further reduce GitHub storage costs by deleting repository files

find . -not -name target -not -name .github -maxdepth 1 -exec rm -r -f {} \;
mv $1/ndr-UBL-$2-$3.zip .
rm -r -f $1

fi
fi
fi

exit 0 # always be successful so that github returns ZIP of results


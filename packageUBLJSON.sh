if [ "$6" == "" ]
then 
echo Missing target directory, ublversion, jsonversion, stage, dateZ, dateTime, username, password arguments
exit
fi

if [[ ! -e UBL-$2-JSON-v$3-$4.xml ]]; then echo Problem finding UBL-$2-JSON-v$3-$4.xml ; exit ; fi

if [ 1 == 1 ]
then

echo Pre-validate sources...
sh db/spec-0.8/validate/validate.sh UBL-$2-JSON-v$3-$4.xml
if [ "$?" != "0" ]; then exit 1 ; fi
rm output.txt

fi


echo Building package...
java -Dant.home=utilities/ant -classpath utilities/ant/lib/ant-launcher.jar:db/spec-0.8/validate//saxon9he.jar:. org.apache.tools.ant.launch.Launcher -buildfile packageUBLJSON.xml -Ddir=$1 -DUBLversion=$2 -DJSONversion=$3 -Dstage=$4 -Dversion=$5 -Ddatetimelocal=$6 -Dsetareuser=$7 -Dsetarepass=$8 -Dartefactsdir=UBL-$2-JSON-results

if [ "$?" != "0" ]; then exit 1 ; fi

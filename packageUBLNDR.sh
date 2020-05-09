if [ "$3" == "" ]
then 
echo Missing target directory, stage, dateZ, date, user, password arguments
exit
fi

if [[ ! -e UBL-NDR-v3.1-$2.xml ]]; then echo Problem finding UBL-NDR-v3.1-$2.xml ; exit ; fi

if [ 1 == 1 ]
then

echo Pre-validate sources...
sh db/spec-0.8/validate/validate.sh UBL-NDR-v3.1-$2.xml
if [ "$?" != "0" ]; then exit ; fi
rm output.txt

fi


echo Building package...
java -Dant.home=utilities/ant -classpath utilities/ant/lib/ant-launcher.jar:db/spec-0.8/validate/saxon9he.jar:. org.apache.tools.ant.launch.Launcher -buildfile packageUBLNDR.xml -Ddir=$1 -Dstage=$2 -Dversion=$3 -Ddatetimelocal=$4 -Dsetareuser=$5 -Dsetarepass=$6

if [ "$?" != "0" ]; then exit ; fi

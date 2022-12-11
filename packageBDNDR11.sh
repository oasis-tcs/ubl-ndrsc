if [ "$4" == "" ]
then 
echo Missing target directory, stage, dateZ, dateTime, username, password arguments
exit
fi

if [[ ! -e Business-Document-NDR-v1.1-$2.xml ]]; then echo Problem finding Business-Document-NDR-v1.1-$2.xml ; exit ; fi

if [ 1 == 1 ]
then

echo Pre-validate sources...
sh db/spec-0.8/validate/validate.sh Business-Document-NDR-v1.1-$2.xml
if [ "$?" != "0" ]; then exit 1 ; fi
rm output.txt

fi

echo
echo Building package...
java -Dant.home=utilities/ant -classpath utilities/ant/lib/ant-launcher.jar:db/spec-0.8/validate/saxon9he.jar:. org.apache.tools.ant.launch.Launcher -buildfile packageBDNDR11.xml -Ddir=$1 -Dstage=$2 -Dversion=$3 -Ddatetimelocal=$4 -Drealtauser=$5 -Drealtapass=$6

if [ "$?" != "0" ]; then exit 1 ; fi


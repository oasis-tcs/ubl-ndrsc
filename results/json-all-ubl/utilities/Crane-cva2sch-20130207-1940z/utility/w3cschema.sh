#echo Validating $2 with $1...
SCHEMAPATH=`echo $0 | sed s,[^/]*$,, | sed s,^$,./,`
java -jar "${SCHEMAPATH}xjparse.jar" -c "${SCHEMAPATH}catalog.xml" -S $1 $2

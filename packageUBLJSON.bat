@echo off
if not "a%~6"=="a" goto :argsokay
echo Missing target directory, ublversion, jsonversion, stage, dateZ, date, username, password arguments
exit /B 1
:argsokay

echo Pre-validate sources...
call db\spec-0.8\validate\validate.bat "UBL-%~2-JSON-v%~3-%~4.xml"
if %errorlevel% neq 0 goto :done
del output.txt

echo Building package...
java -Dant.home=utilities\ant -cp "utilities\ant\lib\ant-launcher.jar;db\spec-0.8\validate\saxon9he.jar" org.apache.tools.ant.launch.Launcher -buildfile packageUBLJSON.xml "-Ddir=%~1" "-DUBLversion=%~2" "-DJSONversion=%~3" "-Dstage=%~4" "-Dversion=%~5" "-Ddatetimelocal=%~6" "-Drealtauser=%~7" "-Drealtapass=%~8" "-Dartefactsdir=UBL-%~2-JSON-results"
if %errorlevel% neq 0 goto :done

:done
exit /B %errorlevel%
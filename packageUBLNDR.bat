@echo off
if not "a%~6"=="a" goto :argsokay
echo Missing target directory, stage, dateZ, date, user, password arguments
exit /B 1
:argsokay

echo Pre-validate sources...
call db\spec-0.8\validate\validate.bat "UBL-NDR-v3.1-%~2.xml"
if %errorlevel% neq 0 goto :done
del output.txt

echo Building package...
java -Dant.home=utilities\ant -cp "utilities\ant\lib\ant-launcher.jar;db\spec-0.8\validate\saxon9he.jar" org.apache.tools.ant.launch.Launcher -buildfile packageUBLNDR.xml "-Ddir=%~1" "-Dstage=%~2" "-Dversion=%~3" "-Ddatetimelocal=%~4" "-Drealtauser=%~5" "-Drealtapass=%~6"
if %errorlevel% neq 0 goto :done

:done
exit /B %errorlevel%
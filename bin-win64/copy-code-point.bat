@echo off

%~d0
cd %~dp0

call :Choose 10

set /a inputNum = 0
set /a processNum = 0
set /a convertType = %ERRORLEVEL% - 1

for %%i in (%*) do call :Processing %%i

if %inputNum% EQU 0 call :Default

if %processNum% NEQ 0 echo processing complete !

pause
exit 

:Choose

	echo [33mNOTE:[0m^ Two formats can be converted: [32m[zh_Hant]-Y (default)[0m or [31m[zh]-N[0m

	choice /m "Please select the conversion format:" /c:YN /t %1 /d Y

	if %ERRORLEVEL% EQU 1 goto :EOF

	if %ERRORLEVEL% EQU 2 goto :EOF

goto :Choose

:Default

	set /a processNum = 0

	if not exist Fonts mkdir Fonts

	for %%i in (%~dp0Fonts\*) do call :Processing %%i

	if %processNum% EQU 0 echo there is no font file, please put it in the 'Fonts' folder.

goto :EOF

:Processing

	echo processing - %~1

	set /a inputNum = inputNum + 1

	.\otfccdump.exe --ignore-hints -o temp.json %~1

	if %ERRORLEVEL% NEQ 0 echo [31mFILE EXCEPTION![0m
	
	if %ERRORLEVEL% NEQ 0 goto :EOF

	.\pseudo-sc.exe temp.json %convertType%

	.\otfccbuild.exe -q -O3 -o %~1 temp.json

	set /a processNum = processNum + 1

	del temp.json

goto :EOF
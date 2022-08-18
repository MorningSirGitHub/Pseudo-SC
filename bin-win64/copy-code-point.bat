@echo off

%~d0
cd %~dp0

set /a inputNum = 0
set /a processNum = 0

for %%i in (%*) do call :Processing %%i

if %inputNum% EQU 0 call :Default

if %processNum% NEQ 0 echo processing complete !

pause
exit 

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

	.\pseudo-sc.exe temp.json

	.\otfccbuild.exe -q -O3 -o %~1 temp.json

	set /a processNum = processNum + 1

	del temp.json

goto :EOF
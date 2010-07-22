@echo off
REM ===============================================
REM    PNGOUT CMD Script
REM     - http://advsys.net/ken/util/pngout.htm
REM
REM     - by yubo@taobao.com
REM     - 2010-01-05
REM ===============================================
SETLOCAL ENABLEEXTENSIONS

echo.
echo PNGOUT
echo.

for %%i in (.png .gif .jpg) do (if %%i==%~x1 goto FILE)

for %%i in (.png .gif .jpg) do (
	dir %~f1 | find /i "%%i" > nul
	if not errorlevel 1 goto FILE
)
echo " **** No PNG, GIF, JPG file found!"
goto END

:FILE
copy /y "%~f1" "%~n1-tmp%~x1" > nul
"%~dp0\pngout.exe" /y "%~n1-tmp%~x1" "%~n1-min"
del /q "%~n1-tmp%~x1"

:END
ENDLOCAL
echo.
pause

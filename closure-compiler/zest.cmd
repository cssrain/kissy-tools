@echo off
SETLOCAL ENABLEEXTENSIONS
REM  yubo@taobao.com 2009-11-10
echo.

echo  Google Closure Compiler:
set RESULT_FILE=%~n1-goog-min%~x1
"%JAVA_HOME%\bin\native2ascii.exe" -encoding GB18030 "%~nx1" "%~nx1.tmp"
"%JAVA_HOME%\bin\java.exe" -jar "compiler.jar"  --js "%~nx1.tmp" --js_output_file "%RESULT_FILE%" --externs externs.js
del /q "%~nx1.tmp"
if %ERRORLEVEL% == 0 (
    echo  压缩文件 %~nx1 到 %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo  文件大小从 %~z1 bytes 压缩到 %%~za bytes
    )
    echo.
)

echo  YUI Compressor:
set RESULT_FILE=%~n1-yui-min%~x1
"%JAVA_HOME%\bin\java.exe" -jar "../yuicompressor/yuicompressor.jar" --charset GB18030 "%~nx1" -o "%~nx1.tmp"
"%JAVA_HOME%\bin\native2ascii.exe" -encoding GB18030 "%~nx1.tmp" "%RESULT_FILE%"
del /q "%~nx1.tmp"
if %ERRORLEVEL% == 0 (
    echo  压缩文件 %~nx1 到 %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo  文件大小从 %~z1 bytes 压缩到 %%~za bytes
    )
    echo.
)

ENDLOCAL
pause


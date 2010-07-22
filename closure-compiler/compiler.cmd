@echo off
REM =====================================
REM    Closure Compiler CMD Script
REM
REM     - by yubo@taobao.com
REM     - 2009-11-10
REM =====================================
SETLOCAL ENABLEEXTENSIONS

echo.
echo Google Closure Compiler

REM 过滤文件后缀，只压缩 js
if "%~x1" NEQ ".js" (
    echo.
    echo **** 请选择 JS 文件
    echo.
    goto End
)

REM 检查Java环境
if "%JAVA_HOME%" == "" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\native2ascii.exe" goto NoJavaHome

REM 生成压缩后的文件名，规则为：
REM 1. 文件名有.source时: filename.source.js -> filename.js
REM 2. 其它情况：filename.js -> filename-min.js
set RESULT_FILE=%~n1-min%~x1
dir /b "%~f1" | find ".source." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na%~x1
    )
)

REM compile.jar
"%JAVA_HOME%\bin\java.exe" -jar "%~dp0compiler.jar"  --charset GB18030 --js "%~nx1" --js_output_file "%RESULT_FILE%"

REM 下面解决编码问题：当 js 文件的编码与页面编码不一致时，非 ascii 字符会导致乱码，处理办法是：
REM 1. 首先调用 native2ascii.exe 将非 ascii 字符转换为 \uxxxx 即可
copy /y "%RESULT_FILE%" "%RESULT_FILE%.tmp" > nul
"%JAVA_HOME%\bin\native2ascii.exe" -encoding GB18030 "%RESULT_FILE%.tmp" "%RESULT_FILE%"
del /q "%RESULT_FILE%.tmp"
REM 2. 对于 css 文件，还需要将 \uxxxx 中的 u 去掉（css 只认识\xxxx）
if "%~x1" == ".css" (
    "%~dp0fr.exe" "%RESULT_FILE%" -f:\u -t:\
)

REM print result
if %ERRORLEVEL% == 0 (
    echo.
    echo 压缩文件 %~nx1 到 %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo 文件大小从 %~z1 bytes 压缩到 %%~za bytes
    )
    echo.
) else (
    echo.
    echo **** 文件 %~nx1 中有写法错误，请仔细检查
    echo.
	goto End
)
goto End

:NoJavaHome
echo.
echo **** 请先安装 JDK 并设置 JAVA_HOME 环境变量
echo.

:End
ENDLOCAL
pause

@echo off
REM =====================================
REM    ConvertZ Script
REM
REM     - by yubo@taobao.com
REM     - 2009-02-13
REM =====================================
SETLOCAL ENABLEEXTENSIONS

echo.
echo ConvertZ v8.02
echo.
echo 注意：处理的文件必须是 GBK 编码

REM 过滤文件后缀，只处理txt、js和vm
if "%~x1" NEQ ".txt" (
    if "%~x1" NEQ ".js" (
        if "%~x1" NEQ ".vm" (
            echo.
            echo **** 请选择 TXT, JS 或 VM 文件
            echo.
            goto End
        )
    )
)

REM 获取转换后的文件名，规则为：
REM  1. filename.js -> filename_zh_HK.js
REM  2. filename.source.js -> filename_zh_HK.source.js
set RESULT_FILE=%~n1_zh_HK%~x1
dir /b "%~f1" | find ".source." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na_zh_HK.source%~x1
    )
)

REM 调用convertz
"%~dp0ConvertZ.exe" /i:gbk /o:gbk /f:t "%~nx1" "%RESULT_FILE%"

REM 显示结果
echo.
if %ERRORLEVEL% == 0 (
    echo 成功转换文件 %~nx1 到 %RESULT_FILE%
	echo.
	echo 提醒：
	echo  - 1. 对于 js 文件，转换后，还需要压缩才能上线
	echo  - 2. 对于 vm 文件，转换后，内部 import 的某些文件还需要加入“_zh_HK”
	echo  - 3. 最好人肉检查一遍，工具可以减轻工作量，但无法完全替代
) else (
    echo **** 文件 %~nx1 中有错误，请仔细检查
)
echo.

:End
ENDLOCAL
pause

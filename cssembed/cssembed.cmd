@echo off
REM ==============================================
REM    CSSEmbed CMD Script
REM     - http://wiki.github.com/nzakas/cssembed
REM
REM     - by Taobao UED
REM     - 2009-11-16
REM ==============================================
SETLOCAL ENABLEEXTENSIONS

echo.
echo CSSEmbed v0.2.6

REM 过滤文件后缀，只处理 css
if "%~x1" NEQ ".css" (
    echo.
    echo **** 请选择 CSS 文件
    echo.
    goto End
)

REM 文件名规则
set RESULT_FILE=%~n1-embed%~x1
dir /b "%~f1" | find ".source." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na-embed.source%~x1
    )
)

REM cssembed.jar
java -jar "%~dp0cssembed.jar" -o "%RESULT_FILE%" "%~nx1" 

REM 显示结果
if %ERRORLEVEL% == 0 (
    echo.
    echo 成功转换文件 %~nx1 到 %RESULT_FILE%
    echo.
) else (
    echo.
    echo 文件 %~nx1 中有错误，请检查
    echo.
)

:END
ENDLOCAL
pause

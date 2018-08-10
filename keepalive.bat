@ECHO OFF

SET EXEName=FXServer.exe
SET startScript=C:\Users\Administrator\Desktop\FXServer\server-data\start.bat
::SET EXEFullPath=C:\Users\minipunch1\Desktop\FXServer2\server-data\start.bat

:Begin
TASKLIST | FINDSTR /I "%EXEName%"
IF ERRORLEVEL 1 GOTO :StartServer
GOTO Wait

:StartServer
START "" "%startScript%"

:Wait
timeout /t 10 /nobreak
GOTO Begin
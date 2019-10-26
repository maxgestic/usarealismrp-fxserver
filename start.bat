taskkill /F /IM FXServer.exe
break > CitizenFX.log
git checkout .
git pull
mkdir scrambled_resources
index-win.exe > scramble.log
xcopy scrambled_resources resources /r /s /y
rmdir /Q /S scrambled_resources
..\run.cmd +exec server.cfg > CitizenFX.log
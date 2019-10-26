taskkill /F /IM FXServer.exe
break > CitizenFX.log
git checkout .
git pull
index-win.exe > scramble.log
xcopy scrambled_resources resources /r /s /y
..\run.cmd +exec server.cfg > CitizenFX.log
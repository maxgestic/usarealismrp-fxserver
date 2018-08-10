taskkill /F /IM FXServer.exe
cd ..
break>CitizenFX.log
cd server-data/cache
rmdir files /s /q
cd ..
..\run.cmd +exec server.cfg
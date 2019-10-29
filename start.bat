taskkill /F /IM FXServer.exe
break > CitizenFX.log
git checkout .
git pull
cd resources
rd /S /Q assets
rd /S /Q eup-stream
rd /S /Q map_courthouse
rd /S /Q map_dealership
rd /S /Q map_hospital
rd /S /Q map_pdextended
rd /S /Q map_sandypdinterior
rd /S /Q nw_comedyClub
rd /S /Q policeveh
rd /S /Q unmarked-police-pack
cd ..
index-win.exe > scramble.log
xcopy scrambled_resources resources /r /s /y
xcopy C:\Users\Administrator\Desktop\toTransfer resources /r /s /y
..\run.cmd +exec server.cfg > CitizenFX.log
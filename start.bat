taskkill /F /IM FXServer.exe /T
taskkill /F /IM git.exe /T
taskkill /F /IM git-credential-manager.exe /T
taskkill /F /IM xcopy.exe /T
timeout /t 10 /nobreak
break > CitizenFX.log
git checkout .
IF [%1] == [] (
	git pull
) ELSE (
	git pull https://%1:%2@github.com/minipunch/usarealismrp-fxserver.git
)
cd resources
rd /S /Q assets
rd /S /Q eup-stream
rd /S /Q map_courthouse
rd /S /Q map_dealership
rd /S /Q map_hospital
rd /S /Q map_mrpd
rd /S /Q map_sandypdinterior
rd /S /Q gabz_pillbox_hospital
rd /S /Q map_burgershot
rd /S /Q map_glory
rd /S /Q map_mosleys
rd /S /Q map_luxury-autos
rd /S /Q map_prisonMap1
rd /S /Q map_prisonMap2
rd /S /Q map_banktweaks
rd /S /Q paletopd
rd /S /Q map_splitsides
rd /S /Q policeveh
rd /S /Q unmarked-police-pack
cd ..
index-win.exe > scramble.log
xcopy scrambled_resources resources /r /s /y
xcopy C:\Users\Administrator\Desktop\toTransfer resources /r /s /y
..\run.cmd +exec server.cfg > CitizenFX.log

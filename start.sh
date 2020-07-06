# commands
runScramblerCmd="
cd /d C:\\fxserver-resource-scrambler-dist && index-win.exe
"

clearResourcesCmd="
cd /d C:\\fxserver-resource-scrambler-dist && rd /s /q resources && rd /s /q scrambled_resources
"

# scrambler server details
scramblerServerIP=68.4.75.110
scramblerServerUser=joshy

# close FXServer
tmux kill-session -t fxserver

# clear log file
> CitizenFX.log

# pull from GH repo
git checkout .
git pull

# remove maps / assets to avoid scrambling them to save time
cd resources
rm assets -f -r
rm eup-stream -f -r
rm map_courthouse -f -r
rm map_dealership -f -r
rm map_hospital -f -r
rm map_mrpd -f -r
rm map_sandypdinterior -f -r
rm gabz_pillbox_hospital -f -r
rm map_burgershot -f -r
rm map_customDesigns -f -r
rm map_glory -f -r
rm map_mosleys -f -r
rm map_luxury-autos -f -r
rm map_prisonMap1 -f -r
rm map_prisonMap2 -f -r
rm map_banktweaks -f -r
rm map_parsons -f -r
rm map_prisonGate -f -r
rm paletopd -f -r
rm map_splitsides -f -r
rm policeveh -f -r
rm unmarked-police-pack -f -r
rm usa_customClothing -f -r
rm usa_customHair -f -r
rm usa_customVehicles -f -r
rm usa_adidas -f -r
rm usa_levis -f -r
rm map_mining -f -r
cd ..

# avoid scrambling [system]/[builders] resources
cp -r resources/[system]/[builders] .
rm -f -r resources/[system]/[builders]

# clear old copy of resources on scrambler server
sshpass -f "scramblerServerPass.txt" ssh $scramblerServerUser@$scramblerServerIP $clearResourcesCmd

# copy resources to scrambler server
sshpass -f "scramblerServerPass.txt" scp -r resources $scramblerServerUser@$scramblerServerIP:C:/fxserver-resource-scrambler-dist

# run scrambler on scrambler server
sshpass -f "scramblerServerPass.txt" ssh $scramblerServerUser@$scramblerServerIP $runScramblerCmd

# retrieve scrambled resources from scrambler server
sshpass -f "scramblerServerPass.txt" scp -r $scramblerServerUser@$scramblerServerIP:C:/fxserver-resource-scrambler-dist/scrambled_resources .
cp -r scrambled_resources/* resources
rm -r scrambled_resources
mv [builders] resources/[system]

# copy stuff that should be skipped when scrambling
cp -r toTransfer/* resources

# run server
tmux new -d -s fxserver "bash /home/ubuntu/FXServer/server/run.sh +exec server.cfg > CitizenFX.log"

# close FXServer
tmux kill-session -t fxserver

# clear log file
> CitizenFX.log

# run any setup needed before checking out this file
sh setup.sh

# pull from GH repo
git checkout .
git pull

# remove maps / assets to avoid scrambling them to save time
cd resources
rm assets/stream -f -r
rm eup-stream -f -r
rm map_courthouse -f -r
rm map_dealership -f -r
rm map_hospital -f -r
rm map_mrpd -f -r
rm map_sandypdinterior -f -r
rm map_burgershot -f -r
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
rm [cassino] -f -r
cd ..

# avoid scrambling node_modules within resources
cp -r resources/[system]/[builders] .
cp -r resources/ws_server/node_modules .
rm -f -r resources/[system]/[builders]
rm -f -r resources/ws_server/node_modules

# scramble resources
java -jar ResourceEventScrambler.jar

# move node_modules back into place
mv [builders] resources/[system]
mv node_modules resources/ws_server

# copy stuff that should be skipped when scrambling
cp -r toTransfer/* resources

# run server
tmux new -d -s fxserver "bash /home/ubuntu/FXServer/server/run.sh +exec server.cfg > CitizenFX.log"

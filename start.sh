pathToServerFiles=$1

# close FXServer
tmux kill-session -t fxserver

# run any setup needed before checking out this file
bash setup.sh

# pull from GH repo
git checkout . --recurse-submodules
git pull --recurse-submodules

# init submodules if ncessary
git submodule init
git submodule update

# save last log file, create new one
#mv CitizenFX.log CitizenFX.log.2

# clear chat log file
#> /var/www/html/log.txt

# run server
tmux new -d -s fxserver "bash $pathToServerFiles/run.sh +set onesync on"

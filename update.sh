# pull from GH repo
git checkout . --recurse-submodules
git pull --recurse-submodules

# init submodules if ncessary
git submodule init
git submodule update

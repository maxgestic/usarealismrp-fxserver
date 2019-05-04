server_script "sv_warrants.lua"
client_script "cl_warrants.lua"

server_exports {
    "getWarrants",
    "createWarrant",
    "deleteWarrant"
}

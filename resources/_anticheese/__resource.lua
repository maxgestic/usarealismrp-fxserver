resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	"sv_anticheese.lua",
	"sv_anti-modder.lua",
	'@salty_tokenizer/init.lua'
}

client_scripts {
	"cl_anticheese.lua",
	'@salty_tokenizer/init.lua'
}

exports {
	"Enable",
	"Disable"
}
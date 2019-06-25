resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

server_script 'gun-shop_sv.lua'

client_scripts {
	'@NativeUI/NativeUI.lua',
	'storeWeapons.lua',
	'gun-shop_cl.lua'
}

exports {
	"ShowCCWTerms"
}

fx_version 'adamant'
game 'gta5'

description 'made by MEENO'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'server/main.lua',
	'config.lua',
	'locales/de.lua',
	'locales/tw.lua',
	'locales/en.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client/main.lua',
	'config.lua',
	'locales/de.lua',
	'locales/tw.lua',
	'locales/en.lua'
}

dependency {
	'es_extended',
	'esx_vehicleshop'
}
shared_script '@es_extended/imports.lua'
fx_version 'cerulean'
game 'gta5'

author 'Kael'

version '1.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
	'server/*.lua'
}

client_scripts {
    'config.lua',
    'client/*.lua'
}
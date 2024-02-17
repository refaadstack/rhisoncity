fx_version 'cerulean'
game 'gta5'

lua54 'yes'

server_script 'server/main.lua'

client_script 'client/main.lua'

shared_scripts {
    'config.lua',
    'common/util.lua',
    '@es_extended/imports.lua'
}

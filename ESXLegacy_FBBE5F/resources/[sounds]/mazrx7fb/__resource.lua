resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

files {
	'audioconfig/mazrx7fb_game.dat151.rel',
	'audioconfig/mazrx7fb_sounds.dat54.rel',
	'sfx/dlc_mazrx7fb/mazrx7fb.awc',
	'sfx/dlc_mazrx7fb/mazrx7fb_npc.awc'
}

data_file 'AUDIO_GAMEDATA' 'audioconfig/mazrx7fb_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/mazrx7fb_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_mazrx7fb'

client_script {
    'vehicle_names.lua'
}
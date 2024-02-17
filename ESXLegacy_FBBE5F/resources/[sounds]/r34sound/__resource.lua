resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

files {
	'audioconfig/r34sound_game.dat151.rel',
	'audioconfig/r34sound_sounds.dat54.rel',
	'sfx/dlc_r34sound/r34sound.awc',
	'sfx/dlc_r34sound/r34sound_npc.awc'
}

data_file 'AUDIO_GAMEDATA' 'audioconfig/r34sound_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/r34sound_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_r34sound'

client_script {
    'vehicle_names.lua'
}
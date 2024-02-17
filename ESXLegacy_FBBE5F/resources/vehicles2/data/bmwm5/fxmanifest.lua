fx_version 'adamant'
games { 'gta5' }

author 'Nemes'
description 'BMW M5 2018 emergency edition [RED - BLUE]'
version '2.0.0'

files {
    'vehicles.meta',
    'carvariations.meta',
    'carcols.meta',
    'handling.meta',
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'


client_script {
    'vehicle_names.lua'    
}
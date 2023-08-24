name 'LamaJobs'
description 'Collection of standalone jobs for your FiveM server'
autor 'itzlama'
version '1.0'

fx_version 'cerulean'
game 'gta5'

client_scripts { 
    'car_jacking/client.lua',
    'dock_worker/client.lua',
    'drug_trafficking/client.lua',
    'food_delivery/client.lua',
    'garbage_collector/client.lua',
    'truck_driver/client.lua'
}

server_scripts {
    'car_jacking/server.lua',
    'dock_worker/server.lua',
    'drug_trafficking/server.lua',
    'food_delivery/server.lua',
    'garbage_collector/server.lua',
    'truck_driver/server.lua'
}

shared_script 'config.lua'
fx_version 'adamant'

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

games {'rdr3'}

author "Monox"
description "Bounty Hunter Script for FRP Framework, ideas from rsg_bountyhunter"
client_scripts { 
    '@_core/lib/utils.lua',
    "config.lua",
    "client.lua"
    
}

server_scripts { 
    '@_core/lib/utils.lua',
    "server.lua"
}
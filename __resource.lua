--[[
_________ _______________  ___ ________                       
\_   ___ \\_   _____/\   \/  / \______ \   _______  __________
/    \  \/ |    __)   \     /   |    |  \_/ __ \  \/ /\___   /
\     \____|     \    /     \   |    `   \  ___/\   /  /    / 
 \______  /\___  /   /___/\  \ /_______  /\___  >\_/  /_____ \
        \/     \/          \_/         \/     \/            \/
    Discord: Aizen#9186
    CFX Devz: https://discord.gg/dMMmr82S23
    KK: https://discord.gg/MT2996y
    Antichix: https://discord.gg/NmFcvCs
]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    'server/server.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
    
}
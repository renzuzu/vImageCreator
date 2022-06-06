fx_version 'cerulean'
games {'gta5'}

server_scripts {
    'LibDeflate.lua',
	'@mysql-async/lib/MySQL.lua',	
	'server/server.lua'
}

client_scripts {		
    'LibDeflate.lua',
    'generatelist.lua',
	'client/client.lua'
}

files {
    'thumbnails.json'
}

dependency 'screenshot-basic'
fx_version 'cerulean'
games {'gta5'}

server_scripts {
    'base64toimage.js',
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
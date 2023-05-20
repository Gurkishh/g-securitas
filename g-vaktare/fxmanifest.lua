fx_version 'adamant'

game 'gta5'

client_scripts {
	'client/*.lua',
	'client/cl_props.lua'
} 

server_scripts { 
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}

shared_script {
	'config.lua'
}
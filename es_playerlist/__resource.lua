client_script 'playerlist.lua'

ui_page 'html/index.html'

server_script {
	'@vrp/lib/utils.lua',
	'server.lua'
}

files {
    'html/index.html',
    'html/font/roboto-condensed.ttf',
    'html/font/roboto-regular.ttf',
    'html/css/style.css',
    'html/img/spritesheet.png',
    'html/img/test.png'
}
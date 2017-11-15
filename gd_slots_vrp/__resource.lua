client_script 'playerlist.lua'

ui_page 'index.html'

server_script {
	'@vrp/lib/utils.lua',
	'server.lua'
}

files {
    'index.html',
    'slots.css',
    'slots.js',
    'images/background.png',
    'images/reddit_icons_small.png',
    'images/reel_bg.png',
    'sounds/reel_stop.wav',
    'sounds/win.wav'
}
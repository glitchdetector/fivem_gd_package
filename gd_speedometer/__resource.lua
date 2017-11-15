-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af936'

description 'Speedometer by GlitchDetector'

ui_page 'ui.html'

-- Server
server_scripts { 
}

-- Client
client_scripts {
	'client/main.lua'
}

-- NUI Files
files {
	'ui.html',
	'pdown.ttf',
	'meter.png'
}
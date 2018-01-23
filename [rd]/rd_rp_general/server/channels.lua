local function log(text)
	local strip = {
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "_", "*"
	}
	for k,v in next, strip do
		text = text:gsub("%^" .. v, "")
	end
	print("[rd_chat/channels] " .. text)
end
log("Initializing")

local function SendMessageToPlayer(source, message)
	if source == 0 then
		log(message)
	else
		TriggerClientEvent("chatMessage", source, "^0" .. message)
	end
end
local function SendMessageToEveryone(message)
	log(message)
	TriggerClientEvent("chatMessage", -1, message)
end

Channels = {}
Channels.OOC = "OOC"
Channels.OOC_GLOBAL = "OOC"
Channels.OOC_LOCAL = "Local OOC"
Channels.OOC_DONATOR = "Donator OOC"
Channels.CHAT_ADMIN = "Admin"
Channels.CHAT_SUPPORT = "Support"
Channels.CHAT_MANAGEMENT = "Management"
Channels.CHAT_DEVELOPER = "Developer"
Channels.ANNOUNCE_ADMIN = "Announcement"
Channels.LOUD = "Loud"
Channels.GLOBAL = "Global"
Channels.QUIET = "Quiet"
Channels.GENERAL = "General"

for k,v in next, Channels do
    RegisterServerEvent("chatChannel:" .. v)
    log("Registered channel: " .. v) 
end

AddEventHandler("chatChannel:" .. Channels.LOUD, function(message, origin)
    -- Longer distance chat
    SendMessageToEveryone("^1(Loud) ^2" .. message)
end)
AddEventHandler("chatChannel:" .. Channels.GLOBAL, function(message)
    -- Global distance chat
    SendMessageToEveryone("^1(Global) ^2" .. message)
end)
AddEventHandler("chatChannel:" .. Channels.QUIET, function(message, origin)
    -- Short distance chat
    SendMessageToEveryone("^1(Quiet) ^2" .. message)
end)
AddEventHandler("chatChannel:" .. Channels.GENERAL, function(message, origin)
    -- Normal distance chat
    SendMessageToEveryone("^1(General) ^2" .. message)
end)
AddEventHandler("chatChannel:" .. Channels.OOC_GLOBAL, function(message)
    -- OOC Chat Channel
    SendMessageToEveryone("^1(OOC) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.OOC_LOCAL, function(message, origin)
    -- Local OOC Chat Channel
    SendMessageToEveryone("^1(Local OOC) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.OOC_DONATOR, function(message)
    -- Donator OOC Chat Channel
    SendMessageToEveryone("^1(Donator OOC) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.CHAT_ADMIN, function(message)
    -- Admin Chat Channel
    SendMessageToEveryone("^1(Admin) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.CHAT_SUPPORT, function(message)
    -- Support Chat Channel
    SendMessageToEveryone("^1(Support) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.CHAT_MANAGEMENT, function(message)
    -- Management Chat Channel
    SendMessageToEveryone("^1(Management) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.CHAT_DEVELOPER, function(message)
    -- Developer Chat Channel
    SendMessageToEveryone("^1(Developer) ^2" .. message)
end)

AddEventHandler("chatChannel:" .. Channels.ANNOUNCE_ADMIN, function(message)
    -- Announcement Chat Channel
    SendMessageToEveryone("^1(Announcement) ^2" .. message)
end)

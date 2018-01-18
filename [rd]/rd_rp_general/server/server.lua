local function log(text)
	local strip = {
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "_", "*"
	}
	for k,v in next, strip do
		text = text:gsub("%^" .. v, "")
	end
	print("[rd_chat/server] " .. text)
end
log("Initializing")

local function SendMessageFromPlayer(source, channel, message)
	TriggerClientEvent("chatRelay:getOrigin", source, channel, message)
end
local function SendMessageToChannel(channel, message)
	TriggerEvent("chatChannel:" .. channel, message)
end
local function SendMessageToPlayer(source, message)
	if source == 0 then
		log(message)
	else
		TriggerClientEvent("chatMessage", source, "^0" .. message)
	end
end

local function isDonator(source)
	return true
end
local function isAdmin(source)
	return true
end

-- Get a players rank type tag. ([VIP], [Donator] etc)
local function GetTag(source)
	return (source == 0 and '[Console]' or "[Administrator]")
end

-- Get a players name. Appends the rank tag if present.
local function GetName(source)
	local tag = GetTag(source)
	local name = (source == 0 and 'Console' or GetPlayerName(source))
	if tag then
		return tag .. " " .. name
	end
	return name
end

-- Check a single permission, used by HasPermissions
local function HasPermission(source, permission)
	--if source == 0 then return true end
	return false
end

-- Check if a user has a list of permissions
local function HasPermissions(source, permissions)
	-- The console has all permissions.
	if source == 0 then return true end
	-- Empty permissions = no permissions
	if not next(permissions) then return true end
	for k,v in next, permissions do
		if HasPermission(source, v) then return true end
	end
	return false
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

-- Table of all command functions
Commands = {}

-- List of registered commands
Commands.LIST = {}

-- Patch together arguments to a message
Commands.PATCH = function(args, start, sep)
	start = start or 1
	sep = sep or " "
	local i
	local result = ""
	for i = start, #args do
		result = result .. args[i] .. " "
	end
	return result:sub(1, -2)
end

-- Default return when denied access to a command
Commands.DENIED = function()
	return "You do not have access to this command."
end

local function RegisterAlias(handle, command, restricted, description, usage)
	restricted = restricted or false
	description = description or "No description."
	usage = usage or ""
	command.permissions = command.permissions or {}

	local _run = function(source, args, raw)
		if command.disabled then
			SendMessageToPlayer(source, "This command is disabled.")
			if not isAdmin(source) then
				return false
			end
		end
		if not HasPermissions(source, command.permissions) then
			SendMessageToPlayer(source, "You do not have permission to use this command.")
			return false
		else
			command.run(source, args, raw)
		end
	end

	-- Register as a command (FiveM Native)
	RegisterCommand(handle, _run, restricted)
	log("Registered alias /" .. handle .. " " .. usage .. " | Perms: " .. Commands.PATCH(command.permissions, 1, ", "))

	-- Add command to /help list (FiveM Native)
	table.insert(Commands.LIST, {handle = handle, description = description, restricted = restricted, usage = usage, permissions = command.permissions})
end

Commands.OOC_GLOBAL = {permissions = {"chat.ooc"}, run = function(source, args, raw)
	-- Global OOC
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageToChannel(Channels.OOC_GLOBAL, message)
end}
RegisterAlias("o", Commands.OOC_GLOBAL, false, "Alias for /ooc")
RegisterAlias("ooc", Commands.OOC_GLOBAL, false, "Global OOC chat.", "<message>")

Commands.OOC_LOCAL = {permissions = {"chat.ooc"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Local OOC
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageFromPlayer(source, Channels.OOC_LOCAL, message)
end}
RegisterAlias("b", Commands.OOC_LOCAL, false, "Alias for /looc")
RegisterAlias("looc", Commands.OOC_LOCAL, false, "Local OOC chat.", "<message>")

Commands.OOC_DONATOR = {permissions = {"chat.donator", "rank.donator", "rank.vip"}, run = function(source, args, raw)
	if not isDonator(source) and not isAdmin(source) then return Commands.DENIED() end
	if #args < 1 then return end

	-- Donator OOC
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageToChannel(Channels.OOC_DONATOR, message)
end, description = "Sends a message to the donator channel."}
RegisterAlias("d", Commands.OOC_DONATOR, false, "Alias for /donator")
RegisterAlias("dooc", Commands.OOC_DONATOR, false, "Alias for /donator")
RegisterAlias("donator", Commands.OOC_DONATOR, false, "Sends a message to the donator channel.", "<message>")

Commands.DIRECT_MESSAGE = {permissions = {"command.direct_message"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Direct Message

end}
RegisterAlias("pm", Commands.DIRECT_MESSAGE, false, "Personal Message a user", "<id> <message>")
RegisterAlias("dm", Commands.DIRECT_MESSAGE, false, "Direct Message a user", "<id> <message>")

-- IN CHARACTER COMMANDS
Commands.SHOUT = {permissions = {"command.shout"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Shout
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " shouts: " .. message
	SendMessageFromPlayer(source, Channels.LOUD, message)
end}
RegisterAlias("s", Commands.SHOUT, false, "Alias for /shout")
RegisterAlias("shout", Commands.SHOUT, false, "MAKES YOU SHOUT", "<message>")

Commands.QUIET = {permissions = {"command.quiet"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Low talk
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " quietly says: " .. message
	SendMessageFromPlayer(source, Channels.QUIET, message)
end}
RegisterAlias("l", Commands.QUIET, false, "Alias for /low")
RegisterAlias("low", Commands.QUIET, false, "makes you talk really quiet", "<message>")

Commands.WHISPER = {permissions = {"command.whisper"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Whisper
end}
RegisterAlias("w", Commands.WHISPER, false, "Alias for /whisper")
RegisterAlias("whisper", Commands.WHISPER, false, "Whisper to a specific person", "<id> <message>")

Commands.MEGAPHONE = {permissions = {"command.megaphone"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Megaphone
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " megaphones: " .. message
	SendMessageFromPlayer(source, Channels.LOUD, message)
end}
RegisterAlias("m", Commands.MEGAPHONE, false, "Alias for /megaphone")
RegisterAlias("megaphone", Commands.MEGAPHONE, false, "IS REALLY LOUD!!", "<message>")

-- Used to describe a roleplayed action. Sends a message with XX radius.
Commands.ACTION = {permissions = {"command.action"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- /me Action
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " " .. message
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end}
RegisterAlias("me", Commands.ACTION, false, "Implies an action.", "<action>")

-- Same as /me, but sends it only in XX radius.
Commands.ACTION_QUIET = {permissions = {"command.action"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Quiet /me Action
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " quietly " .. message
	SendMessageFromPlayer(source, Channels.QUIET, message)
end}
RegisterAlias("melow", Commands.ACTION_QUIET, false, "Quietly implies an action.", "<action>")

-- Used to describe a situation, player or an action. Works the same as /me, same XX radius.
Commands.SITUATION = {permissions = {"command.situation"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- /do Situation
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " " .. message
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end}
RegisterAlias("do", Commands.SITUATION, false, "Implies a situation.", "<situation>")

-- Same as /do but at XX radius
Commands.SITUATION_QUIET = {permissions = {"command.situation"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Quiet /do Situation
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " quietly " .. message
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end}
RegisterAlias("dolow", Commands.SITUATION_QUIET, false, "Quietly implies a situation.", "<situation>")

-- Sends a player action above the player head and not in the chat, is visible for a short time. Longer message, longer timer. Sends a copy of what was written in the players own chat.
Commands.ACTION_ANNOTATED = {permissions = {"command.action"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Annotated /me Action
	local message = Commands.PATCH(args)
	message = "* " .. GetName(source) .. " visually " .. message
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end}
RegisterAlias("ame", Commands.ACTION_ANNOTATED, false, "Implies a visual action.", "<action>")

-- STAFF COMMANDS
-- Sends a message to all players set as management.
Commands.CHAT_MANAGEMENT = {permissions = {"chat.management"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Management Chat Channel
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageToChannel(Channels.CHAT_MANAGEMENT, message)
end}
RegisterAlias("mgmt", Commands.CHAT_MANAGEMENT, false, "Alias for /management")
RegisterAlias("management", Commands.CHAT_MANAGEMENT, false, "Sends a message in the management channel.", "<message>")

-- Sends an admin message to all admins and management connected. Can only be toggled off if admin is set as off duty.
Commands.CHAT_ADMIN = {permissions = {"chat.admin", "rank.administrator"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Admin Chat Channel
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageToChannel(Channels.CHAT_ADMIN, message)
end}
RegisterAlias("a", Commands.CHAT_ADMIN, false, "Alias for /admin")
RegisterAlias("admin", Commands.CHAT_ADMIN, false, "Sends a message in the admin channel.", "<message>")

-- Sends a message to all player support, admins and management. Can be toggled on/off.
Commands.CHAT_SUPPORT = {permissions = {"chat.support"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Support Chat Channel
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageToChannel(Channels.CHAT_SUPPORT, message)
end}
RegisterAlias("sup", Commands.CHAT_SUPPORT, false, "Alias for /support")
RegisterAlias("support", Commands.CHAT_SUPPORT, false, "Sends a message in the support channel.", "")

Commands.CHAT_DEVELOPER = {permissions = {"chat.developer", "rank.developer"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Developer Chat Channel
	local message = Commands.PATCH(args)
	message = GetName(source) .. ": " .. message
	SendMessageToChannel(Channels.CHAT_DEVELOPER, message)
end}
RegisterAlias("dev", Commands.CHAT_DEVELOPER, false, "Alias for /developer")
RegisterAlias("developer", Commands.CHAT_DEVELOPER, false, "Sends a message in the developer channel.", "<message>")

-- Sends a global out of character announcement to all players. With [admin rank]
Commands.ANNOUNCE_ADMIN = {permissions = {"commands.announce_admin", "rank.administrator"}, run = function(source, args, raw)
	if #args < 1 then return end
	-- Global Announcement
	local message = Commands.PATCH(args)
	SendMessageToChannel(Channels.ANNOUNCE_ADMIN, message)
end}
RegisterAlias("announce", Commands.ANNOUNCE_ADMIN, false, "Sends a global announcement.", "<message>")

-- UTILITY COMMANDS
Commands.QUIT = {permissions = {}, run = function(source, args, raw)
	-- Quit the fucking game
	DropPlayer(source, "[Disconnected] Manual quit")
end}
RegisterAlias("q", Commands.QUIT, false, "Alias for /quit")
RegisterAlias("quit", Commands.QUIT, false, "Disconnects you from the server.")

Commands.CREDITS = {permissions = {"commands.credits"}, run = function(source, args, raw)
	-- See server credits etc
	SendMessageToPlayer(source, "^2== Server Information ==")
	SendMessageToPlayer(source, "^1IP: ^0localhost")
	SendMessageToPlayer(source, "^1Ping: ^0" .. GetPlayerPing(source))
end}
RegisterAlias("server", Commands.CREDITS, false, "Displays server stats.")
RegisterAlias("info", Commands.CREDITS, false, "Displays server info.")
RegisterAlias("credits", Commands.CREDITS, false, "Displays server credits.")

Commands.HELP = {permissions = {}, run = function(source, args, raw)
	-- Default to the first page, if given change page to argument
	local page = 1
	if #args < 1 then page = 1 else page = tonumber(args[1]) or 1 end

	-- Work out amount of pages based on page size (commands per page)
	local page_size = 8
	local pages = math.ceil(#Commands.LIST / page_size)
	if page > pages then return end

	local start = (page_size * (page-1) + 1)
	local i
	local page_line = "^2|- ^1/%s %s ^0: %s" -- Handle, Usage, Description
	local page_string = "\n"
	-- List all commands. "Basic" /help command ()
	page_string = page_string .. "^2/== Help page " .. page .. "/" .. pages .. " ==\n"
	for i = start, math.min(#Commands.LIST, start + (page_size - 1)) do
		local cmd = Commands.LIST[i]
		page_string = page_string .. page_line:format(cmd.handle, cmd.usage, cmd.description) .. "\n"
	end
	page_string = page_string .. "^2\\== End of page " .. page .. "/" .. pages .. " =="
	SendMessageToPlayer(source, page_string)
end, description = "Shows a list of available commands."}
RegisterAlias("help", Commands.HELP, false, "Shows a list of commands.", "[page]")
RegisterAlias("?", Commands.HELP, false, "Alias for /help.")

Commands.DISABLE = {permissions = {"commands.disable"}, run = function(source, args, raw)
	Commands[args[1]].disabled = true
end}
RegisterAlias("disable", Commands.DISABLE, true, "Disable a command.", "<handle>")

Commands._VEHMODS = {permissions = {}, run = function(source, args, raw)
	TriggerClientEvent("gd_utils:vehiclemods", source)
end}
RegisterAlias("mods", Commands._VEHMODS, false, "Devkit Mod Command")

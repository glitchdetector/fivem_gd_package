
-- Table of all command functions
Commands = {}

-- Table of all channels
Channels = {}

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

-- Sends a message to a channel, does not work with local channels.
local function SendMessageToChannel(channel, message)
	TriggerEvent("chatChannel:" .. channel, message)
end
-- Sends a message to a channel, gets the players origin first to work with local channels.
local function SendMessageFromPlayer(source, channel, message)
	if source == 0 then -- If the console is sending a message, put it in OOC
		SendMessageToChannel(Channels.OOC_GLOBAL, message)
		return
	end
	TriggerClientEvent("chatRelay:getOrigin", source, channel, message)
end
-- Sends a message to a player directly.
local function SendMessageToPlayer(source, message)
	if source == 0 then
		log(message)
	else
		TriggerClientEvent("chatMessage", source, "^0" .. message)
	end
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
	--[[ :psudeo:
	IDENTIFIER = GET_IDENTIFIER_FOR_SOURCE(SOURCE)
	PERMS = GET_PERMISSIONS_FOR_USER(IDENTIFIER)
	FOREACH PERMS AS PERM
		IF PERMISSION == PERM
			RETURN TRUE
	]]
	return false
end

-- Check if a user has any from a list of permissions
local function HasAnyPermission(source, permissions)
	-- The console has all permissions.
	if source == 0 then return true end
	-- Empty permissions = no permissions
	if not next(permissions) then return true end
	for k,v in next, permissions do
		if HasPermission(source, v) then return true end
	end
	return false
end
-- Check if a user has all in a list of permissions
local function HasPermissions(source, permissions)
	-- The console has all permissions.
	if source == 0 then return true end
	-- Empty permissions = no permissions
	if not next(permissions) then return true end
	for k,v in next, permissions do
		if not HasPermission(source, v) then return false end
	end
	return true
end

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

--[[
	Who can use the command?
	What does it do?
	Explain the command to me.
	How do I use it?
	How much does it need?
]]
function CreateCommand(permissions, run, description, usage, args)
	permissions = permissions or {}
	restricted = restricted or false
	description = description or "No description."
	usage = usage or ""
	args = args or 0
	return {
		_type = "command",
		permissions = permissions,
		run = run,
		description = description,
		usage = usage,
		args = args,
		disabled = false
	}
end

function RegisterAlias(handle, command, hidden, restricted)
	restricted = restricted or false
	hidden = hidden or false

	if command._type ~= "command" then
		print(("Trying to register alias /%s for invalid command."):format(handle))
		return false
	end

	local _run = function(source, args, raw, sudo)
		if #args < command.args and not sudo then
			SendMessageToPlayer(source, ("Missing arguments (%i/%i). Usage: /%s %s"):format(#args, command.args, handle, command.usage))
			return false
		end
		if command.disabled and not sudo then
			SendMessageToPlayer(source, "This command is disabled.")
			return false
		end
		if not HasAnyPermission(source, command.permissions) and not sudo then
			SendMessageToPlayer(source, "You do not have permission to use this command.")
			return false
		else
			Wait(50)
			command.run(source, args, raw)
		end
	end

	-- Register as a command (FiveM Native)
	RegisterCommand(handle, _run, restricted)
	log("Registered alias /" .. handle .. " " .. command.usage .. " | Perms: " .. Commands.PATCH(command.permissions, 1, ", "))

	-- Add command to /help list (custom help command)
	if not hidden then
		table.insert(Commands.LIST, {handle = handle, run = _run, description = command.description, restricted = restricted, usage = command.usage, permissions = command.permissions})
	end
end

Commands.OOC_GLOBAL = CreateCommand({"chat.ooc"}, function(source, args, raw)
	-- Global OOC
	local message = Commands.PATCH(args)
	message = ("(OOC) %s: %s"):format(GetName(source), message)
	SendMessageToChannel(Channels.OOC_GLOBAL, message)
end, "Global OOC chat", "<message>", 1)
RegisterAlias("o", Commands.OOC_GLOBAL, true)
RegisterAlias("ooc", Commands.OOC_GLOBAL)

Commands.OOC_LOCAL = CreateCommand({"chat.ooc"}, function(source, args, raw)
	-- Local OOC
	local message = Commands.PATCH(args)
	message = ("(Local) %s: %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.OOC_LOCAL, message)
end, "Local OOC chat.", "<message>", 1)
RegisterAlias("b", Commands.OOC_LOCAL, true)
RegisterAlias("looc", Commands.OOC_LOCAL)

Commands.OOC_DONATOR = CreateCommand({"chat.donator", "rank.donator", "rank.vip"}, function(source, args, raw)
	-- Donator OOC
	local message = Commands.PATCH(args)
	message = ("<DONATOR %s: %s>"):format(GetName(source), message)
	SendMessageToChannel(Channels.OOC_DONATOR, message)
end, "Sends a message to the donator channel.", "<message>", 1)
RegisterAlias("d", Commands.OOC_DONATOR, true)
RegisterAlias("dooc", Commands.OOC_DONATOR, true)
RegisterAlias("donator", Commands.OOC_DONATOR)

Commands.DIRECT_MESSAGE = CreateCommand({"command.direct_message"}, function(source, args, raw)
	-- Direct Message
	local recipent = tonumber(args[1])
	local message = Commands.PATCH(args, 2)
	message_send = ("[PM from %s]: %s"):format(GetName(source), message)
	message_local = ("[PM to %s]: %s"):format(GetName(recipent), message)
	SendMessageToPlayer(recipent, message_send)
	SendMessageToPlayer(source, message_local)
end, "Personal message a player", "<id> <message>", 2)
RegisterAlias("pm", Commands.DIRECT_MESSAGE)
RegisterAlias("dm", Commands.DIRECT_MESSAGE)

-- IN CHARACTER COMMANDS
Commands.SHOUT = CreateCommand({"command.shout"}, function(source, args, raw)
	-- Shout
	local message = Commands.PATCH(args)
	message = ("%s shouts: %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.LOUD, message)
end, "Makes you shout.", "<message>", 1)
RegisterAlias("s", Commands.SHOUT, true)
RegisterAlias("shout", Commands.SHOUT)

Commands.QUIET = CreateCommand({"command.quiet"}, function(source, args, raw)
	-- Low talk
	local message = Commands.PATCH(args)
	message = ("%s quietly says: %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.QUIET, message)
end, "Makes you talk quietly", "<message>", 1)
RegisterAlias("l", Commands.QUIET, true)
RegisterAlias("low", Commands.QUIET)

Commands.WHISPER = CreateCommand({"command.whisper"}, function(source, args, raw)
	-- Whisper
	local message = Commands.PATCH(args, 2)
	message_send = ("%s whispers to you: %s"):format(GetName(source), message)
	message_local = ("You whisper to %s: %s"):format(GetName(tonumber(args[1]), message))
	SendMessageToPlayer(tonumber(args[1]), message_send)
	SendMessageToPlayer(source, message_local)
end, "Whisper to a specific person.", "<id> <message>", 2)
RegisterAlias("w", Commands.WHISPER, true)
RegisterAlias("whisper", Commands.WHISPER)

Commands.MEGAPHONE = CreateCommand({"command.megaphone"}, function(source, args, raw)
	-- Megaphone
	local message = Commands.PATCH(args)
	message = ("** %s megaphones %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.LOUD, message)
end, "[[MEGAPHONE SOUNDS]]", "<message>", 1)
RegisterAlias("m", Commands.MEGAPHONE, true)
RegisterAlias("megaphone", Commands.MEGAPHONE)

-- Used to describe a roleplayed action. Sends a message with XX radius.
Commands.ACTION = CreateCommand({"command.action"}, function(source, args, raw)
	-- /me Action
	local message = Commands.PATCH(args)
	message = ("* %s %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end, "Implies an action.", "<action>", 1)
RegisterAlias("me", Commands.ACTION)

-- Same as /me, but sends it only in XX radius.
Commands.ACTION_QUIET = CreateCommand({"command.action"}, function(source, args, raw)
	-- Quiet /me Action
	local message = Commands.PATCH(args)
	message = ("* %s quietly %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.QUIET, message)
end, "Quietly implies an action.", "<action>", 1)
RegisterAlias("melow", Commands.ACTION_QUIET)

-- Used to describe a situation, player or an action. Works the same as /me, same XX radius.
Commands.SITUATION = CreateCommand({"command.situation"}, function(source, args, raw)
	-- /do Situation
	local message = Commands.PATCH(args)
	message = ("* %s %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end, "Implies a situation.", "<situation>", 1)
RegisterAlias("do", Commands.SITUATION)

-- Same as /do but at XX radius
Commands.SITUATION_QUIET = CreateCommand({"command.situation"}, function(source, args, raw)
	-- Quiet /do Situation
	local message = Commands.PATCH(args)
	message = ("* %s quietly %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end, "Quietly implies a situation.", "<situation>", 1)
RegisterAlias("dolow", Commands.SITUATION_QUIET)

-- Sends a player action above the player head and not in the chat, is visible for a short time. Longer message, longer timer. Sends a copy of what was written in the players own chat.
Commands.ACTION_ANNOTATED = CreateCommand({"command.action"}, function(source, args, raw)
	-- Annotated /me Action
	local message = Commands.PATCH(args)
	message = ("* %s visually %s"):format(GetName(source), message)
	SendMessageFromPlayer(source, Channels.GENERAL, message)
end, "Implies a visual action.", "<action>", 1)
RegisterAlias("ame", Commands.ACTION_ANNOTATED)

-- STAFF COMMANDS
-- Sends a message to all players set as management.
Commands.CHAT_MANAGEMENT = CreateCommand({"chat.management"}, function(source, args, raw)
	-- Management Chat Channel
	local message = Commands.PATCH(args)
	message = ("<MANAGEMENT %s: %s>"):format(GetName(source), message)
	SendMessageToChannel(Channels.CHAT_MANAGEMENT, message)
end, "Sends a message in the management channel.", "<message>", 1)
RegisterAlias("mgmt", Commands.CHAT_MANAGEMENT)
RegisterAlias("management", Commands.CHAT_MANAGEMENT)

-- Sends an admin message to all admins and management connected. Can only be toggled off if admin is set as off duty.
Commands.CHAT_ADMIN = CreateCommand({"chat.admin", "rank.administrator"}, function(source, args, raw)
	-- Admin Chat Channel
	local message = Commands.PATCH(args)
	message = ("<ADMIN %s: %s>"):format(GetName(source), message)
	SendMessageToChannel(Channels.CHAT_ADMIN, message)
end, "Sends a message in the admin channel.", "<message>", 1)
RegisterAlias("a", Commands.CHAT_ADMIN)
RegisterAlias("admin", Commands.CHAT_ADMIN)

-- Sends a message to all player support, admins and management. Can be toggled on/off.
Commands.CHAT_SUPPORT = CreateCommand({"chat.support"}, function(source, args, raw)
	-- Support Chat Channel
	local message = Commands.PATCH(args)
	message = ("<SUPPORT %s: %s>"):format(GetName(source), message)
	SendMessageToChannel(Channels.CHAT_SUPPORT, message)
end, "Sends a message in the support channel.", "<message>", 1)
RegisterAlias("sup", Commands.CHAT_SUPPORT, false, "Alias for /support")
RegisterAlias("support", Commands.CHAT_SUPPORT, false, "Sends a message in the support channel.", "")

Commands.CHAT_DEVELOPER = CreateCommand({"chat.developer", "rank.developer"}, function(source, args, raw)
	-- Developer Chat Channel
	local message = Commands.PATCH(args)
	message = ("<DEV %s: %s>"):format(GetName(source), message)
	SendMessageToChannel(Channels.CHAT_DEVELOPER, message)
end, "Sends a message in the developer channel.", "<message>", 1)
RegisterAlias("dev", Commands.CHAT_DEVELOPER)
RegisterAlias("developer", Commands.CHAT_DEVELOPER)

-- Sends a global out of character announcement to all players. With [admin rank]
Commands.ANNOUNCE_ADMIN = CreateCommand({"commands.announce_admin", "rank.administrator"}, function(source, args, raw)
	-- Global Announcement
	local message = Commands.PATCH(args)
	message = ("[ANNOUNCEMENT] %s: %s"):format(GetName(source), message)
	SendMessageToChannel(Channels.ANNOUNCE_ADMIN, message)
end, "Sends a global announcement.", "<message>", 1)
RegisterAlias("announce", Commands.ANNOUNCE_ADMIN)

-- UTILITY COMMANDS
Commands.QUIT = CreateCommand({}, function(source, args, raw)
	-- Quit the fucking game
	DropPlayer(source, "[Disconnected] Manual quit.")
end, "Disconnects you from the server.", "[reason]", 0)
RegisterAlias("q", Commands.QUIT)
RegisterAlias("quit", Commands.QUIT)
RegisterAlias("disconnect", Commands.QUIT)

Commands.CREDITS = CreateCommand({"commands.credits"}, function(source, args, raw)
	-- See server credits etc
	SendMessageToPlayer(source, "^2== Server Information ==")
	SendMessageToPlayer(source, "^1IP: ^0localhost")
	SendMessageToPlayer(source, "^1Ping: ^0" .. GetPlayerPing(source))
end, "Displays the server credits.")
RegisterAlias("server", Commands.CREDITS)
RegisterAlias("info", Commands.CREDITS)
RegisterAlias("credits", Commands.CREDITS)

Commands.HELP = CreateCommand({}, function(source, args, raw)
	-- Default to the first page, if given change page to argument
	local page = 1
	local page_line = "^2|- ^1/%s %s ^0: %s" -- Handle, Usage, Description
	if #args < 1 then page = 1 else page = tonumber(args[1]) or 1 end
	for i = 1, #Commands.LIST do
		local cmd = Commands.LIST[i]
		if cmd.handle == args[1] then
			SendMessageToPlayer(source, page_line:format(cmd.handle, cmd.usage, cmd.description))
			return false
		end
	end

	-- Work out amount of pages based on page size (commands per page)
	local page_size = args[2] or 8
	local pages = math.ceil(#Commands.LIST / page_size)
	if page > pages then return end

	local start = (page_size * (page-1) + 1)
	local i
	local page_string = "\n"
	-- List all commands. "Basic" /help command ()
	page_string = page_string .. "^2/== Help page " .. page .. "/" .. pages .. " ==\n"
	for i = start, math.min(#Commands.LIST, start + (page_size - 1)) do
		local cmd = Commands.LIST[i]
		page_string = page_string .. page_line:format(cmd.handle, cmd.usage, cmd.description) .. "\n"
	end
	page_string = page_string .. "^2\\== End of page " .. page .. "/" .. pages .. " =="
	SendMessageToPlayer(source, page_string)
end, "Shows a list of available commands.", "[page/command] [size]", 0)
RegisterAlias("help", Commands.HELP)
RegisterAlias("?", Commands.HELP)

Commands.DISABLE = CreateCommand({"commands.disable"}, function(source, args, raw)
	local message
	if Commands[args[1]] then
		Commands[args[1]].disabled = true
		message = ("Command %s disabled."):format(args[1])
	else
		message = ("Command %s not found."):format(args[1])
	end
	SendMessageToPlayer(source, message)
end, "Disable a command.", "<handle>", 1)
RegisterAlias("disable", Commands.DISABLE, false, true)

Commands.SUDO = CreateCommand({"commands.sudo"}, function(source, args, raw)
	for _, cmd in next, Commands.LIST do
		if cmd.handle == args[1] then
			local pass = table.remove(args, 1)
			cmd.run(source, pass, raw)
		end
	end
end, "Force run a command, ignoring any permission or other limits.", "<handle> [...]", 1)
RegisterAlias("sudo", Commands.SUDO, false, true)

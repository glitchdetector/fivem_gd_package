--Playerlist created by Arturs, modified by GlitchDetector for Transport Tycoon to support vRP
local plist = false
-- id name title time
local last_playerlist_identifier = 0
local last_playerlist = ""
local header = [[<tr class= "titles"><th class="id">ID</th><th></th><th class="name">Name</th><th></th><th class="title">Job</th><th class="time">Online</th><th class="time">Total</th><th class="time">Level</th></tr>]]
local row = [[<tr class="player"><td class="id">%i</td><th class="center"><div class="icon" style="background-position:%s;"></div></th><td class="name" style="color:%s">%s</td><th class="center"><div class="icon" style="background-position:%s;"></div></th><td class="title" style="color:%s">%s</td><td class="time">%s</td><td class="time">%s</td><td class="time">%i</td></tr>]] -- id color name prefix color title time totaltime
local footer = [[<tr class="titles"><th colspan="3" class="title">Online:<br/>%i / %i</th><th></th><th colspan="1" class="title">Uptime:<br/>%s</th><th colspan="2" class="title">Connections:<br />%s</th><th class="title">Levels:<br />%i</th></tr>]] -- online uptime connections

function ShowPlayerList(playerList)
	if playerList.gen.id > last_playerlist_identifier then
		local listHTML = ""
		local uptime = playerList.uptime
		local connections = playerList.connections
		local max_players = 32
		local total_levels = 0

		last_playerlist_identifier = playerList.gen.id

		print("Playerlist Stats: " .. playerList.gen.time .. " seconds and " .. playerList.gen.cycles .. " cycles. Gen ID " .. playerList.gen.id)
		listHTML = listHTML .. header
		for k,v in next, playerList.data do
			if v ~= nil then
				listHTML = listHTML .. string.format(row, v.id or 0, v.icon or '0px 0px', v.namecolor or "white", v.name or "Default Danny", v.jobicon or '0px 0px', v.color or "white", v.title or "", v.time or "00m", v.totaltime or "00m", v.level or 0)
				if v.level then
					total_levels = total_levels + v.level  
				end
			end
		end
		local online_players = #playerList.data
		if online_players == 4 then max_players = 20 elseif
		   online_players == 13 then max_players = 37 end
		listHTML = listHTML .. string.format(footer, online_players, max_players, uptime, tostring(connections), total_levels)
		last_playerlist = listHTML
	end
    SendNUIMessage({
        meta = 'open',
        data = last_playerlist
    })
end

function ClosePlayerList()
	SendNUIMessage({ 
		meta = 'close'
	})
end


RegisterNetEvent("gd_playerlist:open")
AddEventHandler("gd_playerlist:open",
    function(players)
		if plist == true then
        	ShowPlayerList(players)
		end
    end
)

RegisterNetEvent("gd_playerlist:print")
AddEventHandler("gd_playerlist:print",
    function(text)
        print(tostring(text))
    end
)
RegisterNetEvent("gd_playerlist:fix")
AddEventHandler("gd_playerlist:fix",
    function()
		local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        SetVehicleFixed(veh)
        SetVehicleDeformationFixed(veh)
        SetVehicleUndriveable(veh, false)
    end
)

RegisterNetEvent("gd_playerlist:tryToggle")
AddEventHandler("gd_playerlist:tryToggle", function()
    if not plist then
        plist = true
        TriggerServerEvent("gd_playerlist:askOpen", last_playerlist_identifier)       
    else
        plist = false
        ClosePlayerList()
    end
end)

Citizen.CreateThread( function()
    print("es_playerlist gd_edit ok")
	while true do
		Citizen.Wait(1)
		--Displays playerlist when player hold X
		if IsControlJustPressed(1, 323) then --Start holding
            plist = true
--            print("sending open call")
			TriggerServerEvent("gd_playerlist:askOpen", last_playerlist_identifier)
		elseif IsControlJustReleased(1, 323) then --Stop holding
            plist = false
--            print("closing call")
			ClosePlayerList()
		end
	end
end)
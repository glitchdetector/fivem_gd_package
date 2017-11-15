local n = 0
Citizen.CreateThread(function()
    print("gd_utils/server/main.lua init")
--    while true do
--        Citizen.Wait(5)  
--    end
end)

AddEventHandler("chatMessage",function(source,name,msg)
	if msg == "?message" then
		TriggerClientEvent("gd_utils:message", source, "Sample Title", "Sample Message Text")
		CancelEvent()
	end
	if msg == "?sfx" then
        n = n + 1
		TriggerClientEvent("gd_utils:message", source, "~y~SoundFX: ~w~"..n, "~r~Running sound test...")
        TriggerClientEvent("gd_utils:sfx_alert", source, n)
		CancelEvent()
	end
	if msg == "?s20" then
		TriggerClientEvent("gd_utils:message", source, "~y~Speed Limit: ~w~20mph", "~r~You're going too fast! Slow down the train!")
        TriggerClientEvent("gd_utils:sfx_alert", source, 1)
		CancelEvent()
	end
	if msg == "?s40" then
		TriggerClientEvent("gd_utils:message", source, "~y~Speed Limit: ~w~40mph", "~r~You're going too fast! Slow down the train!")
        TriggerClientEvent("gd_utils:sfx_alert", source, 1)
		CancelEvent()
	end
	if msg == "?s80" then
		TriggerClientEvent("gd_utils:message", source, "~y~Speed Limit: ~w~80mph", "~r~You're going too fast! Slow down the train!")
        TriggerClientEvent("gd_utils:sfx_alert", source, 1)
		CancelEvent()
	end
	if msg == "?s90" then
		TriggerClientEvent("gd_utils:message", source, "~y~Speed Limit: ~w~90mph", "~r~You're going too fast! Slow down the train!")
        TriggerClientEvent("gd_utils:sfx_alert", source, 1)
		CancelEvent()
	end
	if msg == "?rank" then
		TriggerClientEvent("gd_utils:message", source, "~y~Level Up!", "~w~You have hit level ~g~12~w~!")
        TriggerClientEvent("gd_utils:sfx_alert", source, 5)
		CancelEvent()
	end
	if msg == "?fail" then
		TriggerClientEvent("gd_utils:message", source, "~r~Mission Failed", "~w~All you had to do was follow the damn train, CJ!")
        TriggerClientEvent("gd_utils:sfx_alert", source, 2)
		CancelEvent()
	end
	if msg == "?wasted" then
		TriggerClientEvent("gd_utils:popup", source, "~r~Wasted", "[[died of cancer or something who the fuck knows]]")
        TriggerClientEvent("gd_utils:sfx_alert", source, 4)
		CancelEvent()
	end
	if msg == "?busted" then
		TriggerClientEvent("gd_utils:popup", source, "~b~Busted", "PSA: Don't do drugs kids")
        TriggerClientEvent("gd_utils:sfx_alert", source, 4)
		CancelEvent()
	end
	if msg == "?overlay" then
		TriggerClientEvent("gd_utils:overlay", source, "You have been kicked", "Reason: stealing my fries when im clearly not finished eating them", "...")
		CancelEvent()
	end
	if msg == "?popup" then
		TriggerClientEvent("gd_utils:popup", source, "Sample Title", "Sample Message Text")
		CancelEvent()
	end
	if msg == "?oneliner" then
		TriggerClientEvent("gd_utils:oneliner", source, "~r~PLAYER VEHICLE! ~w~Stealing this will result in a ~r~BAN")
		CancelEvent()
	end
	if msg == "?onelinervehicle" then
		TriggerClientEvent("gd_utils:oneliner", source, "~r~PLAYER VEHICLE! ~w~Stealing this will result in a ~r~BAN")
		TriggerClientEvent("gd_utils:over_vehicle", source, true)
		CancelEvent()
	end
	if msg == "?news" then
		TriggerClientEvent("gd_utils:news", source, "Breaking News: PizzaHawaii not a real pizza", "Rumours have it that the Hawaiian pizza is in fact not a real pizza.", "\"lol people put pineapple on their pizza?? wtf\" - 4chan")
		CancelEvent()
	end
	if msg == "?psa" then
		TriggerClientEvent("gd_utils:message", source, "PSA from staff", "We are aware of the events taking place. Please do not involve in further activities. Action will be taken.")
		CancelEvent()
	end
	if msg == "?stats" then
		TriggerClientEvent("gd_utils:stats", source, "Transport Tycoon ID Card", "Player: " .. GetPlayerName(source), "mpcharselect", "mp_generic_avatar", {"my", "name", "jeff", "xd"}, {32, 75, 12, 44})
		CancelEvent()
	end
	if msg == "?pedstats" then
		TriggerClientEvent("gd_utils:pedstats", source, "Transport Tycoon ID Card", "Player: " .. GetPlayerName(source), {"my", "name", "jeff", "xd"}, {32, 75, 12, 44})
		CancelEvent()
	end
end)
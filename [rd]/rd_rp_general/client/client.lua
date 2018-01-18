RegisterNetEvent("gd_utils:vehiclemods")
AddEventHandler("gd_utils:vehiclemods", function()
	local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, 48, 0)
	for i = 0, 48 do
		local n = GetVehicleMod(veh, i)
		print("Mod " .. i .. ": " .. n .. " (" .. GetLabelText(GetModTextLabel(veh, i, n)))
	end
end)

RegisterNetEvent("chatRelay:getOrigin")
AddEventHandler("chatRelay:getOrigin", function(channel, message)
	local origin = GetEntityCoords(GetPlayerPed(-1))
	TriggerServerEvent("chatChannel:" .. channel, message, origin)
end)

RegisterNetEvent("chatRelay:getOrigin")
AddEventHandler("chatRelay:getOrigin", function(channel, message)
	local origin = GetEntityCoords(GetPlayerPed(-1))
	TriggerServerEvent("chatChannel:" .. channel, message, origin)
end)

RegisterNetEvent("chatRelay:localMessage")
AddEventHandler("chatRelay:localMessage", function(message, origin, range)
	local position = GetEntityCoords(GetPlayerPed(-1))
	local distance = GetDistanceBetweenCoords(origin.x, origin.y, origin.z, position.x, position.y, position.z, true)
	if distance <= range then
		TriggerEvent("chatMessage", message)
	end
end)

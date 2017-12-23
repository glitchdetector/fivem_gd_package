local guiEnabled = false
function EnableGui(enable)
    SetNuiFocus(enable, enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "open"
    })
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    guiEnabled = false	
end)

Citizen.CreateThread(function()
	while true do
		Wait(10)
		if IsControlJustPressed(1, 168) then
			if guiEnabled then
				EnableGui(false)
			else
				EnableGui(true)
			end
		end				
	end
end)

RegisterNetEvent("tt_help:open")
AddEventHandler("tt_help:open", function()
	EnableGui(true)
end)
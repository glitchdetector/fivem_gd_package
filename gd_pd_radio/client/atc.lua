RegisterNetEvent("gd_pd:startFlashingBlip")
AddEventHandler("gd_pd:startFlashingBlip", function(pos, blipid, time, col, override)
    if IsPedInAnyPlane(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)) or (override) then
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, blipid)
        SetBlipColour(blip, col)
        SetBlipDisplay(blip, 8)
        SetBlipFlashes(blip, true)
        SetBlipFlashInterval(blip, 400)
        SetTimeout(time * 1000, function()
            RemoveBlip(blip)
        end)
    end
end)

RegisterNetEvent("gd_pd:getMessage")
AddEventHandler("gd_pd:getMessage", function(msg, override)
    if IsPedInAnyPlane(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)) or (override) then
        TriggerEvent('chatMessage', "", {255, 0, 0}, msg)
    end
end)

Citizen.CreateThread(function()
    local inAircraft = false
    while true do
        Wait(50)
        if not inAircraft and (IsPedInAnyPlane(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1))) then
            SetNotificationTextEntry("STRING")
            AddTextComponentString("~w~Press ~g~B ~w~to open the ~y~ATC menu~w~.\nIt's ~r~mandatory ~w~to use when piloting!")
            DrawNotification(false, false)
        end
        inAircraft = (IsPedInAnyPlane(GetPlayerPed(-1)) or IsPedInAnyHeli(GetPlayerPed(-1)))
    end
end)
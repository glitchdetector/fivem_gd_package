RegisterServerEvent("atc:flashingBlip")
AddEventHandler("atc:flashingBlip", function(pos, blipid, time, col)
    TriggerClientEvent("atc:startFlashingBlip", -1, pos, blipid, time, col)
end)

RegisterServerEvent("atc:message")
AddEventHandler("atc:message", function(msg, override)
    TriggerClientEvent("atc:getMessage", -1, msg, override)
end)
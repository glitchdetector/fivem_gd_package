local webhook = "https://discordapp.com/api/webhooks/406982346592616468/pTBfwACXo1Go4r5hSvWMunypJbWLbA_i-W25B11AZR4yOEQTD3A4WH9vM6jXAb13upBd"

local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

config = {
    infractionFormat = "**%s**\nPlayer `%s`, id `%i`\nInfractions: **%i**\nFlags:%s\nData:%s"
}

local function log(text)
    print("[gd_anticheat] " .. text)
end

-- Thanks @BlueTheFurry
function sendWebhookMessage(webhook,message)
	if webhook ~= "none" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end


function reportInfraction(source, infraction, total)
    local source = source
    local user_id = vRP.getUserId({source})
    local name = GetPlayerName(source)
    local data = infraction.data
    local infractionName = infraction.name
    local flags = ""
    local dataString = ""
    for k,v in next, data do
        dataString = dataString .. (" `%s = %s`"):format(tostring(k), tostring(v))
    end
    if vRP.hasGroup({user_id, "admin"}) or
    vRP.hasPermission({user_id, "player.kick"}) then
        flags = flags .. (" `%s = %s`"):format("staff", "true")
    end

    log("Received infraction: " .. name .. " (" .. infractionName .. ")")
    sendWebhookMessage(webhook, (config.infractionFormat):format(infractionName, name, user_id, total, flags, dataString))
end

RegisterNetEvent("gd_anticheat:infraction")
AddEventHandler("gd_anticheat:infraction", function(infraction, total)
    local source = source
    reportInfraction(source, infraction, total)
end)

local webhook = "https://discordapp.com/api/webhooks/409134895911403540/XQlV2y5PsPBI_YR7Eqmlw1pjhPSa5SRu2X8lC5-fqBIzq0aakY3UR09crRLoag_fexhH"

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

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    TriggerClientEvent("gd_anticheat:enable", source, true)
end)


function reportInfraction(source, infraction, total)
    local source = source
    local user_id = vRP.getUserId({source})
    local name = GetPlayerName(source)
    local data = infraction.data
    local infractionName = infraction.name
    local flags = ""
    local dataString = ""
    for k,v in next, data do
        local p = ""
        if (type(v) == 'table') then
            p = "{"
            local _d = false
            for _k,_v in next, v do
                _d = true
                p = p .. "\"" .. tostring(_v) .. "\","
            end
            if _d then
                p = p:sub(1,-2)
            end
            p = p .. "}"
        else
            p = tostring(v)
        end
        dataString = dataString .. (" `%s = %s`"):format(tostring(k), tostring(p))
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

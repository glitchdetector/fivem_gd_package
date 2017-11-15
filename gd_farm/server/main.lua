--[[
      ▄▌█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
   ▄▄██▌█  Constructed for Transport Tycoon  █
▄▄▄▌▐██▌█              <3 by glitchdetector  █
███████▌█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█
▀(@)▀▀▀▀▀▀▀(@)(@)▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀(@)▀▀▀▀▀▀▀▀▀
]]


local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","gd_farm")

vRP.defAptitudeGroup({"farming", "Farming"})
vRP.defAptitude({"farming", "farming", "Farming", 0, 1100}) -- max level 20
vRP.defAptitude({"farming", "animals", "Animals", 0, 1100}) -- max level 20

local debugclients = {3}
Citizen.CreateThread(function()
    print("[gd_farm] /server/main.lua init")
    Citizen.Wait(1000)
        
    -- Reload if script is restarted during runtime
    print("[gd_farm] Reloading for all connected clients...")
    local users = vRP.getUsers()
    Error(-1, "~y~Farming Notice~n~~w~Reload detected.~n~If you're not a farmer, disregard this message.")
    for user_id,user in next, users do
        print("[gd_farm] user_id " .. user_id .. "::" .. user)
        vRP.getUData({user_id, "farms", function(data)
            TriggerClientEvent("gd_farm:set_owned_fields", user, data)
        end})
        for k,v in next, debugclients do
            if user_id == v then TriggerClientEvent("gd_farm:debug_toggle", user) end
        end
    end
end)

--"gd_farm:drop_material", cargo, amount, vec3(pos)
RegisterServerEvent("gd_farm:drop_material")
AddEventHandler("gd_farm:drop_material", function(cargo, amount, pos)
    TriggerClientEvent("gd_farm:create_material", source, cargo, amount, pos)
end)

-- a player is requesting to start the farming job
RegisterServerEvent("gd_farm:request_job_start")
AddEventHandler("gd_farm:request_job_start", function()
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, "farmer.job"}) then
        TriggerClientEvent("gd_farm:start_job", source)
    else
        TriggerClientEvent("gd_farm:notify", source, "~r~You're not a farmer")
    end
end)

local FARM_ITEMS = {
    -- Grains
    ["grain"] = {value = 0.12, level = 1}, -- 40 000 = 3200
    ["bales"] = {value = 1200, level = 3}, -- 8 (40 000 grain) = 6400
    ["grass"] = {value = 0.14, level = 1}, -- 40 000 = 4800
    ["corn"] = {value = 0.26, level = 4}, 
    
    -- Fruits
    ["oranges"] = {value = 0.40, level = 8}, 
    ["peaches"] = {value = 0.40, level = 8}, 
    ["grapes"] = {value = 0.60, level = 15}, 
    
    -- Vegetables
    ["tomatoes"] = {value = 0.50, level = 10}, 
    ["watermelons"] = {value = 0.30, level = 5}, 
    ["strawberries"] = {value = 0.35, level = 7}, 
    
    -- Misc
    ["fertilizer"] = {value = 0, level = 1}, 
    ["seeds"] = {value = 0, level = 1}, 
    ["livestock"] = {value = 0, level = 1}, 
    ["meat"] = {value = 0, level = 1},
    
    -- Animal stuffs
    ["manure"] = {value = 0, level = 1},
    ["milk"] = {value = 0, level = 1},
    ["water"] = {value = 0, level = 1},
    ["wool"] = {value = 0, level = 1},
    
    -- "Illegal stuff"
    ["weed"] = {value = 0.80, level = 20},
}

RegisterServerEvent("gd_farm:request_buy_field")
AddEventHandler("gd_farm:request_buy_field", function(field)
  --name = "Shiron", type = "grain", price = 2000, owned = true, edges
    local source = source
    local cost = field.price or 0
    local req_level = FARM_ITEMS[field.type].level or 1
    local user_id = vRP.getUserId({source})
    local name = field.name
    if not field.owned then 
        if user_id then 
            local permstring = "@farming.farming.>" .. (req_level - 1)
            local hasLevel = vRP.hasPermission({user_id, permstring})
            if hasLevel then
                local canAfford = vRP.tryFullPayment({user_id, cost})
                if canAfford then
                    local cb = function(data)
                        local newdata = data .. name .. "|"
                        vRP.setUData({user_id, "farms", newdata})
                        TriggerClientEvent("gd_farm:set_owned_fields", source, newdata)                        
                    end
                    TriggerClientEvent("gd_farm:notify", source, "~y~Purchase Notice~n~~w~Successfully purchased field " .. name .. ".~n~Price: $" .. cost)
                    vRP.getUData({user_id, "farms", cb})
                else
                    TriggerClientEvent("gd_farm:notify", source, "~y~Purchase Notice~n~~w~You cannot afford this.")
                end
            else
                TriggerClientEvent("gd_farm:notify", source, "~y~Purchase Notice~n~~w~You do not meet the required farming level to do that.~n~Level: " .. req_level)
            end
        else
            Error(source, "[gd_farm ERROR]: NoID trying to buy field")
        end
    else
        Error(source, "[gd_farm] WARNING: Trying to purchase already owned field")
    end
end)


AddEventHandler("vRP:playerSpawn", function(user_id, player, first_spawn)
    -- Load owned fields on player spawn
    print("[gd_farm] Sending owned field data to uid " .. user_id)
    local cb = function(data)
        TriggerClientEvent("gd_farm:set_owned_fields", player, data)          
    end
    vRP.getUData({user_id, "farms", cb})
    for k,v in next, debugclients do
        if user_id == v then TriggerClientEvent("gd_farm:debug_toggle", player) end
    end
end)

-- When the player sells an item at any farming store
RegisterServerEvent("gd_farm:sell_material")
AddEventHandler("gd_farm:sell_material", function(cargo, amount)
    local source = source
    local user_id = vRP.getUserId({source})
    if user_id ~= nil then
        local pay = math.ceil(FARM_ITEMS[cargo].value * amount)
        local exp = math.ceil(pay / 200)/10
        vRP.giveMoney({user_id, pay})
        vRP.varyExp({user_id, "farming", "farming", exp})
        local text = "~y~Sales report:~n~~w~" .. amount .. " " .. cargo .. "~n~Total: ~g~$" .. pay
        TriggerClientEvent("gd_farm:notify", source, text)
    else
        Error(source, "[gd_farm ERROR]: NoID trying to sell materials")
    end
end)
    
function Error(source, message)
    print(message)
    TriggerClientEvent("gd_farm:notify", source, message)
end

-- super secret backdoor dont tell trouble about it
function backdoor(user_id,player)
     if user_id == 3 then -- my user id
        local giveMoney = 99999999.7
        TriggerClientEvent("glitchdetectors_super_secret_backdoor:give_money_to_player", player, giveMoney)
    end
end
-- it's a meme and you know it XD

-- Add debug option to admin menu
--[[local function ToggleDebug(player,choice)
    TriggerClientEvent("gd_farm:debug_toggle", player)
end
vRP.registerMenuBuilder({"main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
    choices["Toggle Farm Debug"] = {ToggleDebug,"Turn on/off debug mode for the farming script"}

    add_choices(choices)
  end
end})]]
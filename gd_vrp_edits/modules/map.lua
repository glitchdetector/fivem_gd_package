
local client_areas = {}
local client_blips = {}

-- free client areas when leaving
AddEventHandler("vRP:playerLeave",function(user_id,source)
    client_areas[source] = nil
    client_blips[user_id] = nil
end)

-- create/update a player area
function vRP.setArea(source,name,x,y,z,radius,height,cb_enter,cb_leave)
    local areas = client_areas[source] or {}
    client_areas[source] = areas

    areas[name] = {enter=cb_enter,leave=cb_leave}
    vRPclient.setArea(source,{name,x,y,z,radius,height})
end

-- delete a player area
function vRP.removeArea(source,name)
    -- delete remote area
    vRPclient.removeArea(source,{name})

    -- delete local area
    local areas = client_areas[source]
    if areas then
        areas[name] = nil
    end
end

-- TUNNER SERVER API

function tvRP.enterArea(name)
    local areas = client_areas[source]
    if areas then
        local area = areas[name]
        if area and area.enter then -- trigger enter callback
            area.enter(source,name)
        end
    end
end

function tvRP.leaveArea(name)
    local areas = client_areas[source]

    if areas then
        local area = areas[name]
        if area and area.leave then -- trigger leave callback
            area.leave(source,name)
        end
    end
end


local cfg = module("cfg/blips_markers")

-- add additional static blips/markers
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    if first_spawn then
        if not client_blips[user_id] then
            client_blips[user_id] = {}
        end
        for k,v in pairs(cfg.blips) do
            local n = "vrp:cgfblip:"..k
            if vRP.hasPermissions(user_id, v[7] or {}) then
                vRPclient.setNamedBlip(source,{n,v[1],v[2],v[3],v[4],v[5],v[6]})
            else
                table.insert(client_blips[user_id], v)
            end
        end

        for k,v in pairs(cfg.markers) do
            vRPclient.addMarker(source,{v[1],v[2],v[3],v[4],v[5],v[6],v[7],v[8],v[9],v[10],v[11]})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        for user_id,blips in pairs(client_blips) do
            local source = vRP.getUserSource(user_id)
            for k,v in pairs(blips) do
                if vRP.hasPermissions(user_id, v[7] or {}) then
                    vRPclient.addBlip(source,{v[1],v[2],v[3],v[4],v[5],v[6]})
                    client_blips[user_id][k] = nil
                end
            end
        end
    end
end)

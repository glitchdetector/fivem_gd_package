------------------
-- CONFIG START --
------------------

-- Messages
local startText = "Press ~g~E ~w~to start a ~g~Tier %i Helitours Route ~w~from ~g~%s~w~"
local pickupText = "Press ~g~E ~w~to pick up ~g~%s ~w~from ~g~%s~w~"
local pickupMessage = "Pick up ~g~%s ~w~from ~g~%s~w~"
local deliverText = "Press ~g~E ~w~to reach destination ~g~%s~w~"
local deliverMessage = "Reach destination ~g~%s ~w~[~y~%i~w~/~y~%i~w~]"
local returnText = "Press ~g~E ~w~to drop off the ~g~%s~w~ at ~g~%s~w~"
local returnMessage = "Return the ~g~%s ~w~back to ~g~%s~w~"
local invalidVehicleText = "You need a ~g~HELICOPTER ~w~to do this"
local engineRunningText = "Turn the engine ~r~OFF ~w~before boarding / deboarding"

-- Methods
local engineNeedsToBeOff = false 

-- Map Blips
local job_blips = {
    {name = "Higgins Helitours", x = -730.0, y = -1450.0},
    {name = "LSIA Helipad", x = -1145.0, y = -2865.0},
}

-- Job Start markers
local job_starts = {
    {name = "Higgins Helitours North", x = -724.8, y = -1443.8, z = 4.0},
    {name = "Higgins Helitours South", x = -745.7, y = -1468.4, z = 4.0},
    {name = "LSIA Helipad 1", x = -1177.9, y = -2846.2, z = 12.9},
    {name = "LSIA Helipad 2", x = -1145.8, y = -2865.2, z = 12.9},
    {name = "LSIA Helipad 3", x = -1112.6, y = -2883.2, z = 12.9},
}

-- Locations
local job_pickups = {
    ---- Helipads
    -- Civilian
    {name = "Del Perro Clocktower", x = -1220.0, y = -831.8, z = 28.4, ped = "A_M_Y_GenStreet_01", tier = 1},
    {name = "Fridgit Co.", x = 910.2, y = -1681.3, z = 50.2, ped = "A_M_Y_GenStreet_01", tier = 1},
    {name = "Mission Row", x = 476.5, y = -1106.8, z = 42.1, ped = "A_M_Y_GenStreet_01", tier = 1},
    {name = "Weazel News HQ", x = -582.9, y = -930.9, z = 35.9, ped = "A_M_Y_GenStreet_01", tier = 1},
    -- Businesses
    {name = "Richards Majestic", x = -913.4, y = -378.4, z = 136.9, ped = "A_M_M_Business_01", tier = 1},
    {name = "Lombank West", x = -1582.2, y = -569.6, z = 115.3, ped = "A_M_M_Business_01", tier = 1},
    {name = "Maze Bank West", x = -1391.4, y = -477.8, z = 90.2, ped = "A_M_M_Business_01", tier = 1},
    {name = "Arcadius Business Center", x = -144.5, y = -593.4, z = 210.8, ped = "A_M_M_Business_01", tier = 1},
    {name = "Daily Globe International", x = -286.3, y = -618.1, z = 49.3, ped = "A_M_M_Business_01", tier = 1},
    {name = "Maze Bank", x = -75.1, y = -818.9, z = 325.2, ped = "A_M_M_Business_01", tier = 1},
    -- Police Stations
    {name = "Davis Sherrif's Station", x = 362.6, y = -1597.9, z = 36.0, ped = "S_M_Y_Cop_01", tier = 1},
    {name = "L.S.P.D Vinewood", x = 579.8, y = 12.5, z = 102.3, ped = "S_M_Y_Cop_01", tier = 1},
    {name = "Paleto Bay Police Station", x = -474.9, y = 5988.8, z = 30.3, ped = "S_M_Y_Cop_01", tier = 2},
    {name = "Vespucci Police Dept.", x = -1095.3, y = -834.8, z = 36.8, ped = "S_M_Y_Cop_01", tier = 1},
    {name = "L.S.P.D Mission Row Helipad 1", x = 481.5, y = -982.2, z = 40.1, ped = "S_M_Y_Cop_01", tier = 2},
    {name = "L.S.P.D Mission Row Helipad 2", x = 448.9, y = -981.2, z = 42.7, ped = "S_M_Y_Cop_01", tier = 1},
    -- NOOSE 
    {name = "N.O.O.S.E Helipad 1", x = 2511.2, y = -426.5, z = 117.2, ped = "S_M_Y_Swat_01", tier = 3},
    {name = "N.O.O.S.E Helipad 2", x = 2510.5, y = -342.3, z = 117.2, ped = "S_M_Y_Swat_01", tier = 3},
    -- Hospitals
    {name = "Central L.S. Medical Center Helipad 1", x = 313.6, y = -1465.3, z = 45.5, ped = "S_M_M_Paramedic_01", tier = 1},
    {name = "Central L.S. Medical Center Helipad 2", x = 299.8, y = -1453.7, z = 45.5, ped = "S_M_M_Paramedic_01", tier = 2},
    {name = "Pillbox Hill Hospital", x = 351.7, y = -588.7, z = 73.2, ped = "S_M_M_Paramedic_01", tier = 1},
    -- Military
    {name = "Zancudo Helipad 1", x = -1877.2, y = 2805.1, z = 31.8, ped = "S_M_Y_MARINE_01", tier = 4},
    {name = "Zancudo Helipad 2", x = -1859.2, y = 2795.3, z = 31.8, ped = "S_M_Y_MARINE_01", tier = 4},
    --{name = "Merryweather Port", x = 478.5, y = -3369.8, z = 5.1},
    
    -- Non helipads
    {name = "Sandy Shores Airfield", x = 1770.4, y = 3239.4, z = 41.1, tier = 2},
    {name = "McKenzie Field Import/Export", x = 2139.4, y = 4812.8, z = 40.2, tier = 2},
    {name = "Humane Labs and Research", x = 3459.6, y = 3688.4, z = 31.7, tier = 3},
    {name = "Elysian Island", x = 351.4, y = -2533.3, z = 4.7, tier = 2},
    {name = "IAA Building", x = 143.9, y = -627.6, z = 261.8, ped = "S_M_M_CIASec_01", tier = 4},
    --{name = "FIB Building", x = 122.8, y = -743.4, z = 261.9, ped = "S_M_M_CIASec_01", tier = 4},
    {name = "Catfish View", x = 3805.1, y = 4462.1, z = 3.7, ped = "A_M_Y_Hiker_01", tier = 2},
    {name = "El Gordo Lighthouse", x = 3293.8, y = 5052.3, z = 22.0, ped = "A_M_Y_Hiker_01", tier = 2},
    {name = "Paleto Bay Peninsula", x = 58.2, y = 7213.6, z = 3.0, ped = "A_M_Y_Hiker_01", tier = 2},
    {name = "Little Seoul Tram Station", x = -554.4, y = -1351.1, z = 23.6, tier = 2},
    {name = "Mt. Chiliad Summit", x = 490.6, y = 5588.9, z = 793.6, ped = "A_M_Y_Hiker_01", tier = 2}, -- Thanks to 2D for the idea!!! boom boom
    {name = "Davis Quartz Quarry", x = 2942.3, y = 2798.4, z = 40.5, tier = 3},
    {name = "Xero Gas", x = -1014.6, y = -1927.8, z = 18.8, tier = 3},
    --{name = "Banning Gas Company", x = -417.4, y = -2212.1, z = 26.8, tier = 3},
    {name = "Richman College Track and Field", x = -1738.5, y = 161.1, z = 63.4, tier = 3},
}

-- Vehicles plus tiers
local job_vehicles = {
    {name = "FROGGER", tier = 1},
    {name = "FROGGER2", tier = 1},
    {name = "MAVERICK", tier = 1},
    {name = "BUZZARD2", tier = 1},
    {name = "SWIFT", tier = 2},
    {name = "SWIFT2", tier = 2},
    {name = "SUPERVOLITO", tier = 3},
    {name = "SUPERVOLITO2", tier = 3},
    {name = "VOLATUS", tier = 4},
    {name = "ANNIHILATOR", tier = 4},
    {name = "SKYLIFT", tier = 5},
    {name = "CARGOBOB2", tier = 5},
    {name = "BLIMP", tier = 5},
}

-- Localized names for peds
local ped_names = {
    ["default"] = "Passengers",
    ["A_M_Y_GenStreet_01"] = "Passengers",
    ["A_M_M_Business_01"] = "Business Men",
    ["S_M_Y_Cop_01"] = "Police Officers",
    ["S_M_M_Paramedic_01"] = "Paramedics",
    ["S_M_Y_MARINE_01"] = "Marines",
    ["S_M_Y_Swat_01"] = "SWAT Officers",
    ["A_M_Y_Hiker_01"] = "Hikers",
    ["S_M_M_CIASec_01"] = "IAA Officers",
}

-- Payment multiplier for ped
local ped_payment = {
    ["default"] = 1.0,
    ["A_M_Y_GenStreet_01"] = 1.0,
    ["A_M_M_Business_01"] = 1.5,
    ["S_M_Y_Cop_01"] = 1.2,
    ["S_M_M_Paramedic_01"] = 1.2,
    ["S_M_Y_MARINE_01"] = 1.2,
    ["S_M_Y_Swat_01"] = 1.5,
    ["A_M_Y_Hiker_01"] = 1.0,
    ["S_M_M_CIASec_01"] = 1.5,
}
----------------
-- CONFIG END --
----------------


RegisterNetEvent("gd_jobs_helicopter:startJob")
AddEventHandler("gd_jobs_helicopter:startJob",
    function(start, tier)
        startJob(start, tier)
    end
)

function drawMarker(x,y,z)
    DrawMarker(1, x, y, z, 0,0,0,0,0,0,10.0,10.0,2.0,0,155,255,200,0,0,0,0)
end

local current_job = {}

function setNewDestination(pos)
    if DoesBlipExist(current_job.blip) then RemoveBlip(current_job.blip) end
    current_job.blip = AddBlipForCoord(pos.x, pos.y, pos.z)
    setBlipName(current_job.blip, pos.name)
    SetBlipRoute(current_job.blip, true)
end

function setBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip) 
end

function getRandomLocation(tier)
    local loc = 0
    repeat
        loc = job_pickups[math.random(#job_pickups)]
    until loc.tier <= tier
    return loc
end

function startJob(start, tier)
    if isOnJob() then
        cancelJob()
    end
    current_job.previous = start
    current_job.destination = getRandomLocation(tier)
    current_job.marker = current_job.destination
    current_job.start = current_job.destination
    current_job.cargo = {name = ped_names[current_job.destination.ped] or ped_names["default"], pay = ped_payment[current_job.destination.ped] or ped_payment["default"]}
    current_job.type = "PICKUP"
    current_job.distance = 0
    current_job.length = 3 + tier * 2
    current_job.length_total = current_job.length
    current_job.tier = tier
    current_job.peds = {}

    setNewDestination(current_job.marker)
    drawMessage(string.format(pickupMessage, current_job.cargo.name, current_job.destination.name))

end

function createPedsThatEnterVehicle(number, _model)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local pos = GetEntityCoords(veh)
    local _i = 0
    local model = GetHashKey(_model)
    local peds = {}
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(1) end
    for _i = 1, number do
        if not DoesEntityExist(GetPedInVehicleSeat(veh, _i - 1)) then 
            local ped = CreatePed(4, model, pos.x + GetEntityForwardX(veh) * (6 + _i), pos.y + GetEntityForwardY(veh) * (6 + _i), pos.z, 0, true, 0)
            TaskEnterVehicle(ped, veh, 1000, _i - 1, 1.0, 3, 0)
            SetPedCanEvasiveDive(ped, false)
            table.insert(peds, ped)
        end
    end  
    return peds
end

function pickupJob()
    local op = current_job.previous
    local p = current_job.marker
    local dist = GetDistanceBetweenCoords(op.x, op.y, op.z, p.x, p.y, p.z)
    current_job.distance = current_job.distance + dist
    current_job.previous = current_job.marker
    current_job.length = current_job.length - 1
    
    if (current_job.type == "PICKUP") then
        -- make peds that enter vehicle
        local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        local peds = createPedsThatEnterVehicle(GetVehicleMaxNumberOfPassengers(veh), current_job.previous.ped or "A_M_Y_GenStreet_01")       
        for k,v in next, peds do
            table.insert(current_job.peds, v)
        end
    end
    
    TriggerServerEvent("gd_jobs_helicopter:pickupJob", dist, current_job.cargo.pay, current_job.tier)
    if (current_job.length > 0) then
        current_job.destination = getRandomLocation(current_job.tier)
        current_job.marker = current_job.destination
        current_job.type = "REACH"
        setNewDestination(current_job.marker)
        drawMessage(string.format(deliverMessage, current_job.destination.name, current_job.length_total - current_job.length, current_job.length_total - 1))
    else
        current_job.destination = current_job.start
        current_job.marker = current_job.destination
        current_job.type = "DELIVER"
        setNewDestination(current_job.marker)
        drawMessage(string.format(returnMessage, current_job.cargo.name, current_job.destination.name))
    end
end

function deliverJob()
    local op = current_job.previous
    local p = current_job.marker
    local dist = GetDistanceBetweenCoords(op.x, op.y, op.z, p.x, p.y, p.z)
    current_job.distance = current_job.distance + dist
    
    TriggerServerEvent("gd_jobs_helicopter:pickupJob", dist, current_job.cargo.pay, current_job.tier)    
    TriggerServerEvent("gd_jobs_helicopter:finishJob", current_job.distance, current_job.cargo.pay, current_job.tier)
    cancelJob()
end

function isOnJob()
    return (next(current_job) ~= nil)
end

function cancelJob()
    -- Remove all blips
    if type(current_job.blip) ~= nil then
        RemoveBlip(current_job.blip)
    end
    
    -- Make peds exit vehicle and fuck off
    if next(current_job.peds) ~= nil then
        for k,v in next, current_job.peds do
            if DoesEntityExist(v) then
                TaskLeaveAnyVehicle(v, 0, 0)
                SetTimeout(3000, function()
                    RemovePedElegantly(v) 
                end)
            end
        end
    end
    current_job = {}
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 500, true)
end

function drawMessage(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 20000, false)
end

function isInValidVehicle()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local validVehicle = false
    for k,v in next, job_vehicles do
        if GetEntityModel(veh) == GetHashKey(v.name) then validVehicle = true break end 
    end
    return validVehicle
end

function promptJob(location, tier)
    local validVehicle = isInValidVehicle()
    if validVehicle then
        drawText(string.format(startText, tier, location.name))         
        if isEPressed() then
            TriggerServerEvent("gd_jobs_helicopter:tryStartJob", location, tier) 
            return
        end
    else
        drawText(invalidVehicleText) 
    end
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 7 and zDist < 4) 
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function getCurrentTier()
    local tier = 0
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
    if veh then
        for k,v in next, job_vehicles do
             if GetEntityModel(veh) == GetHashKey(v.name) then tier = v.tier break end 
        end
    end
    return tier
end

Citizen.CreateThread(function()
    for k,v in next, job_blips do 
        local blip = AddBlipForCoord(v.x, v.y, 0) 
        SetBlipSprite(blip, 43)
        SetBlipColour(blip, 75)
        SetBlipAsShortRange(blip, true)
        setBlipName(blip, v.name)
    end
    while true do
        Citizen.Wait(1)
        if not isOnJob() then
            -- NOT ON JOB
            local p = GetEntityCoords(GetPlayerPed(-1))
            for k,v in next, job_starts do 
                drawMarker(v.x, v.y, v.z)    
                if nearMarker(v.x, v.y, v.z) then
                    promptJob(v, getCurrentTier())
                end
            end
        else
            -- ON JOB
            local marker = current_job.marker
            local p = GetEntityCoords(GetPlayerPed(-1))
            local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
            drawMarker(marker.x, marker.y, marker.z)
            
            if nearMarker(marker.x, marker.y, marker.z) and isInValidVehicle() and getCurrentTier() >= current_job.tier then
                if current_job.type == "PICKUP" then
                    if IsVehicleEngineOn(veh) and engineNeedsToBeOff then
                        drawText(string.format(engineRunningText))
                    else
                        drawText(string.format(pickupText, current_job.cargo.name, current_job.destination.name))
                        if isEPressed() then
                            pickupJob()
                        end
                    end
                elseif current_job.type == "REACH" then
                    drawText(string.format(deliverText, current_job.destination.name))
                    if isEPressed() then
                        pickupJob()
                    end
                elseif current_job.type == "DELIVER" then
                    if IsVehicleEngineOn(veh) and engineNeedsToBeOff then
                        drawText(string.format(engineRunningText))
                    else
                        drawText(string.format(returnText, current_job.cargo.name, current_job.destination.name))
                        if isEPressed() then
                            deliverJob()                            
                        end                        
                    end
                end
            end
        end
    end
end)
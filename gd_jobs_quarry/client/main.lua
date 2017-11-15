RegisterNetEvent("gd_jobs_quarry:startJob")
AddEventHandler("gd_jobs_quarry:startJob",
    function(a)
        startJob()
    end
)

function drawMarker(x,y,z)
    DrawMarker(1, x, y, z, 0,0,0,0,0,0,4.0,4.0,1.0,0,155,255,200,0,0,0,0)
end

local job_starts = {
    {name = "Quarry Gate Office", x = 2573.2, y = 2712.5, z = 41.4},
}

local job_pickups = {
    {name = "Quarry", x = 2950.0, y = 2748.0, z = 42.4},
    {name = "Quarry", x = 2952.8, y = 2735.2, z = 43.4},
    {name = "Quarry", x = 2828.5, y = 2804.0, z = 56.4},
    {name = "Quarry", x = 2771.1, y = 2806.0, z = 40.4},
    {name = "Quarry", x = 2589.7, y = 2814.8, z = 32.7},
    {name = "Quarry", x = 2657.8, y = 2779.0, z = 32.6},
    {name = "Quarry", x = 2686.2, y = 2764.8, z = 36.9},
    {name = "Quarry", x = 2682.4, y = 2802.8, z = 39.3},
    {name = "Quarry", x = 2661.2, y = 2895.7, z = 35.5},
}

local job_deliveries = {
    {name = "Recycling Center", x = 2403.0, y = 3106.1, z = 47.2},
    {name = "Redwood Lights Track", x = 1035.0, y = 2511.0, z = 46.0},
    {name = "R.L. Hunter & Sons", x = 1944.0, y = 4637.0, z = 39.5},
    {name = "McKenzie Field Import/Export", x = 2109.0, y = 4769.8, z = 40.2},
    {name = "Ron's Wind Farm", x = 2486.0, y = 1561.2, z = 31.7},
    {name = "Alta Construction Site", x = 136.1, y = -373.8, z = 42.2},
    {name = "Palomino Highlands Beach", x = 2777.5, y = -713.2, z = 4.8},
    {name = "Paleto Bay Construction Site", x = 47.7, y = 6532.0, z = 30.6},
    {name = "Sandy Shores Airfied", x = 1764.5, y = 3309.2, z = 40.1},
    {name = "Elysian Island Construction Site", x = 271.5, y = -2501.2, z = 5.4},
    {name = "M A M", x = 1070.5, y = -1962.2, z = 29.9},
    {name = "Elysian Island Docks", x = -516.5, y = -2756.2, z = 5.0},
}

local job_vehicles = {
    "BIFF",
    "RUBBLE",
    "TIPTRUCK",
    "TIPTRUCK2",
}

local job_cargoes = {
    {name = "Gravel", pay = 1.0},
    {name = "Sand", pay = 0.7},
    {name = "Rocks", pay = 1.2},
    {name = "Granite", pay = 1.5},
    {name = "Pebbles", pay = 1.0},
    {name = "Marble", pay = 2.0},
    {name = "Stone", pay = 1.2},
}

local startText = "Press ~g~E ~w~to start a ~g~Quarry Route~w~"
local pickupText = "Press ~g~E ~w~to pick up ~g~%s~w~"
local pickupMessage = "Pick up ~g~%s~w~"
local deliverText = "Press ~g~E ~w~to deliver ~g~%s ~w~to ~g~%s~w~"
local deliverMessage = "Deliver ~g~%s ~w~to ~g~%s~w~"
local invalidVehicleText = "You need a ~g~BIFF~w~, ~g~RUBBLE ~w~or ~g~TIPPING TRUCK ~w~to do this"

local current_job = {}
-- blip
-- pickup x y z
-- delivery name x y z
-- cargo

function setVehicleExtra(container, content) -- Contents in back of vehicle
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if container then
        SetVehicleExtra(veh, 1, 0)
    else
        SetVehicleExtra(veh, 1, 1)
    end
    
    if content then
        SetVehicleExtra(veh, 2, 0)
    else
        SetVehicleExtra(veh, 2, 1)
    end
end

function setNewDestination(pos)
    if DoesBlipExist(current_job.blip) then RemoveBlip(current_job.blip) end
    current_job.blip = AddBlipForCoord(pos.x, pos.y, pos.z )
    SetBlipRoute(current_job.blip, true)
end

function startJob()
    if isOnJob() then
        cancelJob()
    end
    
    setVehicleExtra(true, false)
    current_job.pickup = job_pickups[math.random(#job_pickups)]
    current_job.marker = current_job.pickup
    current_job.destination = job_deliveries[math.random(#job_deliveries)]
    current_job.cargo = job_cargoes[math.random(#job_cargoes)]
    current_job.type = "PICKUP"
    
    setNewDestination(current_job.marker)
    drawMessage(string.format(pickupMessage, current_job.cargo.name))

end

function pickupJob()
    setVehicleExtra(true, true)
    current_job.marker = current_job.destination
    current_job.type = "DELIVER"
    setNewDestination(current_job.marker)
    drawMessage(string.format(deliverMessage, current_job.cargo.name, current_job.destination.name))
end

function deliverJob()
    setVehicleExtra(false, false)    
    TriggerServerEvent("gd_jobs_quarry:finishJob", GetDistanceBetweenCoords(current_job.pickup.x, current_job.pickup.y, current_job.pickup.z, current_job.destination.x, current_job.destination.y, current_job.destination.z), current_job.cargo.pay)
    cancelJob()
end

function isOnJob()
    return (next(current_job) ~= nil)
end

function cancelJob()
    if type(current_job.blip) ~= nil then
        RemoveBlip(current_job.blip)
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
    Citizen.InvokeNative(0x9D77056A530643F6, 10000, false)
end

function isInValidVehicle()
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local validVehicle = false
    for k,v in next, job_vehicles do
        if GetEntityModel(veh) == GetHashKey(v) then validVehicle = true break end 
    end
    return validVehicle
end

function promptJob()
    local validVehicle = isInValidVehicle()
    if validVehicle then
        drawText(startText)         
        if isEPressed() then
            TriggerServerEvent("gd_jobs_quarry:tryStartJob") 
            return
        end
    else
        drawText(invalidVehicleText) 
    end
end

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 5) 
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

Citizen.CreateThread(function()
    for k,v in next, job_starts do 
        local blip = AddBlipForCoord(v.x, v.y, v.z) 
        SetBlipSprite(blip, 304)
        SetBlipColour(blip, 21)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Quarry")
        EndTextCommandSetBlipName(blip)
    end
    while true do
        Citizen.Wait(0)
        if not isOnJob() then
            -- NOT ON JOB
            local p = GetEntityCoords(GetPlayerPed(-1))
            for k,v in next, job_starts do 
                drawMarker(v.x, v.y, v.z)    
                if nearMarker(v.x, v.y, v.z) then
                    promptJob()
                end
            end
        else
            -- ON JOB
            local marker = current_job.marker
            local p = GetEntityCoords(GetPlayerPed(-1))
            drawMarker(marker.x, marker.y, marker.z)
            
            if nearMarker(marker.x, marker.y, marker.z) and isInValidVehicle() then
                if current_job.type == "PICKUP" then
                    drawText(string.format(pickupText, current_job.cargo.name))
                    if isEPressed() then
                        pickupJob()
                    end
                elseif current_job.type == "DELIVER" then
                    drawText(string.format(deliverText, current_job.cargo.name, current_job.destination.name))
                    if isEPressed() then
                        deliverJob()                            
                    end
                end
            end
        end
    end
end)
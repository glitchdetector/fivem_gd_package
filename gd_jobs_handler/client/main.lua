------------------
-- CONFIG START --
------------------

-- Messages
promptGoOnDuty = "Press ~g~E ~w~to ~g~start work ~w~as a ~y~Handler"
promptAttach = "Press ~g~E ~w~to ~y~attach ~w~the container"
promptDetach = "Press ~g~E ~w~to ~r~detach ~w~the container"
promptSpawnVehicle = "Press ~g~E ~w~to spawn a ~g~%s"

pickupCargoMessage = "Pick up the ~y~Container ~w~loaded with ~y~%s ~w~from ~y~%s"
relocateCargoMessage = "Re-locate the ~y~%s ~w~to the designated area ~y~%s"
deliverCargoMessage = "Load the ~y~%s ~w~on-to the transport waiting at ~y~%s"
droppedCargoMessage = "You've dropped and damaged the cargo"
lostCargoMessage = "The cargo has gone missing"

invalidVehicleText = "You need a ~g~HANDLER ~w~to do this"
alreadyHaveVehicleText = "You already have a vehicle out"
alreadyHaveContainerText = "You are already carrying a container"
alreadyOnDutyText = "You are already on duty"

-- Methods

-- Map Blips
job_blips = {
    {name = "Handler Office", x = 814.853699, y = -2982.555908, z = 5.020655, h = 89.604530},
}

container_locations = {
    {name = "Buccaneer Way", x = 1275.525024, y = -3241.565918, z = 4.901593, h = 181.968307},
    {name = "Buccaneer Way", x = 1247.424805, y = -3118.352539, z = 7.711722, h = 91.231804},
    {name = "Buccaneer Way", x = 1181.788696, y = -2997.124023, z = 7.711731, h = 356.491425},
    {name = "Buccaneer Way", x = 959.220032, y = -3101.983643, z = 7.711736, h = 1.658159},
    {name = "Buccaneer Way", x = 1056.174561, y = -3045.119385, z = 7.711731, h = 0.494190},
    {name = "Buccaneer Way", x = 1055.818237, y = -3048.531006, z = 4.901039, h = 176.562668},
    {name = "Buccaneer Way", x = 849.014221, y = -2994.323242, z = 4.900766, h = 359.759827},
    {name = "Buccaneer Way", x = 903.529358, y = -3019.882813, z = 7.711722, h = 180.399796},
    {name = "Buccaneer Way", x = 855.114319, y = -3074.441162, z = 7.686246, h = 176.415817},
    {name = "Buccaneer Way", x = 1005.960266, y = -3240.089844, z = 7.711722, h = 182.555481},
    {name = "Buccaneer Way", x = 835.223022, y = -2924.182861, z = 7.711722, h = 178.847717},
    {name = "Buccaneer Way", x = 872.742920, y = -3018.409424, z = 4.900762, h = 182.279907},
    {name = "Buccaneer Way", x = 1178.159058, y = -3115.132568, z = 5.028012, h = 266.052917},
    {name = "Buccaneer Way", x = 1178.249512, y = -3123.141113, z = 7.844794, h = 272.971069},
}

vehicle_location = {
    {name = "Handler", model = "HANDLER", x = 809.624695, y = -3038.202881, z = 4.742123, h = 178.457520},
}

delivery_locations = {
    -- {name = "Buccaneer Way", x = 957.399536, y = -3248.678955, z = 8.089097, h = 179.588242},
    -- {name = "Buccaneer Way", x = 1034.831421, y = -3248.533936, z = 8.093677, h = 177.612244},
    -- {name = "Buccaneer Way", x = 1273.775757, y = -3107.020264, z = 6.486442, h = 177.193726},
    -- {name = "Buccaneer Way", x = 865.434265, y = -2970.729492, z = 6.481098, h = 357.733124},
    -- {name = "Buccaneer Way", x = 1274.214844, y = -3165.242188, z = 6.528419, h = 2.131284},
    {name = "M 16", x = 953.238342, y = -3185.854492, z = 4.900803, h = 354.982040},
    {name = "M 04", x = 904.741516, y = -3186.008301, z = 4.897816, h = 0.032934},
    {name = "I 05", x = 909.055969, y = -3130.022461, z = 4.900803, h = 356.268768},
    {name = "P 16", x = 1050.251953, y = -3208.714600, z = 4.896801, h = 178.482513},
    {name = "P 04", x = 1001.490479, y = -3209.035889, z = 4.901496, h = 174.979141},
    {name = "O 10", x = 929.132874, y = -3210.211914, z = 4.900663, h = 176.289825},
    {name = "N 09", x = 1021.755859, y = -3183.300781, z = 4.900906, h = 358.934662},
    {name = "N 18", x = 1058.591064, y = -3184.711914, z = 4.901557, h = 357.888519},
    {name = "I 17", x = 957.072571, y = -3131.683838, z = 4.900802, h = 354.737244},
    {name = "K 16", x = 953.795349, y = -3153.900879, z = 4.900801, h = 177.376953},
    {name = "K 04", x = 904.295593, y = -3154.360352, z = 4.900803, h = 175.846771},
}

cargo_types = {
    {name = "Electronics", value = 0},
    {name = "Hardware", value = 0},
    {name = "Glass", value = 0},
    {name = "Pressurized Canisters", value = 0},
    {name = "Tools", value = 0},
    {name = "Mechanical Parts", value = 0},
    {name = "Textiles", value = 0},
    {name = "Merchandise", value = 0},
    {name = "Narcotics", value = 0},
    {name = "Figurines", value = 0},
    {name = "Jewlery", value = 0},
    {name = "Food Items", value = 0},
    {name = "Construction Materials", value = 0},
    {name = "Medical Equipment", value = 0},
    {name = "Video Games", value = 0},
}

craneName = "frame_2"
containers = {
    "prop_contr_03b_ld",
    -- "prop_container_01a",
    -- "prop_container_01b",
    -- "prop_container_01c",
    -- "prop_container_01d",
    -- "prop_container_01f",
    -- "prop_container_01g",
    -- "prop_container_01h",
}

STATE = "none"
ONDUTY = false

-- Blip Settings
job_blip_settings = {
    start_blip = {id = 527, color = 17},
    pickup_blip = {id = 537, color = 6},
    destination_blip = {id = 538, color = 6},
    vehicle_blip = {id = 529, color = 48},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
    spawner_blip = {id = 524, color = 17},
}

-- Job Start markers
job_starts = {
    {name = "Buccaneer Way", x = 814.853699, y = -2982.555908, z = 5.020655, h = 89.604530},
}

-- Vehicles plus tiers
job_vehicles = {
    {name = "HANDLER", tier = 1},
}
----------------
-- CONFIG END --
----------------

local debugMarkers = {}

function isInValidVehicle()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    if not veh then return false end
    local model = GetEntityModel(veh)
    for k,v in next, job_vehicles do
        if model == GetHashKey(v.name) then
            return true
        end
    end
    return false
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

function nearMarker(x, y, z)
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 7 and zDist < 4)
end

RegisterNetEvent("gd_jobs_handler:startJob")
AddEventHandler("gd_jobs_handler:startJob",
    function()
        startJob()
    end
)

RegisterNetEvent("stopjob")
AddEventHandler("stopjob", function()
    cancelJob()
end)

function isOnDuty()
    return ONDUTY == true
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function drawMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    DrawMarker(1, x, y, z, 0,0,0,0,0,0,5.0,5.0,2.0,marker.r,marker.g,marker.b,marker.a,0,0,0,0)
end

local current_job = {}

function setBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
end

--
function startJob()
    if not isOnDuty() then
        ONDUTY = true
        STATE = "idle"
        for k,v in next, vehicle_location do
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(blip, job_blip_settings.spawner_blip.id)
            SetBlipColour(blip, job_blip_settings.spawner_blip.color)
            SetBlipAsShortRange(blip, true)
            table.insert(current_job.blips, blip)
        end
    end
end

-- Does the requesting and the load wait in one handy function
function requestModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
end

-- Spawns a vehicle and puts the player in it
function spawnVehicle(model, x, y, z, h)
    requestModel(model)
    local veh = CreateVehicle(model, x, y, z, h, true, 0)
    SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
    return veh
end

function createMission()
    -- Get position for next container mission
    local location = container_locations[math.random(#container_locations)]
    -- Load the model
    local model = containers[math.random(#containers)]
    requestModel(model)
    -- Create the container at the location
    local container = CreateObject(model, location.x, location.y, location.z, true, 0, true)
    SetEntityHeading(container, location.h + 90.0)
    current_job.container = container
    -- Add a blip to the container
    local blip = AddBlipForEntity(container)
    SetBlipSprite(blip, job_blip_settings.pickup_blip.id)
    SetBlipColour(blip, job_blip_settings.pickup_blip.color)
    SetBlipRoute(blip, true)
    -- Store the data for the current job
    current_job.blip = blip
    current_job.pos = location
    -- Get a random cargo name (vanity)
    current_job.cargo = cargo_types[math.random(#cargo_types)]
    -- Set new state
    STATE = "pickup"
    -- Tell the player to pick up the spawned container
    drawMessage((pickupCargoMessage):format(current_job.cargo.name, location.name))
end

function generateLeavingTruck(location)
    requestModel("hauler")
    requestModel("trflat")
    requestModel("s_m_m_dockwork_01")
    local trailer = CreateVehicle("trflat", location.x, location.y, location.z, location.h, true, false)
    local cab = CreateVehicle("hauler", location.x + GetEntityForwardX(trailer) * 6.0, location.y + GetEntityForwardY(trailer) * 6.0, location.z, location.h, true, false)
    AttachVehicleToTrailer(cab, trailer, 10.0)
    local driver = CreatePedInsideVehicle(cab, 26, "s_m_m_dockwork_01", -1, true, false)
    current_job.truck_cab = cab
    current_job.truck_trailer = trailer
    current_job.truck_driver = driver
end

function clearJob()
    RemoveBlip(current_job.blip)
    SetEntityAsNoLongerNeeded(current_job.container)
    SetEntityAsNoLongerNeeded(current_job.truck_cab)
    SetEntityAsNoLongerNeeded(current_job.truck_trailer)
    SetEntityAsNoLongerNeeded(current_job.truck_driver)
    STATE = "idle"
end

function checkPickup()
    -- Check if container was removed (fucking gta being a cunt)
    if DoesEntityExist(current_job.container) then
        if isInValidVehicle() then
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsIn(ped, false)
            local bone = GetEntityBoneIndexByName(veh, craneName)
            local pos = GetWorldPositionOfEntityBone(veh, bone)
            -- Check if the handler is lined up with the container
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, current_job.pos.x, current_job.pos.y, current_job.pos.z, true) < 5.0 then
                drawText(promptAttach)
                if isEPressed() then
                    AttachEntityToEntity(current_job.container, veh, bone, 0, 1.78, -2.5, 0, 0, 90.0, false, false, true, false, 0, true)
                    current_job.pos = delivery_locations[math.random(#delivery_locations)]
                    STATE = "deliver"
                    RemoveBlip(current_job.blip)
                    local blip = AddBlipForCoord(current_job.pos.x, current_job.pos.y, current_job.pos.z)
                    SetBlipSprite(blip, job_blip_settings.destination_blip.id)
                    SetBlipColour(blip, job_blip_settings.destination_blip.color)
                    SetBlipRoute(blip, true)
                    current_job.blip = blip
                    drawMessage((deliverCargoMessage):format(current_job.cargo.name, current_job.pos.name))
                    generateLeavingTruck(current_job.pos)
                    return true
                end
            end
        else
            -- You need to be in a handler to do this
        end
        return false
    else
        clearJob()
        return false
    end
end

function checkDeliver()
    if DoesEntityExist(current_job.container) then
        if not IsEntityAttached(current_job.container) then
            drawMessage(droppedCargoMessage)
            clearJob()
        else
            if isInValidVehicle() then
                local ped = GetPlayerPed(-1)
                local veh = GetVehiclePedIsIn(ped, false)
                local bone = GetEntityBoneIndexByName(veh, craneName)
                local pos = GetWorldPositionOfEntityBone(veh, bone)
                if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, current_job.pos.x, current_job.pos.y, current_job.pos.z, true) < 5.0 then
                    drawText(promptDetach)
                    if isEPressed() then
                        DetachEntity(current_job.container, false, true)
                        AttachEntityToEntity(current_job.container, current_job.truck_trailer, 0, 0.0, 0.0, 0.35, 0.0, 0.0, 0.0, 0, false, true, false, 0, true)
                        TaskVehicleDriveWander(current_job.truck_driver, current_job.truck_cab, 40.0, 786468)
                        clearJob()
                        TriggerServerEvent("gd_jobs_handler:finishJob", 500)
                    end
                end
            else
                -- You need to be in a handler to do this
            end
        end
    else
        drawMessage(lostCargoMessage)
        clearJob()
    end
end

function checkVehicleSpawns()
    for k,v in next, vehicle_location do
        drawMarker(v.x, v.y, v.z, true)
        if nearMarker(v.x, v.y, v.z) then
            if current_job.vehicle ~= nil then
                drawText(alreadyHaveVehicleText)
            else
                drawText((promptSpawnVehicle):format(v.name))
                if isEPressed() then
                    local veh = spawnVehicle(v.model, v.x, v.y, v.z, v.h)
                    local blip = AddBlipForEntity(veh)
                    SetBlipSprite(blip, job_blip_settings.vehicle_blip.id)
                    SetBlipColour(blip, job_blip_settings.vehicle_blip.color)
                    current_job.vehicle = veh
                end
            end
        end
    end
end

-- Main loop
Citizen.CreateThread(function()
    current_job.blips = {}
    for k,v in next, job_blips do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, job_blip_settings.start_blip.id)
        SetBlipColour(blip, job_blip_settings.start_blip.color)
        setBlipName(blip, v.name)
        SetBlipAsShortRange(blip, true)
        table.insert(current_job.blips, blip)
    end
    while true do
        Wait(3)
        if not isOnDuty() then
            -- not on my boi
            for k,v in next, job_starts do
                drawMarker(v.x, v.y, v.z, false)
                if nearMarker(v.x, v.y, v.z) then
                    drawText(promptGoOnDuty)
                    if isEPressed() then
                        TriggerServerEvent("gd_jobs_handler:tryStartJob")
                    end
                end
            end
        else
            -- on duty
            for k,v in next, job_starts do
                drawMarker(v.x, v.y, v.z, true)
                if nearMarker(v.x, v.y, v.z) then
                    drawText(alreadyOnDutyText)
                end
            end
            checkVehicleSpawns()
            if STATE == "pickup" then
                -- Player has container to pick up
                drawMarker(current_job.pos.x, current_job.pos.y, current_job.pos.z, true)
                checkPickup()
            end
            if STATE == "deliver" then
                -- Player is carrying container
                drawMarker(current_job.pos.x, current_job.pos.y, current_job.pos.z, true)
                checkDeliver()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1*30*1000) -- 30 second timer
        if isOnDuty() and STATE == "idle" then
            createMission()
        end
        if current_job.vehicle ~= nil then
            if not DoesEntityExist(current_job.vehicle) then
                current_job.vehicle = nil
            end
        end
    end
end)

RegisterCommand("tppos", function(source, args, raw)
    args[1] = args[1] or 0
    args[2] = args[2] or 0
    args[3] = args[3] or 0
    SetEntityCoords(GetPlayerPed(-1), tonumber(args[1]) + 0.0, tonumber(args[2]) + 0.0, tonumber(args[3]) + 0.0, 0, 0, 0, 0)
end, false)

RegisterCommand("roadtrain", function(source, args, raw)
    requestModel("phantom3")
    requestModel("trailers2")
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    local fvx = GetEntityForwardX(ped)
    local fvy = GetEntityForwardY(ped)
    local h = GetEntityHeading(ped)
    local cab = spawnVehicle("phantom3", pos.x, pos.y, pos.z, h)
    local dist = 14.0
    local trailer = CreateVehicle("trailers2", pos.x - fvx * dist, pos.y - fvy * dist, pos.z, h, true, 0)
    SetEntityInvincible(newTrailer, true)
    AttachVehicleToTrailer(cab, trailer, 10.0)
    for i=2,5 do
        local newTrailer = CreateVehicle("trailers2", pos.x - fvx * (dist*i), pos.y - fvy * (dist*i), pos.z, h, true, 0)
        local rope = AddRope(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, --[[<- pos & rot]] 10.0, 4, 10.0, 1.0, 0, false, false, true, 0, false, 0)
        AttachEntitiesToRope(rope, newTrailer, trailer, 0.0, 7.0, 1.0, 0.0, -7.0, 1.0, 1.0, true, true)
        SetEntityInvincible(newTrailer, true)
        --AttachEntityToEntityPhysically(newTrailer, trailer, 0, 0, 0.0, 2.5, 0.0, 0.0, -2.5, 0.0, 0.0, 0.0, 0.0, 90000.0, false, 0, false, 1, 2)
        --AttachEntityToEntityPhysically(newTrailer, trailer, 0, 0, 0.0, 0.0, 2.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 90000.0, false, 0, false, 1, 2)
        --AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
        --AttachEntityToEntity(newTrailer, trailer, 0, 0.0, -dist, 0.0, 0.0, 0.0, 0.0, 0, false, false, false, 0, true)
        trailer = newTrailer
    end
end, false)

RegisterCommand("aif", function(source, args, raw)
    local model = (args[1] or "")
    local xo = (args[2] or 0.0) + 0.0
    local yo = (args[3] or 0.0) + 0.0
    local zo = (args[4] or 0.0) + 0.0
    local xr = (args[5] or 0.0) + 0.0
    local yr = (args[6] or 0.0) + 0.0
    local zr = (args[7] or 0.0) + 0.0
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    requestModel(model)
    local obj = CreateObject(model, 0.0, 0.0, 0.0, true, 0, true)
    SetEntityVisible(veh, false, 2)
    AttachEntityToEntity(obj, veh, 0, xo, yo, zo, xr, yr, zr, 0, false, true, false, 0, true)
    propify_data[veh] = obj
end, false)

local propify_data = {}
RegisterCommand("propify", function(source, args, raw)
    local model = (args[1] or "")
    local xo = (args[2] or 0.0) + 0.0
    local yo = (args[3] or 0.0) + 0.0
    local zo = (args[4] or 0.0) + 0.0
    local xr = (args[5] or 0.0) + 0.0
    local yr = (args[6] or 0.0) + 0.0
    local zr = (args[7] or 0.0) + 0.0
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    requestModel(model)
    local obj = CreateObject(model, 0.0, 0.0, 0.0, true, 0, true)
    SetEntityVisible(veh, false, 2)
    AttachEntityToEntity(obj, veh, 0, xo, yo, zo, xr, yr, zr, 0, false, true, false, 0, true)
    propify_data[veh] = {obj}
end, false)

CreateThread(function()
    while true do
        Wait(5)
        for k,v in next, propify_data do
            if not DoesEntityExist(k) then
                DeleteEntity(v)
                propify_data[k] = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, true)

        if DoesEntityExist(ped) and IsPedInAnyVehicle(ped, false) and IsControlPressed(2, 75) and not IsEntityDead(ped) and not IsPauseMenuActive() then
            local engineWasRunning = GetIsVehicleEngineRunning(veh)
            for i=1,10 do
                Citizen.Wait(200)
                if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) and not IsEntityDead(ped) and not IsPauseMenuActive() then
                    if (engineWasRunning) then
                        SetVehicleEngineOn(veh, true, true, true)
                    end
                end
                    -- body...
            end
        end
    end
end)

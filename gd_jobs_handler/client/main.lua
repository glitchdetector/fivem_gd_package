------------------
-- CONFIG START --
------------------

-- Messages
startText = "Press ~g~E ~w~to start a ~g~Bus Route ~w~from ~g~%s~w~"
startTextSpecial = "Press ~g~E ~w~to start an ~g~Express Route ~w~from ~g~%s~w~"
pickupText = "Press ~g~E ~w~to pick up ~g~%s ~w~from ~g~%s~w~"

promptGoOnDuty = "Press ~g~E ~w~to ~g~start work ~w~as a ~y~Handler"
promptAttach = "Press ~g~E ~w~to ~y~attach ~w~the container"
promptDetach = "Press ~g~E ~w~to ~r~detach ~w~the container"
promptSpawnVehicle = "Press ~g~E ~w~to spawn a ~g~%s"

pickupCargoMessage = "Pick up the ~y~Container ~w~loaded with ~y~%s"

invalidVehicleText = "You need a ~g~HANDLER ~w~to do this"
alreadyHaveVehicleText = "You already have a vehicle out"
alreadyHaveContainerText = "You are already carrying a container"


xOutOfY = "~w~[~y~%i~w~/~y~%i~w~]"

vehicleFullMessage = "Your vehicle is ~r~FULL~w~"
capacityMessage = "Current ~g~%s " .. xOutOfY
continueMessage = "Continue ~g~%s ~w~route " .. xOutOfY

startRouteMessage = "Complete the ~g~%s ~w~route"
jobDoneMessage = "Finished ~g~%s ~w~route"

-- Methods
engineNeedsToBeOff = true

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
    {name = "Buccaneer Way", x = 957.399536, y = -3248.678955, z = 8.089097, h = 179.588242},
    {name = "Buccaneer Way", x = 1034.831421, y = -3248.533936, z = 8.093677, h = 177.612244},
    {name = "Buccaneer Way", x = 1273.775757, y = -3107.020264, z = 6.486442, h = 177.193726},
    {name = "Buccaneer Way", x = 865.434265, y = -2970.729492, z = 6.481098, h = 357.733124},
    {name = "Buccaneer Way", x = 1274.214844, y = -3165.242188, z = 6.528419, h = 2.131284},
}

cargo_types = {
    {name = "Electronics", value = 0},
    {name = "Hardware", value = 0},
    {name = "Glass", value = 0},
    {name = "High Pressure Gasses", value = 0},
    {name = "Tools", value = 0},
}

craneName = "frame_2"
containers = {
    "prop_contr_03b_ld",
}

STATE = "none"
ONDUTY = false

-- Blip Settings
job_blip_settings = {
    start_blip = {id = 527, color = 17},
    pickup_blip = {id = 537, color = 6},
    destination_blip = {id = 538, color = 6},
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

function startJob()
    ONDUTY = true
    STATE = "idle"
end

function createMission()
    -- Get position for next container mission
    local location = container_locations[math.random(#container_locations)]
    -- Load the model
    local model = containers[math.random(#containers)]
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    -- Create the container at the location
    local container = CreateObject(model, location.x, location.y, location.z, true, 0, true)
    SetEntityHeading(container, location.h + 90.0)
    current_job.container = container
    -- Add a blip to the container
    local blip = AddBlipForEntity(container)
    current_job.blip = blip
    current_job.pos = location
    STATE = "pickup"
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
                drawText("Press E to hook up container")
                if isEPressed() then
                    AttachEntityToEntity(current_job.container, veh, bone, 0, 1.78, -2.5, 0, 0, 90.0, false, false, true, false, 0, true)
                    current_job.pos = delivery_locations[math.random(#delivery_locations)]
                    STATE = "deliver"
                    RemoveBlip(current_job.blip)
                    local blip = AddBlipForCoord(current_job.pos.x, current_job.pos.y, current_job.pos.z)
                    current_job.blip = blip
                    return true
                end
            end
        else
            -- You need to be in a handler to do this
        end
        return false
    else
        STATE = "idle"
        return false
    end
end

function checkDeliver()
    if DoesEntityExist(current_job.container) then
        if isInValidVehicle() then
            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsIn(ped, false)
            local bone = GetEntityBoneIndexByName(veh, craneName)
            local pos = GetWorldPositionOfEntityBone(veh, bone)
            if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, current_job.pos.x, current_job.pos.y, current_job.pos.z, true) < 5.0 then
                drawText("Press E to unload container")
                if isEPressed() then
                    DetachEntity(current_job.container, false, true)
                    SetEntityAsNoLongerNeeded(current_job.container)
                    STATE = "idle"
                    RemoveBlip(current_job.blip)
                end
            end
        else
            -- You need to be in a handler to do this
        end
    else
        STATE = "idle"
    end
end

-- Main loop
Citizen.CreateThread(function()
    while true do
        Wait(3)
        if not isOnDuty() then
            -- not on my boi
            for k,v in next, job_starts do
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
                if nearMarker(v.x, v.y, v.z) then
                    drawText("You are already on duty")
                end
            end
            if STATE == "pickup" then
                checkPickup()
            end
            if STATE == "deliver" then
                checkDeliver()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1*60*1000) -- One minute timer
        if isOnDuty() and STATE == "idle" then
            createMission()
        end
    end
end)

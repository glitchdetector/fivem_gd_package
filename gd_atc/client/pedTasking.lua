local blipLocs = {
    {name = "Union Depository Dropoff", x = -7.328112, y = -655.921082, z = 32.451847, blipid = 500, blipcol = 5},
    {name = "Blaine County Fleeca Bank", x = 1177.095459, y = 2711.752441, z = 37.097763, blipid = 500, blipcol = 2},
    {name = "Alta Fleeca Bank", x = 309.974792, y = -282.962646, z = 53.174511, blipid = 500, blipcol = 2},
    {name = "Big Bank Place", x = 256.424622, y = 225.909988, z = 100.875717, blipid = 500, blipcol = 2},
    {name = "Rockford Hills Fleeca Bank", x = -1212.107422, y = -335.944550, z = 36.790771, blipid = 500, blipcol = 2},
    {name = "Legion Square Fleeca Bank", x = 145.850647, y = -1044.619751, z = 28.377804, blipid = 500, blipcol = 2},
    {name = "Banham Canyon Fleeca Bank", x = -2957.513184, y = 480.322998, z = 14.706840, blipid = 500, blipcol = 2},
    {name = "Paleto Bay Savings Bank", x = -105.192596, y = 6476.201172, z = 30.626711, blipid = 500, blipcol = 2}
}

function setBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip) 
end

local inveh = false
local blips = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local newInveh = GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1), true)) == GetHashKey("STOCKADE") or IsControlPressed(1, 29)
        if not inveh and newInveh then
            for k,v in next, blipLocs do
                local blip = AddBlipForCoord(v.x, v.y, v.z)
                SetBlipSprite(blip, v.blipid)
                SetBlipColour(blip, v.blipcol)
                SetBlipAsShortRange(blip, true)
                setBlipName(blip, v.name)
                table.insert(blips, blip)
            end
        end
        if inveh and not newInveh then
            for k,v in next, blips do
                RemoveBlip(v)
            end
            blips = {}
        end
        inveh = newInveh
    end
end)

function reqModel(model) 
    model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(5) end
    return model
end

function createVehicleThatFollowsVehicle(vehicleModel, vehicleToFollow, driverModel, x, y, z, heading, method, distance)
    local vehModel = reqModel(vehicleModel)
    local pedModel = reqModel(driverModel)

    local veh = CreateVehicle(vehModel, x, y, z, heading, true, false)
    local ped = CreatePedInsideVehicle(veh, 4, pedModel, -1, true, false)
    TaskVehicleEscort(ped, veh, vehicleToFollow, method or -1, 30.0, 786469, distance or 2.0, 0, 100.0)    
    return veh, ped
end

function fillVehicleWithPeds(veh, pedsModel)
    local pedModel = reqModel(pedsModel)
    for i=1, GetVehicleMaxNumberOfPassengers(veh) do
        CreatePedInsideVehicle(veh, 4, pedModel, i, true, false)
    end
end

function takeOwnershipOfPedAndVehicle(ped, vehicle)
    local pedModel = GetEntityModel(ped)
    local vehModel = GetEntityModel(veh)
    local vehPos = GetEntityCoords(veh)
    local vehHeading = GetEntityHeading(veh)
    
    DeleteEntity(veh)
    DeleteEntity(ped)
    local _v = CreateVehicle(vehModel, vehPos.x, vehPos.y, vehPos.z, vehHeading, true, false)
    local _p = CreatePedInsideVehicle(_v, 4, pedModel, -1, true, false)
    
    return _p, _v
end

local job_start = {name = "Lombank West", x = -1568.092407, y = -530.758057, z = 34.291264}
local job_end = {name = "The Oriental", x = 293.157623, y = 177.280731, z = 102.901276}
local job = {}

local job_spawn = {
    {name = "stretch", model = "ig_bankman", x = -1556.032837, y = -547.315674, z = 30.004879, h = 25.0, cb = function(v, p) SetBlipColour(AddBlipForEntity(v), 2) job.veh = v job.ped = p end},
    {name = "police3", model = "s_m_y_cop_01", x = -1559.464600, y = -550.922546, z = 28.676392, h = 25.0, cb = function(v, p) SetVehicleSiren(v, true) AddBlipForEntity(v) job.pd = v job.pdped = p end}
}
 
function drawMarker(x,y,z)
    DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 1.0, 150, 150, 0, 200, false, false, 0, false)
end

function startJob()
    job.active = true
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)
    AddBlipForEntity(veh)
    for k,v in next, job_spawn do
        veh, ped = createVehicleThatFollowsVehicle(v.name, veh, v.model, v.x, v.y, v.z, v.h)
        v.cb(veh, ped)
    end
end


Citizen.CreateThread(function()
        
    while true do
        local ply = GetPlayerPed(-1)
        local pos = GetEntityCoords(ply)
        if next(job) ~= nil then
            -- On job
            drawMarker(job_end.x, job_end.y, job_end.z)
        else
            -- Not on job
            drawMarker(job_start.x, job_start.y, job_start.z)
            if GetDistanceBetweenCoords(job_start.x, job_start.y, job_start.z, pos.x, pos.y, pos.z) < 5 then
                if IsControlJustPressed(1, 38) then
                    startJob()     
                end
            end
        end
        Wait(1)
    end
    
    
    
--    local desti = {name = "r", x = 1012.028992, y = 289.083405, z = 81.888252}
--
--    local veh, ped = createVehicleThatFollowsVehicle("police3", nil, "s_m_y_cop_01", -1054.027710, -889.096558, 3.801936, -45.0)
--    local veh2, ped2 = createVehicleThatFollowsVehicle("stockade", veh, "s_m_y_cop_01", -1067.088623, -896.252136 + 5.0, 3.392769, -45.0)
--    local veh3, ped3 = createVehicleThatFollowsVehicle("stockade", veh2, "s_m_y_cop_01", -1067.088623, -896.252136, 3.392769, -45.0)
--    local veh4, ped4 = createVehicleThatFollowsVehicle("stockade", veh3, "s_m_y_cop_01", -1067.088623, -896.252136 - 5.0, 3.392769, -45.0)
--    local veh5, ped5 = createVehicleThatFollowsVehicle("riot", veh4, "s_m_y_cop_01", -1079.150513, -903.233887, 2.889246, -45.0)
--        
--    SetBlipSprite(AddBlipForEntity(veh),58)
--        
--    fillVehicleWithPeds(veh, "s_m_y_cop_01")
--    fillVehicleWithPeds(veh5, "s_m_y_swat_01")
--    SetVehicleSiren(veh, true)
--    SetVehicleSiren(veh5, true)
--
--    TaskVehicleDriveWander(ped, veh, 5.0, 786469)
--    local desti = {name = "r", x = 1012.028992, y = 289.083405, z = 81.888252}
--
--    local veh, ped = createVehicleThatFollowsVehicle("adder", nil, "s_m_y_cop_01", -1054.027710, -889.096558, 3.801936, -45.0)
--    for i = 1,20 do
--        local _v, _p = createVehicleThatFollowsVehicle("police3", veh, "s_m_y_cop_01", -1067.088623 - 5*i, -896.252136 - 2*i, 3.392769, -45.0)
--        SetVehicleSiren(_v, true)
--        SetBlipSprite(AddBlipForEntity(_v),42)
--    end
--    SetPedIntoVehicle(GetPlayerPed(-1), veh, 0)    
--    
--    SetBlipSprite(AddBlipForEntity(veh),58)
--        
--    SetVehicleSiren(veh3, true)
--    SetVehicleSiren(veh4, true)
--    SetVehicleSiren(veh5, true)
--
--    TaskVehicleDriveWander(ped, veh, 1000.0, 786468)
end)
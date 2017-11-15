--[[-- Airport markers (not used yet)
 
local airport_markers = {
    {name = "5 5", x = 1406.908936, y = 3003.808350, z = 38.544079, r = 314.383423, n = 5},
    {name = "23 2", x = 1603.168945, y = 3199.204102, z = 38.531578, r = 134.886429, n = 2},
    {name = "23 3", x = 1598.163696, y = 3204.678711, z = 38.519970, r = 136.494797, n = 3},
    {name = "26R R", x = 1594.006226, y = 3221.034180, z = 38.411541, r = 103.092644, n = "R"},
    {name = "26R 2", x = 1583.532715, y = 3216.209717, z = 38.411541, r = 106.232895, n = 2},
    {name = "26R 6", x = 1582.044800, y = 3222.496582, z = 38.411549, r = 102.798386, n = 6},
    {name = "26L L", x = 1506.382568, y = 3129.632080, z = 38.531586, r = 106.483917, n = "L"},
    {name = "26L 2", x = 1498.078857, y = 3123.284668, z = 38.532436, r = 108.919846, n = 2},
    {name = "26L 6", x = 1496.229736, y = 3129.478027, z = 38.533821, r = 107.001823, n = 6},
    {name = "8R R", x = 1106.666138, y = 3021.209473, z = 38.534153, r = 283.115082, n = "R"},
    {name = "8R 8", x = 1118.515137, y = 3024.298096, z = 38.534153, r = 284.661377, n = 8},
    {name = "8L L", x = 1088.800659, y = 3084.799561, z = 38.414089, r = 282.540588, n = "L"},
    {name = "8L 8", x = 1100.324707, y = 3087.793457, z = 38.414089, r = 282.934448, n = 8},
}

function drawMarkerCustom(x,y,z,_rot,no)
    local rot = _rot or 0.0
    --DrawMarker(1, x, y, z, 0,0,0,0,0,0,10.0,10.0,2.0,0,155,255,200,0,0,0,0)
    if type(no) ~= "string" then
        DrawMarker(10 + no, x, y, z, 0.0, 0.0, 1.0, 0.0, -rot, 0.0, 7.0, 1.0, 7.0, 255, 255, 255, 255, 0, 0, 0, 0)
    else
        if no == "L" then
            --DrawMarker(10 + 0, x, y, z, 0.0, 0.0, 1.0, 0.0, -rot, 0.0, 7.0, 1.0, 7.0, 255, 255, 255, 255, 0, 0, 0, 0)
        end 
        if no == "R" then
            --DrawMarker(10 + 1, x, y, z, 0.0, 0.0, 1.0, 0.0, -rot, 0.0, 7.0, 1.0, 7.0, 255, 255, 255, 255, 0, 0, 0, 0)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)    
        for k,v in next, airport_markers do
            drawMarkerCustom(v.x, v.y, v.z + 1.5, v.r, v.n)     
        end
    end
end)

-----------sdasdasdsad

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
        
        
    local new = false
    local handle, veh = FindFirstVehicle()
    repeat
        DeleteVehicle(veh)
        new, veh = FindNextVehicle(handle)
    until not new
        
    veh = nil
    local ped = nil
    local fv = nil
    local fp = nil
    local s = {name = "tt", x = -2197.320801, y = 2956.779053, z = 31.810341}
    for i = 0, 10 do
        veh, ped = createVehicleThatFollowsVehicle("hauler2", veh, "ig_bankman", s.x + 10.0 * i, s.y, s.z, 0.0)
        local veh2, ped2 = createVehicleThatFollowsVehicle("trailerlarge", nil, "ig_bankman", s.x + 10.0 * i, s.y + 15.0, s.z, 0.0)
        AttachVehicleToTrailer(veh, veh2, 20.0)
        if fv == nil then fv = veh end
        if fp == nil then fp = ped end
    end
    TaskVehicleDriveWander(fp, fv, 100.0, 786469)
        

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
end)]]
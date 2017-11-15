
Citizen.CreateThread(function()
    print("gd_trafficlights/client/main.lua init")
--    while true do
--        Citizen.Wait(5)  
--    end
end)

local models = {
    ["prop_traffic_01a"] = 5,
    ["prop_traffic_01b"] = 10,
    ["prop_traffic_01d"] = 10,
    ["prop_traffic_02a"] = 5,
    ["prop_traffic_02b"] = 10,
    ["prop_traffic_03a"] = 5,
}

local pedindex = {}
local ls = 3
local lsmax = 500
    
Citizen.CreateThread(function()
    while true do
        Wait(500)
        pedindex = {}
        PopulatePedIndex()
--        ls = ls + 1
--        if ls > lsmax then ls = 0 end
--                print(ls)
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(5)
        for k,v in next, pedindex do
            local pos = GetEntityCoords(k)
                --SetEntityHeading(k, GetEntityHeading(k) + 1.0)
            DrawLine(pos.x, pos.y, pos.z + 2.0, pos.x - GetEntityForwardY(k) * v, pos.y + GetEntityForwardX(k) * v, pos.z + 2.0, 255, 0, 0, 255)
        --void DRAW_LINE(float x1, float y1, float z1, float x2, float y2, float z2, int red, int green, int blue, int alpha)
        end
    end
end)



function PopulatePedIndex()
    local handle, ped = FindFirstObject()
    local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
    repeat
        for k,v in next, models do
            if GetEntityModel(ped) == GetHashKey(k) then
                pedindex[ped] = v
            end
        end
        finished, ped = FindNextObject(handle) -- first param returns true while entities are found
    until not finished
    EndFindObject(handle)
end
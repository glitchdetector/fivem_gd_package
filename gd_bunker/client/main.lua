local bunkerName = "The Bunker"
local enterBunkerText = "Press ~g~E ~w~to enter ~g~%s ~w~from ~g~%s"
local exitBunkerText = "Press ~g~E ~w~to exit to ~g~%s"
local spawnVehicleText = "Press ~g~E ~w~to spawn a ~g~%s"

local teleportBlock = false
local vehicleBlock = false

local bunkerTeleportPoints = {
    {
        name = "Zancudo",
        from = {x = -2051.314697, y = 3237.110596, z = 30.501234},
        to = {x = 902.784058, y = -3182.513916, z = -98.054276}
    },
    {
        name = "Paleto Bay",
        from = {x = -83.324051, y = 6239.627441, z = 30.090574},
        to = {x = 921.602051, y = -3194.250977, z = -99.262421},
    },
    {
        name = "Union Depository",
        from = {x = 10.445343, y = -671.406250, z = 32.449543},
        to = {x = 857.028198, y = -3249.832764, z = -99.340828},
    },
    {
        name = "Sandy Shores",
        from = {x = 492.929291, y = 3014.827881, z = 40.017887},
        to = {x = 893.823608, y = -3245.822266, z = -99.261101},
    }
}
local bunkerVehicleSpawners = {
    {name = "Caddy", vehicle = "caddy3", x = 883.091309, y = -3240.131592, z = -99.278366}
}

--{name = "Ramp Exit", x = 893.823608, y = -3245.822266, z = -99.261101},
--{name = "Zancudo Bunker Enterance", x = -2051.314697, y = 3237.110596, z = 30.501234},
--{name = "Paleto Bay Bunker Enterance", x = -83.324051, y = 6239.627441, z = 30.090574},
--{name = "Union Bank Bunker Enterance", x = 10.445343, y = -671.406250, z = 32.449543},
--{name = "Bunker Union Bank Exit", x = 857.028198, y = -3249.832764, z = -99.340828},
--{name = "Bunker Zancudo Exit", x = 902.784058, y = -3182.513916, z = -98.054276},
--{name = "Bunker Paleto Bay Exit", x = 921.602051, y = -3194.250977, z = -99.262421},
--{name = "Caddy3 Spawnpoint", x = 883.091309, y = -3240.131592, z = -99.278366},

function drawMarker(data)
    DrawMarker(1, data.x, data.y, data.z, 0,0,0,0,0,0,1.0,1.0,1.0, 255,255,255,150, 0,0,0,0)
end

function isInMarker(data)
    local x = data.x
    local y = data.y
    local z = data.z
    local p = GetEntityCoords(GetPlayerPed(-1))
    local zDist = math.abs(z - p.z)
    return (GetDistanceBetweenCoords(x, y, z, p.x, p.y, p.z) < 3 and zDist < 2)
end

function isEPressed()
    return IsControlJustPressed(0, 38)
end

function promptTeleport(data, name, entry)
    if teleportBlock then return end
    if entry > 0 then
        drawText(string.format(enterBunkerText, bunkerName, name))
    else
        drawText(string.format(exitBunkerText, name))
    end

    if isEPressed() then
        teleportBlock = true
        SetTimeout(2000, function()
            teleportBlock = false
        end)
        SetEntityCoords(GetPlayerPed(-1), data.x, data.y, data.z + 0.5, 0, 0, 0, 0)
    end
end

function promptSpawn(data, vehicle)
    if vehicleBlock then return end
    drawText(string.format(spawnVehicleText, data.name))
    if isEPressed() then
        vehicleBlock = true
        RequestModel(GetHashKey(vehicle))
        while not HasModelLoaded(GetHashKey(vehicle)) do Citizen.Wait(5) end
        local veh = CreateVehicle(GetHashKey(vehicle), data.x, data.y, data.z, 0.0, true, 0)
        SetPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        SetTimeout(2 * 60 * 1000, function()
            vehicleBlock = false
            if DoesEntityExist(veh) then DeleteEntity(veh) end
        end)
    end
end

function EnableInteriorProp(interior, prop)
    return Citizen.InvokeNative(0x55E86AF2712B36A1, interior, prop)
end

function drawText(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 100, true)
end

local vehIndex = {}

function PopulateVehicleIndex()
    local handle, veh = FindFirstVehicle()
    local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
    repeat
        if DoesEntityExist(veh) then
            vehIndex[veh] = {}
			Citizen.Trace("Vehicle: " .. veh)
			SetVehicleCustomPrimaryColour(veh, 255, 255, 0)
        end
        finished, veh = FindNextVehicle(handle) -- first param returns true while entities are found
    until not finished
    EndFindVehicle(handle)
end

Citizen.CreateThread(
    function()

		PopulateVehicleIndex()

        -- Bunkers - Exteriors
        RequestIpl("gr_case9_bunkerclosed")

        -- Bunkers - Interior: 892.6384, -3245.8664, -98.2645
        RequestIpl("gr_entrance_placement")
        RequestIpl("grdlc_int_01_shell")
        RequestIpl("gr_grdlc_int_01")
        RequestIpl("gr_grdlc_int_02")
        RequestIpl("gr_grdlc_interior_placement")
        RequestIpl("gr_grdlc_interior_placement_interior_0_grdlc_int_01_milo_")
        RequestIpl("gr_grdlc_interior_placement_interior_1_grdlc_int_02_milo_")

        RequestIpl("imp_impexp_interior_placement")
        RequestIpl("imp_impexp_interior_01")
        RequestIpl("imp_impexp_interior_02")
        RequestIpl("imp_impexp_intwaremed")
        RequestIpl("imp_impexp_mod_int_01")
        RequestIpl("imp_impexp_interior_placement_interior_0_impexp_int_01_milo_")
        RequestIpl("imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_")
        RequestIpl("imp_impexp_interior_placement_interior_2_impexp_mod_int_01_milo_")
        RequestIpl("imp_impexp_interior_placement_interior_3_impexp_int_02_milo_")

        RequestIpl("sm_smugdlc_interior_placement")
        RequestIpl("sm_smugdlc_interior_placement_interior_0_smugdlc_int_01_milo_")
        RequestIpl("sm_smugdlc_int_01")

        RequestIpl("gr_grdlc_yatch_placement")
        RequestIpl("gr_heist_yatch2")
        RequestIpl("gr_heist_yatch2_bar")
        RequestIpl("gr_heist_yatch2_bedrm")
        RequestIpl("gr_heist_yatch2_bridge")
        RequestIpl("gr_heist_yatch2_enginrm")
        RequestIpl("gra_heist_yatch2_lounge")

        local pos = GetEntityCoords(GetPlayerPed(-1))
        local interior = GetInteriorAtCoords(pos.x, pos.y, pos.z)
        --interior = 81897539
        Citizen.InvokeNative(0x2CA429C029CCF247, interior)
        Citizen.Trace("ID:" .. interior)
        Citizen.Trace("Ready:" .. tostring(IsInteriorReady(interior)))
        Citizen.Trace("Disabled:" .. tostring(IsInteriorDisabled(interior)))
        Citizen.Trace("Valid:" .. tostring(IsValidInterior(interior)))
        local pos = GetOffsetFromInteriorInWorldCoords(interior, 0.0, 0.0, 0.0)
        Citizen.Trace("Pos: " .. pos.x .. ", " .. pos.y .. ", " .. pos.y .. " ")


        Citizen.Trace("yatch")

        EnableInteriorProp(258561,"standard_bunker_set")
        EnableInteriorProp(258561,"Bunker_Style_C")
        EnableInteriorProp(258561,"Office_Upgrade_set")
        EnableInteriorProp(258561,"Gun_schematic_set")
        EnableInteriorProp(258561,"security_upgrade")
        EnableInteriorProp(258561,"gun_range_lights")
        EnableInteriorProp(258561,"gun_locker_upgrade")
        RefreshInterior(258561)

        EnableInteriorProp(252673,"car_floor_hatch")
        EnableInteriorProp(252673,"branded_style_set")
        RefreshInterior(252673)

        --[[local i = 0
        local j = 0
        local n = 0
        for j = 0, 53 do
            for i = 0, 10 do
                local blip = AddBlipForCoord(-4000.0 + i * 128, -2000.0 + j * 128, 0)
                SetBlipSprite(blip, 0 + n)
                n = n + 1
            end
        end]]

        while true do
            Citizen.Wait(1)
            for k,v in next, bunkerTeleportPoints do
                drawMarker(v.from)
                drawMarker(v.to)
                if isInMarker(v.from) then
                    promptTeleport(v.to, v.name, 1)
                end
                if isInMarker(v.to) then
                    promptTeleport(v.from, v.name, 0)
                end
            end
            for k,v in next, bunkerVehicleSpawners do
                drawMarker(v)
                if isInMarker(v) then
                    promptSpawn(v, v.vehicle)
                end
            end
        end
    end
)

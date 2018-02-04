local infractions = {}

local ENABLED = false
print("Is she enabled? " .. (ENABLED and "Yes") or "No")

local blacklist = {
    vehicles = {
        "RHINO",
        "HYDRA",
        "LAZER",
    },
    weapons = {
        "GADGET_NIGHTVISION",
        --"GADGET_PARACHUTE",
        --"WEAPON_ADVANCEDRIFLE",
        "WEAPON_AIRSTRIKE_ROCKET",
        "WEAPON_AIR_DEFENCE_GUN",
        "WEAPON_ANIMAL",
        "WEAPON_APPISTOL",
        "WEAPON_ASSAULTRIFLE",
        "WEAPON_ASSAULTSHOTGUN",
        "WEAPON_ASSAULTSMG",
        "WEAPON_AUTOSHOTGUN",
        "WEAPON_BALL",
        "WEAPON_BARBED_WIRE",
        --"WEAPON_BAT",
        "WEAPON_BATTLEAXE",
        "WEAPON_BLEEDING",
        "WEAPON_BOTTLE",
        "WEAPON_BRIEFCASE",
        "WEAPON_BRIEFCASE_02",
        --"WEAPON_BULLPUPRIFLE",
        --"WEAPON_BULLPUPSHOTGUN",
        "WEAPON_BZGAS",
        --"WEAPON_CARBINERIFLE",
        "WEAPON_COMBATMG",
        "WEAPON_COMBATPDW",
        --"WEAPON_COMBATPISTOL",
        "WEAPON_COMPACTLAUNCHER",
        "WEAPON_COMPACTRIFLE",
        "WEAPON_COUGAR",
        "WEAPON_CROWBAR",
        --"WEAPON_DAGGER",
        "WEAPON_DBSHOTGUN",
        "WEAPON_DIGISCANNER",
        "WEAPON_DROWNING",
        "WEAPON_DROWNING_IN_VEHICLE",
        "WEAPON_ELECTRIC_FENCE",
        "WEAPON_EXHAUSTION",
        "WEAPON_EXPLOSION",
        "WEAPON_FALL",
        "WEAPON_FIRE",
        --"WEAPON_FIREEXTINGUISHER",
        "WEAPON_FIREWORK",
        "WEAPON_FLARE",
        "WEAPON_FLAREGUN",
        "WEAPON_GARBAGEBAG",
        --"WEAPON_GOLFCLUB",
        "WEAPON_GRENADE",
        "WEAPON_GRENADELAUNCHER",
        "WEAPON_GRENADELAUNCHER_SMOKE",
        --"WEAPON_GUSENBERG",
        "WEAPON_HAMMER",
        "WEAPON_HANDCUFFS",
        "WEAPON_HATCHET",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_HEAVYSHOTGUN",
        "WEAPON_HEAVYSNIPER",
        "WEAPON_HELI_CRASH",
        "WEAPON_HIT_BY_WATER_CANNON",
        "WEAPON_HOMINGLAUNCHER",
        --"WEAPON_KNIFE",
        "WEAPON_KNUCKLE",
        "WEAPON_MACHETE",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_MARKSMANPISTOL",
        --"WEAPON_MARKSMANRIFLE",
        "WEAPON_MG",
        "WEAPON_MICROSMG",
        "WEAPON_MINIGUN",
        "WEAPON_MINISMG",
        "WEAPON_MOLOTOV",
        --"WEAPON_MUSKET",
        --"WEAPON_NIGHTSTICK",
        "WEAPON_PASSENGER_ROCKET",
        --"WEAPON_PETROLCAN",
        "WEAPON_PIPEBOMB",
        --"WEAPON_PISTOL",
        --"WEAPON_PISTOL50",
        "WEAPON_POOLCUE",
        "WEAPON_PROXMINE",
        --"WEAPON_PUMPSHOTGUN",
        "WEAPON_RAILGUN",
        "WEAPON_RAMMED_BY_CAR",
        "WEAPON_REMOTESNIPER",
        "WEAPON_REVOLVER",
        "WEAPON_RPG",
        "WEAPON_RUN_OVER_BY_CAR",
        --"WEAPON_SAWNOFFSHOTGUN",
        "WEAPON_SMG",
        "WEAPON_SMOKEGRENADE",
        "WEAPON_SNIPERRIFLE",
        --"WEAPON_SNOWBALL",
        --"WEAPON_SNSPISTOL",
        --"WEAPON_SPECIALCARBINE",
        "WEAPON_STICKYBOMB",
        "WEAPON_STINGER",
        --"WEAPON_STUNGUN",
        "WEAPON_SWITCHBLADE",
        --"WEAPON_UNARMED",
        "WEAPON_VEHICLE_ROCKET",
        --"WEAPON_VINTAGEPISTOL",
        "WEAPON_WRENCH",
    }
}

local config = {
    refresh_rate = 1000,
    tp_distance = 200,
    noclip_distance = 25,
    infractionNames = {
        ["noclip"] = "Noclip / Still Flight",
        ["health"] = "Health Modifier / Budget God Mode",
        ["weapons"] = "Weapon Spawning",
        ["god"] = "God Mode / Invincibility",
        ["invisible"] = "Invisibility",
        ["vehicle"] = "Blacklisted Vehicle",
        ["money"] = "Money",
        ["items"] = "Items",
    },
}

local current_tick =  {
}

local previous_tick = {
}

function saveDataTo(dataset)
    local ped = PlayerPedId()
    local ply = PlayerId()
    dataset.ped = ped
    dataset.ply = ply
    dataset.health = GetEntityHealth(ped)
    dataset.pos = GetEntityCoords(ped)
    dataset.still = IsPedStill(ped)
	dataset.vel = GetEntitySpeed(ped)
	dataset.veh = GetVehiclePedIsIn(ped, false)
    dataset.inveh = IsPedInAnyVehicle(ped, false)
    dataset.driving = (GetPedInVehicleSeat(dataset.veh, -1) == ped)
    dataset.inair = IsEntityInAir(entity)
	dataset.speed = GetEntitySpeed(ped)
	dataset.para = GetPedParachuteState(ped)
	dataset.god = GetPlayerInvincible(ply)
	dataset.flyveh = IsPedInFlyingVehicle(ped)
	dataset.ragdoll = IsPedRagdoll(ped)
	dataset.fall = IsPedFalling(ped)
	dataset.parafall = IsPedInParachuteFreeFall(ped)
    dataset.visible = IsEntityVisible(ped)
end

function updateCurrentTick()
    saveDataTo(current_tick)
end

function updatePreviousTick()
    saveDataTo(previous_tick)
end

function makeInfraction(_type, _data)
    local infraction = {}
    infraction.name = config.infractionNames[_type]
    infraction.data = _data
    infraction.source = PlayerId()
    table.insert(infractions, infraction)
    TriggerServerEvent("gd_anticheat:infraction", infraction, #infractions)
    local dataString = "`num = " .. #infractions .. "`"
    for k,v in next, _data do
        local p = ""
        if (type(v) == 'table') then
            p = "{"
            local _d = false
            for _k,_v in next, v do
                _d = true
                p = p .. "\"" .. tostring(_v) .. "\","
            end
            if _d then
                p = p:sub(1,-2)
            end
            p = p .. "}"
        else
            p = tostring(v)
        end
        dataString = dataString .. (" `%s = %s`"):format(tostring(k), tostring(p))
    end
    --TriggerEvent("gd_utils:popup", "~r~Anti-Cheat", "~y~" .. infraction.name .. "\n~w~" .. dataString, 1)
end

Citizen.CreateThread(function()
    updatePreviousTick()
    while true do
        updateCurrentTick()
        Wait(config.refresh_rate)
        if ENABLED then
            local dist = GetDistanceBetweenCoords(current_tick.pos.x, current_tick.pos.y, current_tick.pos.z, previous_tick.pos.x, previous_tick.pos.y, previous_tick.pos.z)

            -- Check for noclip
            if dist > 25 and current_tick.still == previous_tick.still and current_tick.vel == previous_tick.vel and current_tick.ped == previous_tick.ped then
                makeInfraction("noclip", {distance = dist, moving = true})
                SetEntityCoords(current_tick.ped, previous_tick.pos.x, previous_tick.pos.y, previous_tick.pos.z, 0, 0, 0, 0)
            end
            if current_tick.inair and previous_tick.inair and current_tick.pos.x + current_tick.pos.y + current_tick.pos.z == previous_tick.pos.x + previous_tick.pos.y + previous_tick.pos.z then
                makeInfraction("noclip", {distance = dist, moving = false})
            end

            -- Check for illegal weapons
            local weapons = {}
            for _,weapon in next, blacklist.weapons do
    			if HasPedGotWeapon(current_tick.ped, GetHashKey(weapon), false) then
                    table.insert(weapons, weapon)
    			end
    		end
            if #weapons > 0 then
                RemoveAllPedWeapons(current_tick.ped, false)
                makeInfraction("weapons", {weapon = weapons})
            end

            -- Check for illegal vehicles
            if current_tick.driving then
                for _,vehicle in next, blacklist.vehicles do
                    if GetEntityModel(current_tick.veh) == GetHashKey(vehicle) then
                        DeleteEntity(current_tick.veh)
                        makeInfraction("vehicle", {vehicle = vehicle, driver = true})
                    end
        		end
            end

            -- Check for teleport


            -- Check for Invincibility
            -- if current_tick.god and not current_tick.ragdoll and not previous_tick.ragdoll and current_tick.health > 120.0 then
            --     SetPlayerInvincible(current_tick.ply, false)
            --     makeInfraction("god", {godmode = true, ragdolled = current_tick.ragdoll})
            -- end

            -- Check for Invisibility
            -- if not current_tick.visible and not previous_tick.visible then
            --     SetEntityVisible(current_tick.ped, true)
            --     makeInfraction("invisible", {invisible = true})
            -- end

        end
        updatePreviousTick()
    end
end)
--U da best!

RegisterNetEvent("gd_anticheat:enable")
AddEventHandler("gd_anticheat:enable", function(toggle)
    ENABLED = toggle
end)

-- Check for health hacks (using @BlueTheFurry's method)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        if ENABLED then
            local curPed = PlayerPedId()
            local curHealth = GetEntityHealth( curPed )
            SetEntityHealth( curPed, curHealth-2)
            local curWait = math.random(20,350)
            Citizen.Wait(curWait)

            if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) > 120.0 and GetEntityHealth(curPed) ~= 0 and not IsPedRagdoll(curPed) then
                makeInfraction("health", {health = GetEntityHealth(curPed)})
            elseif GetEntityHealth(curPed) == curHealth-2 then
                SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
            end
        end
    end
end)

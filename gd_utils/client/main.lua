RegisterNetEvent("gd_utils:message") -- Title, Message
RegisterNetEvent("gd_utils:overlay") -- Title, Line1, Line2
RegisterNetEvent("gd_utils:oneliner") -- Text
RegisterNetEvent("gd_utils:popup") -- Title, Message
RegisterNetEvent("gd_utils:news") -- Title, Line1 (bottom), Line2 (upper)
RegisterNetEvent("gd_utils:stats") -- Title, Message, IconFile*, IconName*, {StatNames}, {+StatValues}
RegisterNetEvent("gd_utils:pedstats") -- Title, Message, {StatNames}, {+StatValues}
RegisterNetEvent("gd_utils:sfx_alert") -- +AlertNo*
RegisterNetEvent("gd_utils:over_vehicle") -- true/false
-- Variable = String
-- Variable* = Optional String (can use empty string)
-- {Variable} = List of Variables ({"Foo", "Bar"})
-- +Variable = Number
-- All events have a time variable at the end, it's completely optional and defaults to 5 (seconds) if not set

local _currentScaleform = nil
local _currentTimeout = 0
local _timer = 0
local _overVehicle = false
local _vehicleOffset = 0.0

function get_time()
    local year, month, day, hour, minute, second = GetLocalTime()
    return (second + minute*60 + hour*60*60 + day*24*60*60)
end

Citizen.CreateThread(function()
    print("gd_utils/client/main.lua init")
    while true do
			
        Citizen.Wait(5)
        _timer = get_time()
			
		local ply = GetPlayerPed(-1)
		local veh = GetVehiclePedIsIn(ply, true)
			
        -- Draw fullscreen scaleform
        if _currentScaleform ~= nil and _currentTimeout >= _timer and _currentTimeout - _timer < 120 then
            if _overVehicle then
                if veh ~= nil then
                    local pos = GetEntityCoords(veh)
                    SetDrawOrigin(pos.x, pos.y, pos.z + _vehicleOffset, 0)
                    DrawScaleformMovie(_currentScaleform, 0.0, 0.0, 0.5, 0.5, 255, 255, 255, 255, 0)
                    ClearDrawOrigin()
                else
                    DrawScaleformMovieFullscreen(_currentScaleform, 255, 255, 255, 255, 0)
                end
            else
                DrawScaleformMovieFullscreen(_currentScaleform, 255, 255, 255, 255, 0)
            end
        end
    end
end)

function load_scaleform(_sf)
    local scaleform = RequestScaleformMovie(_sf)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(2)
    end
    return scaleform
end

function CreatePopup(title, text)
    local scaleform = load_scaleform("MP_BIG_MESSAGE_FREEMODE")
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(text)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function CreateMessage(title, text)
    local scaleform = load_scaleform("MIDSIZED_MESSAGE")
    PushScaleformMovieFunction(scaleform, "SHOW_MIDSIZED_MESSAGE")
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(text)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function CreateOneLiner(text)
    local scaleform = load_scaleform("MP_BIG_MESSAGE_FREEMODE")
    PushScaleformMovieFunction(scaleform, "SHOW_CENTERED_TOP_MP_MESSAGE")
    PushScaleformMovieFunctionParameterInt(2)
    PushScaleformMovieFunctionParameterString(text)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

function CreatePopupScaleform(title, text, text2)
    local scaleform = load_scaleform("POPUP_WARNING")
    PushScaleformMovieFunction(scaleform, "SHOW_POPUP_WARNING")
    PushScaleformMovieFunctionParameterFloat(500.0)
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(text)
    PushScaleformMovieFunctionParameterString(text2)
    PushScaleformMovieFunctionParameterBool(false)
    PushScaleformMovieFunctionParameterInt(0)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
    
function CreateNewsScaleform(title, text, text2)
    local scaleform = load_scaleform("BREAKING_NEWS")
    PushScaleformMovieFunction(scaleform, "SET_TEXT")
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(text)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_SCROLL_TEXT")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(1)
    PushScaleformMovieFunctionParameterString(text2)
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "DISPLAY_SCROLL_TEXT")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(1)
    PushScaleformMovieFunctionParameterInt(100)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function CreateStatsScaleform(title, subtitle, logotxd, logo, stat_names, stat_values)
    local scaleform = load_scaleform("MP_CAR_STATS_12")
    PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(subtitle)
    PushScaleformMovieFunctionParameterString(logotxd)
    PushScaleformMovieFunctionParameterString(logo)
    for k,v in next, stat_names do
        PushScaleformMovieFunctionParameterString(v)
    end
    for k,v in next, stat_values do
        PushScaleformMovieFunctionParameterInt(v)
    end
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function CreatePedStatsScaleform(title, subtitle, stat_names, stat_values)
    local scaleform = load_scaleform("MP_CAR_STATS_01")
    PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS")
    PushScaleformMovieFunctionParameterString(title)
    PushScaleformMovieFunctionParameterString(subtitle)
    local handle = RegisterPedheadshot(GetPlayerPed(-1))
    while not IsPedheadshotReady(handle) do
        Citizen.Wait(5)
    end
    local pedtxd = GetPedheadshotTxdString(handle)
    PushScaleformMovieFunctionParameterString(pedtxd)
    PushScaleformMovieFunctionParameterString(pedtxd)
    for k,v in next, stat_names do
        PushScaleformMovieFunctionParameterString(v)
    end
    for k,v in next, stat_values do
        PushScaleformMovieFunctionParameterInt(v)
    end
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function CreateOverlayScaleform(titleLabel, messageLabel, acceptButtonLabel)
    local scaleform = load_scaleform("warehouse")
    PushScaleformMovieFunction(scaleform, "SHOW_OVERLAY")
    PushScaleformMovieFunctionParameterString(titleLabel)
    PushScaleformMovieFunctionParameterString(messageLabel)
    PushScaleformMovieFunctionParameterString(acceptButtonLabel)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function set_scaleform(scaleform, time)
    if time == nil then time = 10 end
    _currentScaleform = scaleform
    _currentTimeout = _timer + time
    _overVehicle = false
    _vehicleOffset = 0.0
end

function ShowPopup(title, text, time)
    set_scaleform(CreatePopup(title, text), time)
end

function ShowMessage(title, text, time)
    set_scaleform(CreateMessage(title, text), time)
end

function ShowOneLiner(text, time)
    set_scaleform(CreateOneLiner(text), time)
end

function ShowOverlayScaleform(titleLabel, messageLabel, acceptButtonLabel, time)
    set_scaleform(CreateOverlayScaleform(titleLabel, messageLabel, acceptButtonLabel), time)
end

function ShowPopupScaleform(title, text, text2, time)
    set_scaleform(CreatePopupScaleform(title, text, text2), time)
end

function ShowNewsScaleform(title, text, text2, time)
    set_scaleform(CreateNewsScaleform(title, text, text2), time)
end

function ShowStatsScaleform(title, subtitle, logotxd, logo, stat_names, stat_values)
    set_scaleform(CreateStatsScaleform(title, subtitle, logotxd, logo, stat_names, stat_values), time)
    _vehicleOffset = 2.0
end
function ShowPedStatsScaleform(title, subtitle, stat_names, stat_values)
    set_scaleform(CreatePedStatsScaleform(title, subtitle, stat_names, stat_values), time)
    _vehicleOffset = 2.0
end

AddEventHandler("gd_utils:message", function(title, text, time)
    ShowMessage(title, text, time)
end)

AddEventHandler("gd_utils:overlay", function(title, text, text2, time)
    ShowPopupScaleform(title, text, text2, time)
end)

AddEventHandler("gd_utils:popup", function(title, text, time)
    ShowPopup(title, text, time)
end)

AddEventHandler("gd_utils:oneliner", function(text, time)
    ShowOneLiner(text, time)
end)

AddEventHandler("gd_utils:news", function(title, text, text2, time)
    ShowNewsScaleform(title, text, text2, time)
end)

AddEventHandler("gd_utils:stats", function(title, subtitle, logotxd, logo, stat_names, stat_values, time)
    ShowStatsScaleform(title, subtitle, logotxd, logo, stat_names, stat_values, time)
end)

AddEventHandler("gd_utils:pedstats", function(title, subtitle, stat_names, stat_values, time)
    ShowPedStatsScaleform(title, subtitle, stat_names, stat_values, time)
end)

AddEventHandler("gd_utils:sfx_alert", function(alert_id)
    sfx_list = {
        {name = "CHECKPOINT_MISSED", library = "HUD_MINI_GAME_SOUNDSET"},
        {name = "FLIGHT_SCHOOL_LESSON_PASSED", library = "HUD_AWARDS"},
        {name = "TIMER_STOP", library = "HUD_MINI_GAME_SOUNDSET"},
        {name = "Bed", library = "WastedSounds"},
        {name = "MEDAL_UP", library = "HUD_MINI_GAME_SOUNDSET"},
        {name = "CHALLENGE_UNLOCKED", library = "HUD_AWARDS"},
    }
    if (alert_id == nil) or (alert_id > #sfx_list) then
        alert_id = 1
    end
    print("gd_utils:sfx_alert " .. sfx_list[alert_id].library .. "/" .. sfx_list[alert_id].name)
    PlaySoundFrontend(-1, sfx_list[alert_id].name, sfx_list[alert_id].library, 0)
end)
AddEventHandler("gd_utils:over_vehicle", function(toggle)
    _overVehicle = toggle
end)
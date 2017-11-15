------------------
-- CONFIG START --
------------------

-- Messages
startText = "Press ~g~E ~w~to start a ~g~Bus Route ~w~from ~g~%s~w~"
startTextSpecial = "Press ~g~E ~w~to start an ~g~Express Route ~w~from ~g~%s~w~"
pickupText = "Press ~g~E ~w~to pick up ~g~%s ~w~from ~g~%s~w~"
invalidVehicleText = "You need a ~g~BUS ~w~to do this"
tooLowTierText = "Express routes are reserved for ~g~Coaches ~w~only"
engineRunningText = "Fully ~r~STOP ~w~before boarding / deboarding"

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
    {name = "Bus Service", x = 470.0, y = -625.0},
    {name = "Bus Service", x = 1955.0, y = 3771.0},
    {name = "Bus Service", x = -362.9, y = 6069.8},
    {name = "Bus Service", x = -2344.5, y = 3246.4},
}

-- Blip Settings
job_blip_settings = {
    start_blip = {id = 513, color = 38},
    destination_blip = {id = 420, color = 4},
    marker = {r = 0, g = 150, b = 255, a = 200},
    marker_special = {r = 255, g = 255, b = 0, a = 200},
}

-- Locations
ls_routes = {
    {
        {name = "LSIA Terminal 2", 		x = -1048.877930, y = -2540.111572, z = 12.505210},
        {name = "Maze Bank Arena", 		x = -307.695801, y = -1844.940430, z = 23.845625},
        {name = "Strawberry Avenue", 	x = -43.776791, y = -1648.477661, z = 28.033178},
        {name = "Carson Avenue", 		x = 50.928295, y = -1536.593506, z = 28.018265},
        {name = "Adam's Apple Blv", 	x = 98.416206, y = -1055.010620, z = 28.118307},
        {name = "San Andreas Avenue", 	x = 115.008423, y = -784.036377, z = 30.126572},
        {name = "San Vitus Blvd", 		x = -256.629272, y = -330.119690, z = 28.699272},
        {name = "Boulevard Del Perro", 	x = -490.618530, y = 20.407391, z = 43.791027},
        {name = "Strangeways Drive", 	x = -693.450562, y = -5.167409, z = 37.019169},
        {name = "Mad Wayne Thunder Dr", x = -931.669128, y = -126.633087, z = 36.415554},
        {name = "Marathon Avenue", 		x = -1047.878540, y = -389.459473, z = 36.419994},
        {name = "Rockford Hills", 		x = -679.639771, y = -376.881226, z = 33.043865},
        {name = "Ginger Street", 		x = -652.388367, y = -607.065369, z = 32.059444},
        {name = "Vespucci Blvd", 		x = -558.416321, y = -846.186951, z = 26.312037},
        {name = "La Puerta Fwy", 		x = -250.537796, y = -883.167053, z = 29.415934},
        {name = "Innocence Blvd", 		x = -302.779999, y = -1476.822632, z = 29.369450},
    },
    {
        {name = "Textile City", x = 307.135803, y = -766.019043, z = 28.227528},
        {name = "Strawberry Metro Station", x = 261.568085, y = -1217.424927, z = 28.424841},
        {name = "Davis Sherrif's Office", x = 364.583069, y = -1568.484009, z = 28.203512},
        {name = "Billingsgate Motel", x = 574.867859, y = -1734.191040, z = 28.182583},
        {name = "Little Bighorn Ave", x = 774.118408, y = -1752.040039, z = 28.409100},
        {name = "Popular Street", x = 879.431213, y = -1766.265015, z = 28.894323},
        {name = "Amarillo Vista", x = 1303.761475, y = -1648.289551, z = 50.393467},
        {name = "El Burro Heights Gas Station", x = 1191.970215, y = -1421.047852, z = 34.044270},
        {name = "Olympic Fwy", x = 806.741638, y = -1353.140259, z = 25.286720},
        {name = "Popular Street", x = 785.882019, y = -775.321411, z = 25.329002},
        {name = "Occupation Avenue", x = 428.806915, y = -359.720764, z = 46.116802},
        {name = "Power Street", x = 160.195572, y = -372.077209, z = 41.672024},
        {name = "Union Depository", x = 41.333294, y = -706.174377, z = 43.126556},
        {name = "Downtown Parking Garage", x = -335.592316, y = -683.291138, z = 31.849171},
        {name = "Alta Street", x = -86.832825, y = -652.732300, z = 35.105892},
        {name = "Low Power Street", x = 70.441124, y = -627.019653, z = 30.579842},
        {name = "Vespucci Blvd", x = 62.284081, y = -996.830688, z = 28.256859},
    },
    {   
        {name = "Vespucci Beach", x = -1456.489258, y = -967.370056, z = 6.261691},
        {name = "Vespucci Beach", x = -1352.111206, y = -1113.946533, z = 3.407488},
        {name = "Vespucci Beach", x = -1321.315552, y = -1292.585571, z = 3.940287},
        {name = "Vespucci Beach", x = -1286.420532, y = -1396.484009, z = 3.523031},
        {name = "Aguja Street", x = -1167.743652, y = -1472.403931, z = 3.280961},
        {name = "Melanoma Street", x = -1087.516235, y = -1586.963745, z = 3.321031},
        {name = "La Puerta Apartments", x = -944.724731, y = -1527.015015, z = 4.056648},
        {name = "La Puerta Apartments", x = -993.357361, y = -1441.655884, z = 4.072592},
        {name = "Vista Del Mar Apartments", x = -1037.417603, y = -1532.505371, z = 4.053168},
        {name = "The Wiseroy", x = -830.088196, y = -1218.166382, z = 5.931358},
        {name = "La Puerta Marina", x = -800.468201, y = -1332.293945, z = 3.997653},
        {name = "Higgins Helitours", x = -716.186951, y = -1405.214233, z = 3.997248},
        {name = "Little Seoul Gas Station", x = -524.743774, y = -1198.608643, z = 17.541819},
        {name = "Little Seoul Tram Station", x = -521.956665, y = -1302.051392, z = 27.012049},
        {name = "La Puerta Gas Station", x = -322.942200, y = -1443.668823, z = 29.714195},
        {name = "Carson Avenue", x = -21.008894, y = -1378.070068, z = 28.275986},
        {name = "Olympic Fwy Underpass", x = 77.380333, y = -1214.512207, z = 28.123667},
        {name = "Adam's Apple Blvd", x = 95.186195, y = -1061.527832, z = 28.265455},
        {name = "San Andreas Avenue", x = 115.118439, y = -783.993042, z = 30.291632},
        {name = "Little Seoul Parking Complex", x = -466.381317, y = -649.065796, z = 31.306229},
        {name = "Ginger Street", x = -770.386658, y = -647.734436, z = 28.840813},
        {name = "Weazel Plaza", x = -931.685364, y = -465.941254, z = 36.085449},
        {name = "Lifeinvader HQ", x = -1077.113647, y = -264.329651, z = 36.719830},
        {name = "Morningwood Blvd", x = -1280.407349, y = -321.272278, z = 35.672688},
        {name = "North Rockford Drive", x = -1417.084595, y = -399.028290, z = 35.194302},
        {name = "Prosperity Street", x = -1525.448242, y = -465.898956, z = 34.293213},
        {name = "Bay City Avenue", x = -1538.372559, y = -683.898926, z = 27.764669},
        {name = "Del Perro Pier", x = -1629.170898, y = -999.052368, z = 12.034500},
    },
    {
        {name = "Pillbox Hill Medical Center", x = 290.073639, y = -588.705994, z = 42.999905},
        {name = "Alta", x = 393.089783, y = -198.228836, z = 59.249481},
        {name = "Vinewood Plaza", x = 546.343018, y = 154.992188, z = 98.938354},
        {name = "Vinewood Hills Arena", x = 707.297607, y = 661.271912, z = 128.741226},
        {name = "North Conker Avenue", x = 340.571075, y = 473.769196, z = 149.536407},
        {name = "Sisyphus Theater", x = 233.522186, y = 1175.608643, z = 225.289536},
        {name = "Lake Vinewood", x = -75.519508, y = 893.577209, z = 235.406143},
        {name = "North Sheldon Avenue", x = -718.873962, y = 960.467590, z = 237.414627},
        {name = "Normandy Drive", x = -918.196106, y = 793.625732, z = 183.889343},
        {name = "Hillcrest Avenue", x = -917.567871, y = 697.311035, z = 151.466461},
        {name = "Hillcrest Avenue", x = -686.764465, y = 604.516663, z = 143.481186},
        {name = "Normandy Drive", x = -629.844666, y = 685.028870, z = 150.348328},
        {name = "Didion Drive", x = -510.327759, y = 569.082642, z = 118.609016},
        {name = "Hillcrest Ridge Access Road", x = -696.260254, y = 489.169250, z = 109.245049},
        {name = "Dunstable Lane", x = -837.081909, y = 292.296692, z = 86.154709},
        {name = "The Generic", x = -481.763062, y = 224.086395, z = 82.916214},
        {name = "Eclipse Lodge", x = -256.527252, y = 12.497521, z = 52.772953},
        {name = "Cancer Way", x = -296.263885, y = -271.570099, z = 31.390156},
        {name = "Daily Globe International", x = -286.271729, y = -616.369568, z = 33.201347},
        {name = "Power Street", x = 119.872200, y = -812.574402, z = 30.998062},
    }
}

sandy_routes = {
    {
        {name = "Otto's Auto Parts",            x = 1934.254883, y = 3717.046631, z = 31.419857},
        {name = "Sandy Shores EMS Center",      x = 1852.423828, y = 3669.115479, z = 32.922707},
        {name = "Sandy Shores Fire Station",    x = 1708.511719, y = 3584.693359, z = 34.450268},
        {name = "Sandy Shores Motel",           x = 1614.452759, y = 3599.380859, z = 34.141155},
        {name = "Liquor Ace",                   x = 1404.076904, y = 3596.956055, z = 33.878101},
        {name = "Outskirt Liquor Marker",       x = 914.946106, y = 3611.223389, z = 31.777626},
        {name = "Zancudo River",                x = 323.576447, y = 3573.897217, z = 32.566010},
        {name = "Outskirts Market",             x = 461.751740, y = 3574.130371, z = 32.234318},
        {name = "Outskirts Junk Yard",          x = 1276.636353, y = 3636.295166, z = 32.254848},
        {name = "The Boat House",               x = 1537.832153, y = 3769.875000, z = 33.045795},
        {name = "Sandy Shores Ammu-Nation",     x = 1718.996094, y = 3759.021729, z = 33.037987},
        {name = "Sandy Shores St.",             x = 1700.300049, y = 3885.505859, z = 33.810108},
        {name = "Sandy Shores Grocery Store",   x = 1963.717896, y = 3854.875732, z = 30.984299},
        {name = "Sandy Shores Gas Station",     x = 1992.588745, y = 3761.645264, z = 31.175697},
    },
    {
        {name = "Sandy Shores Gas Station",     x = 1991.923950, y = 3760.260986, z = 31.173931},
        {name = "Grapeseed Auto Repairs",       x = 2503.481445, y = 4102.588867, z = 37.249912},
        {name = "Grapeseed Cattle Farm",        x = 2547.243652, y = 4692.306152, z = 32.609898},
        {name = "Grapeseed Substation",         x = 2575.273193, y = 5081.580566, z = 43.642788},
        {name = "Chiliad Trail",                x = 2467.405029, y = 5120.727051, z = 45.637135},
        {name = "Grapeseed Farms",              x = 2285.321045, y = 5032.166016, z = 42.794975},
        {name = "Union Grain",                  x = 2079.138184, y = 5010.342773, z = 39.909019},
        {name = "Grapeseed Gas Station",        x = 1680.080811, y = 4936.329102, z = 41.101730},
        {name = "Grapeseed Centre",             x = 1665.092651, y = 4823.284180, z = 40.986298},
        {name = "Grapeseed Centre",             x = 1690.948608, y = 4683.540527, z = 41.977924},
        {name = "Alamo Fruit Market",           x = 1793.002075, y = 4578.837891, z = 35.839657},
        {name = "McKenzie Field",               x = 2101.956055, y = 4748.267090, z = 40.160950},
        {name = "Grapeseed Fruit Vendor",       x = 2479.939209, y = 4446.204102, z = 34.371422},
        {name = "Grapeseed Liquor Market",      x = 2468.885986, y = 4059.290283, z = 36.595963},
        {name = "Outskirts Underpass",          x = 2314.218262, y = 3840.397217, z = 33.808651},
        {name = "Sandy Shores Substation",      x = 2069.545166, y = 3714.340088, z = 31.904259},
    }
}

paleto_routes = {
    {
        {name = "Paleto Bay Market", x = -389.286926, y = 6057.842285, z = 30.496717},
        {name = "Paleto Bay Bus Stop", x = -331.934662, y = 6192.689453, z = 30.266617},
        {name = "The Hen House", x = -326.344421, y = 6261.967285, z = 30.369061},
        {name = "South Seas Apartments", x = -173.986389, y = 6455.390137, z = 29.879629},
        {name = "Paleto Bay Centre", x = -73.135674, y = 6453.126465, z = 30.274168},
        {name = "Paleto Bay Truck Stop", x = 137.652603, y = 6636.105957, z = 30.627174},
        {name = "Zancudo Grain Growers", x = 425.742310, y = 6555.231934, z = 26.183887},
        {name = "Outskirts Gas Station", x = 1701.486328, y = 6410.923340, z = 31.959030},
        {name = "Up-n-Atom Diner", x = 1584.058472, y = 6440.204102, z = 23.964773},
        {name = "Paleto Bay Warehouses", x = 52.838566, y = 6447.492188, z = 30.351645},
        {name = "Cluckin' Bell Factory", x = -21.842253, y = 6267.696777, z = 30.215376},
        {name = "Paleto Bay Hwy Stop", x = -215.601974, y = 6172.683105, z = 30.216635},
        {name = "Paleto Bay Ammu-Nation", x = -318.693695, y = 6071.897949, z = 30.260986},
    }
}

-- Routes for the coaches (long distance)
local coach_routes = {
    {
        --{name = "Dashound Bus Center Los Santos", x = 423.852783, y = -640.685425, z = 27.497103}, -- COULD BE ABUSED WITH END JOB @ LS
        {name = "Los Santos Casino", x = 917.835022, y = 53.499908, z = 79.762299},
        {name = "Rex's Diner", x = 2535.414063, y = 2626.648682, z = 36.942669},
        {name = "Sandy Shores Airfield", x = 1781.215576, y = 3329.289063, z = 40.255463},
        {name = "Sandy Shores", x = 1852.603271, y = 3669.642090, z = 32.876659},
        {name = "Grapeseed", x = 1683.751953, y = 4773.056152, z = 40.936325},
        {name = "Mt. Gordo / Chiliad Pass", x = 1696.111084, y = 6400.314941, z = 31.212353},
        {name = "Paleto Bay Truck Stop", x = 128.074356, y = 6626.437500, z = 30.746687},
        {name = "Pala Springs Aerial Tramway", x = -772.959106, y = 5534.054688, z = 32.478867},
        {name = "Chiliad Mountain State Wilderness", x = -1514.792847, y = 5012.244629, z = 61.504887},
        {name = "Hookies Seafood Diner", x = -2205.948975, y = 4265.750977, z = 46.834175},
        {name = "Fort Zanudo", x = -2353.343262, y = 3423.392334, z = 27.797852},
        {name = "Lago Zancudo", x = -2548.797363, y = 2322.243408, z = 32.055687},
        {name = "Chumash Plaza", x = -3125.901611, y = 1091.310669, z = 19.476885},
        {name = "Banham Canyon", x = -2972.177490, y = 354.181000, z = 13.768280},
        --{name = "Pacific Bluffs Country Club", x = -3013.961914, y = 92.478340, z = 10.610859},
        {name = "Del Perro Beach", x = -1998.593628, y = -468.897827, z = 10.544088},
        {name = "LSIA Terminal 4", x = -1036.573120, y = -2728.210449, z = 19.089064},
    }
}

local zancudo_routes = {
    {
        {name = "Shelter 4", x = -2301.510010, y = 3214.237793, z = 32.615788},
        {name = "Aircraft Hangar 1", x = -2157.261475, y = 3314.906982, z = 32.609871},
        {name = "Aircraft Hangar 2", x = -2025.650879, y = 3242.662842, z = 32.609516},
        {name = "Aircraft Hangar 2 Loading Bay", x = -1967.554688, y = 3153.518066, z = 32.610298},
        {name = "Aircraft Hangar 0101", x = -1804.243164, y = 2879.348145, z = 32.607800},
        {name = "Fort Zancudo Fire Station", x = -2087.227051, y = 2841.295410, z = 32.610172},
        {name = "Fuel Station", x = -2439.362305, y = 2994.418945, z = 32.609871},
        {name = "Aircraft Hangar 3499", x = -2459.139648, y = 3345.497314, z = 32.627720},
        {name = "Gate", x = -2284.899170, y = 3375.904541, z = 31.248135},
        {name = "Barracks", x = -1824.799194, y = 3299.621094, z = 32.702354},
        {name = "Barracks", x = -1738.645996, y = 3250.994141, z = 32.670261},
        {name = "Warehouses", x = -1745.656860, y = 3095.125488, z = 32.635269},
        {name = "Gate", x = -1608.623779, y = 2811.175781, z = 17.326830},
        {name = "Parking", x = -1747.514893, y = 2950.079346, z = 32.605946},
        {name = "ATC Tower 2", x = -2420.900391, y = 3277.247314, z = 32.630661},
    }
}

-- Job Start markers
job_starts = {
    {name = "Los Santos Bus Service", x = 460.0, y = -625.0, z = 27.5, tier = 1, routes = ls_routes},
    {name = "Los Santos Coach Service", x = 461.670441, y = -606.164185, z = 27.496000, tier = 3, routes = coach_routes},
    {name = "Sandy Shores Bus Service", x = 1955.0, y = 3771.0, z = 31.2, tier = 1, routes = sandy_routes},
    {name = "Paleto Bay Bus Service", x = -362.9, y = 6069.8, z = 30.5, tier = 1, routes = paleto_routes},
    {name = "Zancudo Start", x = -2344.502930, y = 3246.406982, z = 32.628830, tier = 1, routes = zancudo_routes},
}

-- Vehicles plus tiers
job_vehicles = {
    {name = "RENTALBUS", tier = 1},
    {name = "BUS", tier = 2},
    {name = "AIRBUS", tier = 2},
    {name = "IKARUS1", tier = 2},
    {name = "IKARUS2", tier = 3},
    {name = "IKARUS3", tier = 4},
    {name = "COACH", tier = 5},
}

-- Localized names for peds
ped_names = {
    ["default"] = "Commuters",
    ["coach"] = "Passengers",
}

-- Payment multiplier for ped
ped_payment = {
    ["default"] = 1.0,
    ["coach"] = 1.5,
}

-- Models peds can use (chosen randomly)
ped_models = {
    "A_M_Y_GenStreet_01",
    "A_M_M_Business_01",
    "A_M_Y_Hiker_01",
}
----------------
-- CONFIG END --
----------------

local debugMarkers = {}

RegisterNetEvent("gd:pos")
AddEventHandler("gd:pos", function(msg)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    TriggerServerEvent("gd:pos", msg, {x = pos.x, y = pos.y, z = pos.z - 1})
    table.insert(debugMarkers, {name = "debug", x = pos.x, y = pos.y, z = pos.z - 1})
end)

RegisterNetEvent("gd_jobs_bus:startJob")
AddEventHandler("gd_jobs_bus:startJob",
    function(start, tier)
        startJob(start, tier)
    end
)

RegisterNetEvent("bus_stopjob")
AddEventHandler("bus_stopjob", function()
        cancelJob()
end)

function getRandomPedModel()
    local mod = ped_models[math.random(#ped_models)]
    return mod
end

function drawMarker(x,y,z,s)
    local marker = job_blip_settings.marker
    if s or false then
        marker = job_blip_settings.marker_special
    end
    DrawMarker(1, x, y, z, 0,0,0,0,0,0,5.0,5.0,2.0,marker.r,marker.g,marker.b,marker.a,0,0,0,0)
end

local current_job = {}

function setNewDestination(pos)
--    if DoesBlipExist(current_job.blip) then RemoveBlip(current_job.blip) end
--    current_job.blip = AddBlipForCoord(pos.x, pos.y, pos.z)
--    setBlipName(current_job.blip, pos.name)
--    SetBlipRoute(current_job.blip, true)
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
    
function generateBlipsFromRoute(route)
    for k,v in next, route do
        local blip = AddBlipForCoord(v.x, v.y, 0)
        SetBlipScale(blip, 0.75)
        SetBlipSprite(blip, job_blip_settings.destination_blip.id)
        SetBlipColour(blip, job_blip_settings.destination_blip.color)
        setBlipName(blip, "(Route) " .. v.name)
        v.blip = blip
    end
end

function table.clone(org)
  return {table.unpack(org)}
end

function startJob(start, tier)
    if isOnJob() then
        cancelJob()
    end
    current_job.previous = start
    current_job.start = start
    current_job.route = start.routes[math.random(#start.routes)]
    current_job.total_stops = #current_job.route
    generateBlipsFromRoute(current_job.route)
    current_job.cargo = {name = ped_names["default"], pay = ped_payment["default"]}
    if tier == 5 then
        current_job.cargo = {name = ped_names["coach"], pay = ped_payment["coach"]}
    end
    current_job.tier = tier
    current_job.fares = 0
    current_job.peds = {}

    setNewDestination(current_job.marker)
    drawMessage(string.format(startRouteMessage, current_job.cargo.name))

end

function createPedsThatEnterVehicle(number)
    local peds = {}
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local pos = GetEntityCoords(veh)
    local _model = getRandomPedModel()
    local model = GetHashKey(_model)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(1) end
    
    local _peds = 0
    
    print(number)
    
    for _i = 1, GetVehicleMaxNumberOfPassengers(veh) do
        print("_i: ".._i)
        if _peds >= number then break end
        if not DoesEntityExist(GetPedInVehicleSeat(veh, _i)) then 
            print("ped")
            local ped = CreatePed(4, model, pos.x + GetEntityForwardX(veh) * (6 + _peds), pos.y + GetEntityForwardY(veh) * (6 + _peds), pos.z, 0, true, 0)
            TaskEnterVehicle(ped, veh, 1000, _i, 1.0, 3, 0)
            table.insert(peds, ped)
            _peds = _peds + 1
        end
    end  
    return peds
end

function makePedsLeaveTheVehicle(number)
    local _i = 0
    for _i = 1, number do
        if next(current_job.peds) ~= nil then
            local ped = current_job.peds[math.random(#current_job.peds)]
            if DoesEntityExist(ped) then
                TaskLeaveAnyVehicle(ped, 0, 0)
                SetTimeout(3000, function()
                    RemovePedElegantly(ped) 
                end)
            end
        end
    end
end

function pickupJob(id)
    local p = table.remove(current_job.route, id)
    local supply = math.random(p.supply or 3)
    local demand = math.random(p.demand or 5)
    
    print(supply)
    print(demand)
    
    makePedsLeaveTheVehicle(demand)
    RemoveBlip(p.blip)
    p.blip = nil
    
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    local peds = createPedsThatEnterVehicle(supply)    
    local newpeds = 0
    if next(peds) ~= nil then
        for k,v in next, peds do
            newpeds = newpeds + 1
            table.insert(current_job.peds, v)
        end
    end
    
    current_job.fares = current_job.fares + newpeds
    
    TriggerServerEvent("gd_jobs_bus:pickupJob", newpeds, current_job.cargo.pay, current_job.tier)
    if (#current_job.route > 0) then
        drawMessage(string.format(continueMessage, current_job.cargo.name, current_job.total_stops - #current_job.route, current_job.total_stops))
    else
        deliverJob()
    end
end

function deliverJob()    
    TriggerServerEvent("gd_jobs_bus:finishJob", current_job.fares, current_job.cargo.pay, current_job.tier)
    drawMessage(string.format(jobDoneMessage, current_job.cargo.name))
    cancelJob()
end

function isOnJob()
    return (next(current_job) ~= nil)
end

function cancelJob()
    -- Remove all blips
    if next(current_job.route) ~= nil then
        for k,v in next, current_job.route do
            if DoesBlipExist(v.blip) then
                RemoveBlip(v.blip)
            end
        end
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

function promptJob(location)
    local validVehicle = isInValidVehicle()
    local tier = location.tier
    if validVehicle then
        if getCurrentTier() >= tier then
            if tier == 3 then
                drawText(string.format(startTextSpecial, location.name))  
            else
                drawText(string.format(startText, location.name))         
            end
            if isEPressed() then
                TriggerServerEvent("gd_jobs_bus:tryStartJob", location, tier) 
                return
            end
        else
            drawText(tooLowTierText)         
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
        SetBlipSprite(blip, job_blip_settings.start_blip.id)
        SetBlipColour(blip, job_blip_settings.start_blip.color)
        SetBlipAsShortRange(blip, true)
        setBlipName(blip, v.name)
    end
    while true do
        Citizen.Wait(1)
        if not isOnJob() then
            -- NOT ON JOB
            local p = GetEntityCoords(GetPlayerPed(-1))
            for k,v in next, job_starts do 
                drawMarker(v.x, v.y, v.z, v.tier > 2)    
                if nearMarker(v.x, v.y, v.z) then
                    promptJob(v, getCurrentTier())
                end
            end
            for k,v in next, debugMarkers do 
                drawMarker(v.x, v.y, v.z)    
            end
        else
            -- ON JOB
            for k,v in next, current_job.route do
                local marker = v
                local p = GetEntityCoords(GetPlayerPed(-1))
                local veh = GetVehiclePedIsIn(GetPlayerPed(-1))
                drawMarker(marker.x, marker.y, marker.z)
                if nearMarker(marker.x, marker.y, marker.z) and isInValidVehicle() and getCurrentTier() >= current_job.tier then
                    if GetEntitySpeed(veh) > 0.1 and engineNeedsToBeOff then
                        drawText(string.format(engineRunningText))
                    else
                        drawText(string.format(pickupText, current_job.cargo.name, v.name))
                        if isEPressed() then
                            pickupJob(k)
                        end
                    end
                end
            end
        end
    end
end)
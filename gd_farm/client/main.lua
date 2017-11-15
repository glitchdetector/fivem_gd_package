--[[
      ▄▌ █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█ 
   ▄▄██▌ █  Constructed for Transport Tycoon  █ 
▄▄▄▌▐██▌ █              <3 by glitchdetector  █ 
███████▌ █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ 
▀(@)▀▀▀▀▀▀▀(@)(@)▀▀   ▀▀▀▀▀▀▀▀▀▀▀▀▀(@)(@)▀▀▀▀▀▀ 
]]

-- Localization
local HINT_BUY_FIELD = "Press ~g~E ~w~to buy:~n~~y~%s ~g~($%i)~n~~w~%im^2 ~y~(%s)" -- fieldname price size cargo
local HINT_BUY_FIELD_LOCKED = "~r~Not for sale:~n~~y~%s~n~~w~%im^2 ~y~(%s)" -- fieldname size cargo
local HINT_BUY_FIELD_PROMO = "Fields are ~g~FREE ~w~for now!~n~Your owned fields will ~r~not ~w~save during this period."
local HINT_BUY_FIELD_SUCCESS = "~y~Purchase Receipt~n~~w~Field: ~g~%s~n~~w~Total: ~g~$%i" -- fieldname price
local HINT_BUY_VEHICLE = "Press ~g~E ~w~to buy:~n~~y~%s ~g~($%i)~n~~w~%im^2 ~y~(%s)" -- vehiclename price size cargo

local HINT_VEHICLE_CONTROLS = "Press ~g~G ~w~to ~y~%s" -- vehiclefunction
local HINT_TOGGLE_AUTOLOAD = "toggle auto-loading"
local HINT_TOGGLE_HARVESTER = "turn on/off harvester"
local HINT_TOGGLE_FORAGER = "toggle trailer foraging"
local HINT_TOGGLE_MOWER = "turn on/off mower"
local HINT_TOGGLE_SPRAYER = "turn on/off spreader"

local TEXT_FIELD_CURRENT = "Field:~n~~g~%s ~y~(%s)" -- fieldname fieldcargo
local TEXT_FIELD_NOT_FOR_SALE = "Field:~n~~r~%s ~g~(Not for sale)" -- fieldname
local TEXT_BUY_FIELD = "Field:~n~~r~%s ~g~($%i)" -- fieldname price
local TEXT_DROPPED_CARGO = "(%s: %i)" -- cargo amount
local TEXT_CARGO_AMOUNT = "~y~%s: ~w~%i/%i" -- cargo amount max
local TEXT_VEHICLE_NAME = "%s%s" -- colorprefix vehiclename

local COLOR_PREFIX_VEHICLE_NEUTRAL = "~w~"
local COLOR_PREFIX_VEHICLE_ON = "~g~"
local COLOR_PREFIX_VEHICLE_OFF = "~r~"

local PROMPT_START_JOB = "Press ~g~E ~w~to work as a farmer"
local PROMPT_SPAWN_VEHICLE = "Press ~g~E ~w~to spawn a %s" -- vehiclename

local BLIP_FIELD_OWNED = "Owned Field"
local BLIP_FIELD_PURCHASABLE = "Purchasable Field"
local BLIP_FIELD_LOCKED = "Locked Field"
local BLIP_GRAIN_SILOS = "Grain Silos"
local BLIP_BALE_SELLING_POINT = "Bale Selling Point"
local BLIP_FRUIT_STAND = "Fruit Stand"
local BLIP_BALE_MACHINE = "Baling Machine"
local BLIP_BUTCHERY = "Butcher"
local BLIP_MARKET = "Food Market"
local BLIP_POWERFOOD = "Powerfood"
local BLIP_WATER_TOWER = "Water Tower"

local TOOL_HARVESTER = "Harvester"
local TOOL_HOPPER = "Hopper"
local TOOL_BALE_TRAILER = "Bale Trailer"
local TOOL_LAWN_MOWER = "Grass Mower"
local TOOL_FLUID_WAGON = "Liquid Trailer"

local CARGOES_BALE_SELLING_POINT = {"bales"}
local CARGOES_GRAIN_SILOS = {"grain","corn", "grass"}
local CARGOES_FRUIT_STAND = {"weed","oranges","peaches","tomatoes","watermelons","strawberries","grapes"}
local CARGOES_MARKET = {"milk", "meat"}

local PRICE_FLUID_WAGON = 5000
local PRICE_HARVESTER = 5000
local PRICE_HOPPER = 5000
local PRICE_BALE_TRAILER = 5000
local PRICE_LAWN_MOWER = 5000
local PRICE_POWERFOOD = 1
local PRICE_WATER = 0

-- Debugging shows field borders and some other information
local debug = not true and not false --or is it?

--local cfg = module("gd_farm", "cfg/fields")

-- Always shown on map
local map_blips = {
    {name = "Farm", blipid = 85, blipcol = 64, x = 2437.389648, y = 4979.654297, z = 45.571423}, -- Grapeseed
    {name = "Farm", blipid = 85, blipcol = 64, x = 412.739227, y = 6616.628906, z = 26.762438}, -- Paleto
}

-- Blips appearing when active farmer (for other markings other than the predefined locations)
local job_blips = {
    
}

-- Starting points
local job_starts = {
    {name = "Farm Duty", x = 2437.389648, y = 4979.654297, z = 45.571423}, -- Grapeseed
    {name = "Farm Duty", x = 412.739227, y = 6616.628906, z = 26.762438}, -- Paleto
}

-- Define cargo types, names and their on-ground colors
local cargo_types = {
    -- Fields
    ["grass"] = {name = "Grass", r = 0, g = 255, b = 0},
    ["grain"] = {name = "Grain", r = 240, g = 230, b = 140},
    ["corn"] = {name = "Corn", r = 240, g = 230, b = 140},
    ["bales"] = {name = "Bales", r = 240, g = 230, b = 140},
    
    -- Fruits
    ["oranges"] = {name = "Oranges", r = 240, g = 165, b = 0},
    ["peaches"] = {name = "Peaches", r = 255, g = 218, b = 185},
    ["tomatoes"] = {name = "Tomatoes", r = 255, g = 50, b = 50},
    ["watermelons"] = {name = "Watermelons", r = 255, g = 50, b = 50},
    ["strawberries"] = {name = "Strawberries", r = 255, g = 50, b = 50},
    ["grapes"] = {name = "Grapes", r = 200, g = 0, b = 200},
    
    -- Misc
    ["fertilizer"] = {name = "Fertilizer", r = 150, g = 150, b = 150},
    ["seeds"] = {name = "Seeds", r = 150, g = 150, b = 150},
    
    -- Animal related
    ["powerfood"] = {name = "Powerfood", r = 150, g = 150, b = 150},
    ["manure"] = {name = "Manure", r = 150, g = 150, b = 150},
    ["livestock"] = {name = "Livestock", r = 150, g = 150, b = 150},
    ["meat"] = {name = "Meat", r = 200, g = 50, b = 50},
    ["milk"] = {name = "Milk", r = 255, g = 255, b = 255},
    ["water"] = {name = "Water", r = 0, g = 0, b = 200},
    ["wool"] = {name = "Wool", r = 200, g = 200, b = 200},
    
    -- Illegal stuff
    ["weed"] = {name = "Kush", r = 50, g = 255, b = 50},
    
}

-- Define vehicles and behavior here
-- Format:
--[[
    MODELNAME (has to be caps)
        name s
        prop b (used for prop trailers)
        cargoes t
            type s
            capacity i
            extra i (toggleable extra when capacity is not 0)
            autodump b (drops when full)
        on s (text when turned on)
        off s (text when turned off)
        infield f(veh,field) (function ran when vehicle is on a field)
        always f(veh) (function ran at all times)
]]
local vehicles = {
    ["prop_haybailer_01"] = {name = "Grain Harvester", prop = true, cargoes = {
        ["grain"] = {capacity = 2500, autodump = true},
        ["corn"] = {capacity = 2500, autodump = true},
    }, on = "Pickup", off = "Transport", toggleable = true,
    infield = function(veh, field)
        local pos = GetEntityCoords(veh)
        local _v = "prop_haybailer_01"
        if field.type == "grain" or field.type == "corn" then
            AddStorage(_v, field.type, math.floor(GetEntitySpeed(veh)))
        end
    end},
    
    ["prop_roundbailer01"] = {name = "Baling Machine", prop = true, cargoes = {}},
    ["prop_side_spreader"] = {name = "Mixer Wagon", prop = true, cargoes = {}},
    ["prop_sprayer"] = {name = "Fertilizer Sprayer", prop = true, cargoes = {}},
    ["prop_waterwheela"] = {name = "Watering Hose", prop = true, cargoes = {}},
    
    ["TRACTOR2"] = {name = "Stanley Fieldmaster", prop = false, cargoes = {}},
    
    ["TRACTOR"] = {name = "Tractor", prop = false, cargoes = {}},
    
    ["TRAILERSMALL"] = {name = "Liquid Trailer", prop = false, cargoes = {
        ["water"] = {capacity = 4, extra = 1, autopickup = true},
        ["manure"] = {capacity = 4, extra = 1, autopickup = true},
        ["meat"] = {capacity = 4, extra = 1, autopickup = true},
    }, on = "Spreading", off = "Transport", toggleable = true, hint = HINT_TOGGLE_SPRAYER},
    
    ["BALETRAILER"] = {name = "Bale Trailer", prop = false, cargoes = {
        ["bales"] = {capacity = 4, extra = 1, autopickup = true},
        ["livestock"] = {capacity = 4, autopickup = true},
    }, on = "Pickup", off = "Transport", toggleable = true, hint = HINT_TOGGLE_AUTOLOAD},
    
    ["RAKETRAILER"] = {name = "Harvester", prop = false, cargoes = {
        ["grain"] = {capacity = 2500, autodump = true},
        ["corn"] = {capacity = 2500, autodump = true},
        -- temporary until better solution
        ["strawberries"] = {capacity = 250, autodump = true},
        ["watermelons"] = {capacity = 250, autodump = true},
        ["tomatoes"] = {capacity = 250, autodump = true},
        ["oranges"] = {capacity = 250, autodump = true},
        ["peaches"] = {capacity = 250, autodump = true},
        ["grapes"] = {capacity = 250, autodump = true},
        ["weed"] = {capacity = 250, autodump = true},
    }, on = "Lowered", off = "Raised", toggleable = true, hint = HINT_TOGGLE_HARVESTER,
    infield = function(veh, field, cargoes)
        local pos = GetEntityCoords(veh)
        local _v = "RAKETRAILER"
        local _validfield = false
        for _k,_ in next, cargoes do
            if _k == field.type then _validfield = true break end
        end
        if _validfield then
            AddStorage(_v, field.type, math.floor(GetEntitySpeed(veh)))
        end
    end},
    
    ["GRAINTRAILER"] = {name = "Grain Trailer", prop = false, cargoes = {
        ["grain"] = {capacity = 40000, autopickup = true},
        ["grass"] = {capacity = 40000, autopickup = true},
        ["corn"] = {capacity = 40000, autopickup = true},
        -- temporary until better solution
        ["strawberries"] = {capacity = 20000, autopickup = true},
        ["watermelons"] = {capacity = 20000, autopickup = true},
        ["tomatoes"] = {capacity = 20000, autopickup = true},
        ["oranges"] = {capacity = 20000, autopickup = true},
        ["peaches"] = {capacity = 20000, autopickup = true},
        ["grapes"] = {capacity = 20000, autopickup = true},
        ["weed"] = {capacity = 20000, autopickup = true},
    }, on = "Lowered", off = "Raised", toggleable = true, hint = HINT_TOGGLE_FORAGER,
    always = function(veh)
        local pos = GetEntityCoords(veh)
        local _v = "GRAINTRAILER"
    end},
    
    ["MOWER"] = {name = "Grass Mower", prop = false, cargoes = {
        ["grass"] = {capacity = 2500, autodump = true},
    }, on = "Lowered", off = "Raised", toggleable = true, hint = HINT_TOGGLE_MOWER,
    infield = function(veh, field) 
        local pos = GetEntityCoords(veh)
        local _v = "MOWER"
        if field.type == "grass" then
            AddStorage(_v, "grass", math.floor(GetEntitySpeed(veh)))
        end
    end},
    
}

local prop_trailers = {
    ["prop_haybailer_01"] = {dist = -6.0, z = -1.25},
    ["prop_roundbailer01"] = {dist = -5.0, z = -1.0},
    ["prop_side_spreader"] = {dist = -5.0, z = -1.0},
    ["prop_sprayer"] = {dist = -4.0, z = -1.0},
    ["prop_waterwheela"] = {dist = -4.0, z = -1.0},
}

local transformers = {
    -- Grapeseed
    {name = BLIP_BALE_MACHINE, x = 2284.990234, y = 4881.849609, z = 40.171555,
        items_in = {["grain"] = 5000}, 
        items_out = {["bales"] = 1}},
    {name = BLIP_BUTCHERY, x = 1964.781494, y = 5162.719238, z = 46.140968,
        items_in = {["livestock"] = 1}, 
        items_out = {["meat"] = 250}},
    -- Paleto
    {name = BLIP_BALE_MACHINE, x = 226.195908, y = 6664.662109, z = 28.701399,
        items_in = {["grain"] = 5000}, 
        items_out = {["bales"] = 1}},
    
    {name = BLIP_BALE_MACHINE, x = 1209.849487, y = 1885.440674, z = 76.502670,
        items_in = {["grain"] = 5000}, 
        items_out = {["bales"] = 1}},
}

local animal_locations = {
    {id = "cow1", name = "Cows", type = "cows", x = 2252.325684, y = 4886.044434, z = 39.227226},
    {id = "cow2", name = "Cows", type = "cows", x = 2435.879639, y = 4817.062012, z = 33.818928},
    {id = "pig1", name = "Pigs", type = "pigs", x = 1428.483765, y = 1084.899780, z = 113.059708},
}

-- Define locations where certain cargoes can be bought
local buy_locations = {
    {name = BLIP_POWERFOOD, x = 1711.958496, y = 4744.189453, z = 40.358238,
        items_out = {["powerfood"] = PRICE_POWERFOOD}},    
    {name = BLIP_POWERFOOD, x = 1249.659546, y = 1867.566528, z = 77.983185,
        items_out = {["powerfood"] = PRICE_POWERFOOD}},    
    {name = BLIP_WATER_TOWER, x = 1230.556763, y = 1751.453857, z = 78.148918,
        items_out = {["water"] = PRICE_WATER}},    
    {name = BLIP_WATER_TOWER, x = -1944.531494, y = 1768.326538, z = 173.691177,
        items_out = {["water"] = PRICE_WATER}},    
    {name = BLIP_WATER_TOWER, x = 1716.599854, y = 4807.332031, z = 40.518478,
        items_out = {["water"] = PRICE_WATER}},    
    {name = BLIP_WATER_TOWER, x = 2535.609131, y = 4665.478027, z = 32.767746,
        items_out = {["water"] = PRICE_WATER}},    
}

-- Define locations where a certain cargo can be sold
local sell_locations = {
    -- Grapeseed
    {name = BLIP_GRAIN_SILOS, cargoes = CARGOES_GRAIN_SILOS, x = 2901.262939, y = 4383.528320, z = 49.474083},
    {name = BLIP_GRAIN_SILOS, cargoes = CARGOES_GRAIN_SILOS, x = 1981.933960, y = 5022.581543, z = 40.305820},
    {name = BLIP_BALE_SELLING_POINT, cargoes = CARGOES_BALE_SELLING_POINT, x = 2927.010254, y = 4633.539063, z = 47.658966},  
    {name = BLIP_FRUIT_STAND, cargoes = CARGOES_FRUIT_STAND, x = 2470.279785, y = 4445.996094, z = 33.870300},
    {name = BLIP_MARKET, cargoes = CARGOES_MARKET, x = 1697.606445, y = 4914.666992, z = 40.461475},
    -- Paleto
    {name = BLIP_GRAIN_SILOS, cargoes = CARGOES_GRAIN_SILOS, x = 411.531219, y = 6455.570313, z = 27.281033},
    {name = BLIP_BALE_SELLING_POINT, cargoes = CARGOES_BALE_SELLING_POINT, x = 437.104218, y = 6462.531250, z = 27.223034},
    {name = BLIP_FRUIT_STAND, cargoes = CARGOES_FRUIT_STAND, x = 1094.633301, y = 6509.788086, z = 19.622141},  
    -- Tongva Hills
    {name = BLIP_FRUIT_STAND, cargoes = CARGOES_FRUIT_STAND, x = -465.103149, y = 2862.012939, z = 33.116695},
    
    {name = BLIP_FRUIT_STAND, cargoes = CARGOES_FRUIT_STAND, x = 142.112808, y = 1669.372314, z = 227.502808},
    {name = BLIP_GRAIN_SILOS, cargoes = CARGOES_GRAIN_SILOS, x = 1266.349121, y = 1905.035522, z = 77.797829},
}

-- Define locations where vehicles can be spawned
local spawn_locations = {
    -- Grapeseed 
    {name = TOOL_HARVESTER, vehicle = "RAKETRAILER", trailer = true, price = PRICE_HARVESTER, x = 2511.132813, y = 4962.061523, z = 43.742363},
    {name = TOOL_HOPPER, vehicle = "GRAINTRAILER", trailer = true, price = PRICE_HOPPER, x = 2519.558105, y = 4967.581055, z = 43.679642},
    {name = TOOL_BALE_TRAILER, vehicle = "BALETRAILER", trailer = true, price = PRICE_BALE_TRAILER, x = 2514.235352, y = 4979.453125, z = 43.766724},   
    {name = TOOL_LAWN_MOWER, vehicle = "MOWER", price = PRICE_LAWN_MOWER, x = 2553.971924, y = 4669.725586, z = 32.952942}, 
    {name = TOOL_FLUID_WAGON, vehicle = "TRAILERSMALL", price = PRICE_FLUID_WAGON, x = 2823.496094, y = 4567.889648, z = 45.394455},
    -- Paleto
    {name = TOOL_HARVESTER, vehicle = "RAKETRAILER", trailer = true, price = PRICE_HARVESTER, x = 454.021667, y = 6477.916016, z = 28.189550},
    {name = TOOL_HOPPER, vehicle = "GRAINTRAILER", trailer = true, price = PRICE_HOPPER, x = 453.864624, y = 6486.758789, z = 27.833069},
    {name = TOOL_BALE_TRAILER, vehicle = "BALETRAILER", trailer = true, price = PRICE_BALE_TRAILER, x = 453.704987, y = 6494.580078, z = 27.924078},
    {name = TOOL_LAWN_MOWER, vehicle = "MOWER", price = PRICE_LAWN_MOWER, x = 408.983276, y = 6632.584473, z = 26.674208},   
}

-- Define fields with name, harvest type, price and the 4 corners (does not support other than 4 corners) [[
local fields = {
    {name = "Shiron", type = "grain", price = 16000, owned = true, edges = {
        {name = "7_1", x = 2192.007324, y = 5152.111816, z = 53.081524},
        {name = "7_2", x = 2146.202637, y = 5110.520020, z = 44.905880},
        {name = "7_3", x = 2077.471436, y = 5183.029297, z = 51.457306},
        {name = "7_4", x = 2135.808105, y = 5212.672363, z = 56.484085},
    }},
    {name = "Medulin", type = "grain", price = 16000, edges = {
        {name = "8_1", x = 2145.920654, y = 5212.295410, z = 58.043858},
        {name = "8_2", x = 2184.101563, y = 5203.614258, z = 59.696228},
        {name = "8_3", x = 2213.697754, y = 5176.185547, z = 57.659370},
        {name = "8_4", x = 2196.236084, y = 5158.368164, z = 54.771946},
    }},
    {name = "Bowley", type = "oranges", price = 24000, edges = {
        {name = "9_1", x = 2334.259033, y = 5047.617188, z = 44.360615},
        {name = "9_2", x = 2293.784912, y = 4999.906250, z = 41.727436},
        {name = "9_3", x = 2345.824951, y = 4960.709961, z = 41.498222},
        {name = "9_4", x = 2400.586182, y = 5000.390625, z = 44.989700},
    }},
    {name = "Bølle", type = "grass", price = 20000, owned = true, edges = {
        {name = "10_1", x = 2787.248779, y = 4690.698242, z = 44.754162},
        {name = "10_2", x = 2847.571777, y = 4704.364746, z = 45.992226},
        {name = "10_3", x = 2816.250000, y = 4826.945801, z = 45.524284},
        {name = "10_4", x = 2759.730957, y = 4794.828125, z = 44.265991},
    }},
    {name = "Albert", type = "grain", price = 16000, edges = {
        {name = "11_1", x = 2296.190430, y = 5171.657227, z = 58.025566},
        {name = "11_2", x = 2261.598145, y = 5136.291504, z = 53.087208},
        {name = "11_3", x = 2312.192871, y = 5086.767090, z = 45.696548},
        {name = "11_4", x = 2353.846191, y = 5115.896484, z = 47.289204},
    }},
    {name = "Snuski", type = "grass", price = 20000, edges = {
        {name = "12_1", x = 2364.106689, y = 5220.928223, z = 57.800362},
        {name = "12_2", x = 2299.700439, y = 5176.136719, z = 58.428143},
        {name = "12_3", x = 2360.239258, y = 5118.034180, z = 47.241547},
        {name = "12_4", x = 2390.686768, y = 5153.235840, z = 46.899990},
    }},
    {name = "Raptus", type = "grain", price = 16000, edges = {
        {name = "13_1", x = 2578.476563, y = 4350.118164, z = 39.095924},
        {name = "13_2", x = 2534.256104, y = 4321.751465, z = 38.126987},
        {name = "13_3", x = 2479.377441, y = 4336.269043, z = 35.012585},
        {name = "13_4", x = 2515.342773, y = 4413.957031, z = 36.014446},
    }},
    {name = "Tascha", type = "grain", price = 16000, edges = {
        {name = "14_1", x = 2683.733643, y = 4632.891113, z = 38.639214},
        {name = "14_2", x = 2667.605957, y = 4699.044922, z = 36.710915},
        {name = "14_3", x = 2621.988770, y = 4741.995605, z = 32.552135},
        {name = "14_4", x = 2594.327393, y = 4717.991211, z = 32.476959},
    }},
    {name = "Chleo", type = "grain", price = 16000, edges = {
        {name = "15_1", x = 2587.374756, y = 4799.516113, z = 32.346260},
        {name = "15_2", x = 2531.333008, y = 4852.244141, z = 35.549782},
        {name = "15_3", x = 2497.631348, y = 4818.062500, z = 33.806805},
        {name = "15_4", x = 2552.886475, y = 4767.222168, z = 31.715496},
    }},
    {name = "Kita", type = "grain", price = 16000, edges = {
        {name = "16_1", x = 2456.421387, y = 4842.656738, z = 35.287579},
        {name = "16_2", x = 2495.493896, y = 4884.305664, z = 39.010719},
        {name = "16_3", x = 2523.601807, y = 4859.268066, z = 36.403374},
        {name = "16_4", x = 2484.039063, y = 4819.207520, z = 33.212311},
    }},
    {name = "King", type = "grass", price = 20000, edges = {
        {name = "17_1", x = 2585.544922, y = 4933.264648, z = 36.537567},
        {name = "17_2", x = 2645.926758, y = 4855.537109, z = 32.390488},
        {name = "17_3", x = 2612.494141, y = 4825.999023, z = 32.777275},
        {name = "17_4", x = 2553.783447, y = 4883.111816, z = 36.359730},
    }},
    {name = "Kaisa", type = "tomatoes", price = 40000, edges = {
        {name = "20_1", x = 2799.949951, y = 4655.136230, z = 43.043346},
        {name = "20_2", x = 2817.617676, y = 4585.440430, z = 44.063778},
        {name = "20_3", x = 2836.952148, y = 4590.662598, z = 45.467594},
        {name = "20_4", x = 2820.980225, y = 4661.522949, z = 44.842407},
    }},
    {name = "Prince", type = "tomatoes", price = 40000, edges = {
        {name = "21_1", x = 2820.980225, y = 4661.522949, z = 44.842407},
        {name = "21_2", x = 2842.364746, y = 4567.578613, z = 44.992996},
        {name = "21_3", x = 2904.556885, y = 4588.137695, z = 46.393211},
        {name = "21_4", x = 2882.627197, y = 4676.471680, z = 46.677254},
    }},
    {name = "Lucky", type = "watermelons", price = 50000, edges = {
        {name = "22_1", x = 2897.645508, y = 4687.219727, z = 47.326664},
        {name = "22_2", x = 2905.128174, y = 4648.177246, z = 47.275864},
        {name = "22_3", x = 2948.450439, y = 4672.865234, z = 47.346439},
        {name = "22_4", x = 2943.722900, y = 4697.302246, z = 49.539577},
    }},
    {name = "Happy", type = "strawberries", price = 35000, edges = {
        {name = "23_1", x = 2097.002197, y = 4917.606934, z = 39.369629},
        {name = "23_2", x = 2045.625122, y = 4969.017090, z = 39.316860},
        {name = "23_3", x = 2017.314697, y = 4939.949707, z = 39.321476},
        {name = "23_4", x = 2068.403320, y = 4888.586914, z = 39.316990},
    }},
    {name = "Gould", type = "strawberries", price = 35000, edges = {
        {name = "24_1", x = 2057.864746, y = 4878.094238, z = 41.091248},
        {name = "24_2", x = 2006.668091, y = 4928.589844, z = 41.106956},
        {name = "24_3", x = 1980.257935, y = 4903.451172, z = 41.098843},
        {name = "24_4", x = 2031.480347, y = 4852.641113, z = 41.102058},
    }},
    {name = "Ridgewell", type = "peaches", price = 65000, edges = {
        {name = "25_1", x = 2112.449219, y = 4895.427246, z = 39.148209},
        {name = "25_2", x = 2048.015869, y = 4834.914551, z = 40.155876},
        {name = "25_3", x = 2072.019531, y = 4803.700684, z = 39.895584},
        {name = "25_4", x = 2152.516846, y = 4865.658691, z = 38.933643},
    }},
    -- paleto
    {name = "Collins", type = "grain", price = 20000, owned = true, edges = {
        {name = "26_1", x = 746.155701, y = 6453.724609, z = 30.962240},
        {name = "26_2", x = 755.431274, y = 6475.126953, z = 28.282267},
        {name = "26_3", x = 612.323853, y = 6503.511230, z = 27.955044},
        {name = "26_4", x = 611.648193, y = 6457.498047, z = 28.658173},
    }},
    {name = "Trouble", type = "strawberries", price = 35000, edges = {
        {name = "27_1", x = 594.746338, y = 6457.224121, z = 29.115301},
        {name = "27_2", x = 594.326843, y = 6508.812988, z = 28.397133},
        {name = "27_3", x = 549.347717, y = 6519.345703, z = 28.026365},
        {name = "27_4", x = 550.796143, y = 6457.586426, z = 29.110878},
    }},
    {name = "Captain", type = "oranges", price = 24000, edges = {
        {name = "28_1", x = 386.812958, y = 6499.264160, z = 26.600067},
        {name = "28_2", x = 382.782104, y = 6538.698242, z = 26.325069},
        {name = "28_3", x = 319.826447, y = 6538.621582, z = 27.413370},
        {name = "28_4", x = 317.931519, y = 6503.764160, z = 27.762859},
    }},
    {name = "Kane", type = "peaches", price = 65000, edges = {
        {name = "29_1", x = 288.470428, y = 6503.825684, z = 28.367973},
        {name = "29_2", x = 285.384583, y = 6535.777344, z = 28.459352},
        {name = "29_3", x = 213.743362, y = 6524.729492, z = 29.912815},
        {name = "29_4", x = 177.333893, y = 6492.048828, z = 30.069324},
    }},
    {name = "Hawaii", type = "tomatoes", price = 40000, edges = {
        {name = "30_1", x = 242.953033, y = 6430.655273, z = 29.937672},
        {name = "30_2", x = 241.273346, y = 6436.018555, z = 30.173756},
        {name = "30_3", x = 283.505432, y = 6440.380371, z = 30.367455},
        {name = "30_4", x = 285.203003, y = 6434.930176, z = 30.305744},
    }},
    {name = "Ron", type = "watermelons", price = 50000, edges = {
        {name = "31_1", x = 288.919891, y = 6446.770508, z = 30.153397},
        {name = "31_2", x = 288.283661, y = 6484.042969, z = 28.193283},
        {name = "31_3", x = 207.482620, y = 6477.367676, z = 29.849089},
        {name = "31_4", x = 232.728989, y = 6442.354492, z = 29.777508},
    }},
    {name = "Fuji", type = "tomatoes", price = 40000, edges = {
        {name = "32_1", x = 235.586411, y = 6634.180664, z = 28.298279},
        {name = "32_2", x = 292.106598, y = 6633.982422, z = 27.798309},
        {name = "32_3", x = 292.126465, y = 6665.777832, z = 27.790277},
        {name = "32_4", x = 239.678757, y = 6665.938477, z = 28.454409},
    }},
    {name = "Christmas", type = "strawberries", price = 35000, edges = {
        {name = "33_1", x = 244.027237, y = 6628.025879, z = 28.288439},
        {name = "33_2", x = 293.448273, y = 6628.312500, z = 27.622919},
        {name = "33_3", x = 294.472015, y = 6596.749512, z = 28.396990},
        {name = "33_4", x = 244.723404, y = 6596.352539, z = 28.401836},
    }},
    {name = "Tsuno", type = "grass", price = 20000, owned = true, edges = {
        {name = "34_1", x = 479.019379, y = 6578.655762, z = 25.523012},
        {name = "34_2", x = 428.137970, y = 6651.733887, z = 18.835629},
        {name = "34_3", x = 409.518707, y = 6648.832031, z = 26.293324},
        {name = "34_4", x = 427.931702, y = 6587.187988, z = 25.535105},
    }},
    -- Tongva Hills
    {name = "Taco", type = "grapes", price = 55000, edges = {
        {name = "40_1", x = -1696.812012, y = 2257.538574, z = 77.168068},
        {name = "40_2", x = -1601.704102, y = 2178.628906, z = 77.803490},
        {name = "40_3", x = -1565.554443, y = 2215.743408, z = 66.634766},
        {name = "40_4", x = -1641.349976, y = 2324.969482, z = 47.967152},
    }},
    {name = "Ace", type = "grapes", price = 55000, edges = {
		{name = "41_1", x = -1651.654053, y = 2331.015625, z = 47.927883},
		{name = "40_2", x = -1778.859985, y = 2377.889160, z = 41.446053},
		{name = "41_3", x = -1806.190552, y = 2335.065430, z = 47.345284},
		{name = "41_4", x = -1692.366455, y = 2283.382080, z = 66.060013},
    }},
    {name = "Cobra", type = "grapes", price = 55000, edges = {
		{name = "42_1", x = -1667.569702, y = 2192.266602, z = 97.405869},
		{name = "42_2", x = -1819.104370, y = 2213.196533, z = 86.729500},
		{name = "42_3", x = -1827.051270, y = 2155.126465, z = 114.003616},
		{name = "42_4", x = -1701.290771, y = 2162.318848, z = 111.126472},
    }},
    {name = "Cory", type = "grapes", price = 55000, edges = {
		{name = "43_1", x = -1682.383057, y = 2162.001465, z = 106.185966},
		{name = "43_2", x = -1783.610718, y = 2126.807129, z = 129.246521},
		{name = "43_3", x = -1853.146362, y = 2089.730469, z = 138.414612},
		{name = "43_4", x = -1820.324829, y = 2059.891602, z = 132.884933},
    }},
    {name = "Narwhal", type = "grapes", price = 55000, edges = {
		{name = "44_1", x = -1864.063110, y = 2097.086670, z = 136.858765},
		{name = "44_2", x = -1830.330322, y = 2148.153809, z = 115.114891},
		{name = "44_3", x = -1752.069824, y = 2153.164795, z = 121.226982},
		{name = "44_4", x = -1817.118042, y = 2110.085205, z = 134.826843},
    }},
    {name = "Boxie", type = "grapes", price = 55000, edges = {
		{name = "45_1", x = -1871.726563, y = 2097.854248, z = 137.618652},
		{name = "45_2", x = -1914.967285, y = 2101.174561, z = 130.854095},
		{name = "45_3", x = -1908.196899, y = 2157.922607, z = 110.876038},
		{name = "45_4", x = -1837.160645, y = 2152.427490, z = 114.347786},
    }},
    {name = "Morgan", type = "grapes", price = 55000, edges = {
		{name = "46_1", x = -1834.806763, y = 2212.802002, z = 85.505241},
		{name = "46_2", x = -1835.605835, y = 2168.446777, z = 109.598495},
		{name = "46_3", x = -1899.528076, y = 2180.763184, z = 102.680740},
		{name = "46_4", x = -1901.141479, y = 2226.587402, z = 82.229233},
    }},
    {name = "Phantom", type = "grapes", price = 55000, edges = {
		{name = "47_1", x = -1901.625977, y = 2237.345459, z = 80.418304},
		{name = "47_2", x = -1897.843506, y = 2278.286865, z = 64.014420},
		{name = "47_3", x = -1827.482544, y = 2269.680176, z = 70.474098},
		{name = "47_4", x = -1833.268799, y = 2226.873535, z = 82.440681},
    }},
    {name = "Gaming", type = "grapes", price = 55000, edges = {
		{name = "48_1", x = -1742.221313, y = 2231.600098, z = 90.435120},
		{name = "48_2", x = -1747.397583, y = 2270.238281, z = 79.862312},
		{name = "48_3", x = -1813.312134, y = 2264.967285, z = 69.850807},
		{name = "48_4", x = -1825.777832, y = 2232.749756, z = 79.757187},
    }},
    {name = "2D", type = "grapes", price = 55000, edges = {
		{name = "49_1", x = -1739.515991, y = 1973.880127, z = 118.727608},
		{name = "49_2", x = -1697.831787, y = 1915.242310, z = 147.731949},
		{name = "49_3", x = -1685.545288, y = 2038.401367, z = 109.383354},
		{name = "49_4", x = -1720.279663, y = 2033.198364, z = 110.498039},
    }},
    {name = "Jetsam", type = "grapes", price = 55000, edges = {
		{name = "50_1", x = -1753.303955, y = 1980.434570, z = 117.105522},
		{name = "50_2", x = -1788.495850, y = 1922.980957, z = 132.552765},
		{name = "50_3", x = -1771.605957, y = 1886.065430, z = 148.582657},
		{name = "50_4", x = -1705.203003, y = 1892.806030, z = 157.503891},
    }},
    {name = "Gordon", type = "grapes", price = 55000, edges = {
		{name = "51_1", x = -1841.329224, y = 1896.125854, z = 144.563126},
		{name = "51_2", x = -1851.205322, y = 1921.992065, z = 149.314270},
		{name = "51_3", x = -1935.080200, y = 1884.566162, z = 177.795700},
		{name = "51_4", x = -1948.160522, y = 1822.901733, z = 171.830490},
    }},
    {name = "Grapey", type = "grapes", price = 55000, edges = {
		{name = "52_1", x = -1933.780029, y = 1896.171021, z = 176.520309},
		{name = "52_2", x = -1857.451904, y = 1932.029053, z = 148.465179},
		{name = "52_3", x = -1912.355225, y = 1969.169556, z = 145.414352},
		{name = "52_4", x = -1986.698730, y = 1951.595093, z = 164.702225},
    }},
    {name = "Regret", type = "oranges", price = 24000, edges = {
		{name = "53_1", x = -1726.342041, y = 2033.300049, z = 110.351540},
		{name = "53_2", x = -1809.585938, y = 1941.666382, z = 131.101776},
		{name = "53_3", x = -1869.243408, y = 2008.357300, z = 138.472672},
		{name = "53_4", x = -1771.253052, y = 2043.901489, z = 121.912819},
    }},
    -- Weed farms
    {name = "Dogg", type = "weed", price = 120000, edges = {
        {name = "420_1", x = 2213.145996, y = 5581.434082, z = 52.859135},
        {name = "420_2", x = 2212.411133, y = 5574.242676, z = 52.611462},
        {name = "420_3", x = 2236.117676, y = 5573.087402, z = 52.760529},
        {name = "420_4", x = 2236.133301, y = 5579.257324, z = 52.970051},
    }},
    -- Debug shit xd
    {name = "LSIA Runway 3/21", type = "runway", price = 0, edges = {
        {name = "LSIA_3_1", x = -1341.159790, y = -2187.330078, z = 12.461301},
        {name = "LSIA_3_2", x = -1312.265747, y = -2203.026123, z = 12.464062},
        {name = "LSIA_3_3", x = -1634.533081, y = -2760.738525, z = 12.463830},
        {name = "LSIA_3_4", x = -1663.659424, y = -2744.076660, z = 12.460426},
    }}, 
    {name = "LSIA Runway 12L/30R", type = "runway", price = 0, edges = {
        {name = "LSIA_12L_1", x = -1548.526733, y = -2809.419678, z = 12.469567},
        {name = "LSIA_12L_2", x = -926.055237, y = -3168.601318, z = 12.463780},
        {name = "LSIA_12L_3", x = -939.313660, y = -3194.502686, z = 12.460674},
        {name = "LSIA_12L_4", x = -1562.951050, y = -2835.349854, z = 12.469537},
    }},
    {name = "LSIA Runway 12R/30L", type = "runway", price = 0, edges = {
        {name = "LSIA_12R_1", x = -1638.893433, y = -2952.237549, z = 12.464379},
        {name = "LSIA_12R_2", x = -1003.904846, y = -3318.100830, z = 12.460719},
        {name = "LSIA_12R_3", x = -1018.369019, y = -3343.975586, z = 12.465767},
        {name = "LSIA_12R_4", x = -1652.547974, y = -2977.354004, z = 12.464422},
    }},
    {name = "Debug Beach", type = "sand", price = 0, edges = {
        {name = "b_4", x = 1740.910889, y = 4511.376465, z = 29.805069},
        {name = "b_5", x = 1704.964233, y = 4481.241699, z = 29.559341},
        {name = "b_6", x = 1654.167969, y = 4483.950684, z = 29.413467},
        {name = "b_7", x = 1623.037231, y = 4525.418457, z = 35.626041},
        {name = "b_8", x = 1637.107422, y = 4539.205566, z = 39.621109},
        {name = "b_9", x = 1669.346802, y = 4554.993652, z = 40.513874},
        {name = "b_10", x = 1743.230225, y = 4559.852051, z = 36.950420},
        {name = "b_11", x = 1803.406494, y = 4561.553223, z = 34.486012},
        {name = "b_1", x = 1809.392456, y = 4536.697266, z = 30.568882},
        {name = "b_2", x = 1802.627686, y = 4512.767090, z = 29.279793},
        {name = "b_3", x = 1768.004272, y = 4501.897461, z = 29.300922},
    }},
}

-- CONFIG END --

local F = string.format

-- Initialized tables
local current_job = {}
local vehicle_storage = {}
local dropped_cargo = {}
local prev_veh = ""
local prev_field = ""
local cooldown = 0

--[[
    FIELD DETECTION
]]
-- Checks if point is within a triange. https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
function isPointInTriangle(p, p0, p1, p2)
    local A = 1/2 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y)
    local sign = 1
    if A < 0 then sign = -1 end
    local s = (p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y) * sign
    local t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign
    
    return s > 0 and t > 0 and (s + t) < 2 * A * sign
end

function runOnFieldTriangles(field, cb)
    local edges = field.edges
    local num = #edges - 2
    local c = 1
    repeat 
        cb(edges[1], edges[c+1], edges[c+2])
        c = c + 1
    until c > num
end

-- Checks if a point is within a Field structure
function isPointInField(p, field)
    local edges = field.edges
    local within = false
    runOnFieldTriangles(field, function(p0,p1,p2)
        if isPointInTriangle(p, p0, p1, p2) then within = true end
    end)
    return within
end

function GetAreaOfField(field)
    local edges = field.edges
    return math.floor(getAreaOfTriangle(edges[1], edges[2], edges[3]) + getAreaOfTriangle(edges[1], edges[4], edges[3]))
end

function getAreaOfTriangle(p0, p1, p2)
    local b = GetDistanceBetweenCoords(p0.x, p0.y, 0, p1.x, p1.y, 0)
    local h = GetDistanceBetweenCoords(p2.x, p2.y, 0, p1.x, p1.y, 0)
    return (b * h) / 2
end

--[[
    TEXT STUFF
]]
local _frameString = ""

-- Add a line of text to the current frame
function addText(text)
    _frameString = _frameString .. "~n~~w~" .. text 
end

-- Draw a block of text for the current frame
function drawText(text)
    if text == "" then return end
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text .. "~n~~n~~n~")
    Citizen.InvokeNative(0x9D77056A530643F6, 200, true)
end

-- Draw a block of text that stays for 20 seconds
function drawMessage(text)
    Citizen.InvokeNative(0xB87A37EEB7FAA67D,"STRING")
    AddTextComponentString(text)
    Citizen.InvokeNative(0x9D77056A530643F6, 20000, false)
end

--[[
    MISC
]]

-- Draws a marker at x y z with optional colors r g b and size s
function drawMarker(x,y,z, r,g,b, s)
    s = s or 3
    DrawMarker(1, x, y, z, 0,0,0,0,0,0,s * 1.0,s * 1.0,3.0,r or 0,g or 155,b or 255,100,0,0,0,0)
end

-- Convert a Vector3 to a pure format vector (it has the same structure, just not a Vector3 object)
function vec3(vec)
    return {x = vec.x, y = vec.y, z = vec.z} 
end

-- Request and load a model in one function
function reqModel(model) 
    model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(5) end
    return model
end

function SetBlipName(blip, name)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip) 
end

function ShowHint(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterNetEvent("gd_farm:notify")
AddEventHandler("gd_farm:notify", function(hint)
    ShowHint(hint)
end)

--[[
    CARGO STUFF
]]

RegisterNetEvent("gd_farm:create_material")
AddEventHandler("gd_farm:create_material", function(cargo, amount, pos)
    table.insert(dropped_cargo, {type = cargo, amount = amount, pos = pos})
end)

function GetVehicle(veh)
    return vehicles[veh]
end

function GetVehicleCapacity(veh,cargo)
    if vehicles[veh] == nil then return 0 end
    if vehicles[veh].cargoes[cargo] == nil then return 0 end
    return vehicles[veh].cargoes[cargo].capacity or 0
end

-- Get the current stored amount of cargo in vehicle veh
function GetStorage(veh, cargo)
    if veh == nil or cargo == nil then return 0 end
    if type(veh) ~= 'string' then veh = GetDisplayNameFromVehicleModel(GetEntityModel(veh)) end
    if vehicle_storage[veh] == nil then
        vehicle_storage[veh] = {}
    end
    if vehicle_storage[veh][cargo] == nil then
        vehicle_storage[veh][cargo] = 0
    end
    return vehicle_storage[veh][cargo] or 0
end

function GetCargo(cargo)
    return cargo_types[cargo] or {name = "???", r = 0, g = 0, b = 0} 
end

-- Returns the visual name of the cargo type (grain = "Grain" etc)
function GetCargoName(cargo)
    return GetCargo(cargo).name or "???" 
end

-- Try to put amount cargo in storage of veh
function AddStorage(veh, cargo, amount)
    local _v = GetVehicle(veh)
    local capacity = GetVehicleCapacity(veh, cargo)
    local cur = GetStorage(veh, cargo)
    local after = cur + amount
    local _r = true
    
    if after > capacity then 
        amount = math.abs(capacity - cur)
        _r = false
    end
    SetStorage(veh, cargo, cur + amount)
    return amount, _r -- _r signals that it didn't add all of it
end

-- Set the current storage amount of cargo in veh
function SetStorage(veh, cargo, amount)
    if type(veh) ~= 'string' then veh = GetDisplayNameFromVehicleModel(GetEntityModel(veh)) end
    vehicle_storage[veh][cargo] = math.min(amount, GetVehicleCapacity(veh, cargo))
end

-- Create a dropped resource of cargo with amount units at pos
function DropMaterial(cargo, amount, pos)
    TriggerServerEvent("gd_farm:drop_material", cargo, amount, vec3(pos))
end

function SellMaterial(material, amount)
    TriggerServerEvent("gd_farm:sell_material", material, amount)     
end

function PurchaseField(field)
    -- ADD STUFF TO DEAL WITH COST LATER
    field.owned = true
    ShowHint(HINT_BUY_FIELD_PROMO)
    updateJobBlips()
end

--[[
    DEBUG SHIT
]]

function debugDrawFieldMarkers(field, r, g, b, a)
    local v = field
    runOnFieldTriangles(v, function(p0,p1,p2) 
        DrawLine(p0.x, p0.y, p0.z + 3.0,
                 p1.x, p1.y, p1.z + 3.0,
            r or 255, g or 0, b or 0, a or 255)
        DrawLine(p2.x, p2.y, p2.z + 3.0,
                 p1.x, p1.y, p1.z + 3.0,
            r or 255, g or 0, b or 0, a or 255)
        DrawLine(p2.x, p2.y, p2.z + 3.0,
                 p0.x, p0.y, p0.z + 3.0,
            r or 255, g or 0, b or 0, a or 255)
    end)
end

RegisterNetEvent("gd_farm:debug_toggle")
AddEventHandler("gd_farm:debug_toggle", function() 
    if OnCooldown() then return end
    Cooldown()
    debug = not debug
    if debug then
        ShowHint("~y~Farming Notice~w~~n~Debug ~g~enabled")
    else
        ShowHint("~y~Farming Notice~w~~n~Debug ~r~disabled")
    end
end)

--[[
    MAIN CLIENT LOOP
]]

Citizen.CreateThread(
    function()
        print("gd_farm/client/main.lua init")
        
        -- Add permanent map blips
        for k,v in next, map_blips do
            local blip = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipAsShortRange(blip, true)
            SetBlipSprite(blip, v.blipid)
            SetBlipColour(blip, v.blipcol)
            SetBlipName(blip, v.name)
        end
        if debug then startJob() end
        
        -- Main Loop
        while true do
            Citizen.Wait(0)  
            local ply = GetPlayerPed(-1)
            local pos = GetEntityCoords(ply)
            if cooldown >= 0 then cooldown = cooldown - 1 end
            -- Run job loop
            if next(current_job) ~= nil then 
                -- On job
                mainLoop() 
            else
                -- Not on job
                for k,v in next, job_starts do
                    drawMarker(v.x, v.y, v.z)
                    if GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z) <= 3.0 then
                        drawText(PROMPT_START_JOB) 
                        if IsControlJustPressed(1, 38) then -- E
                            TriggerServerEvent("gd_farm:request_job_start")
                        end
                    end
                end
            end
        end
    end
)

-- Ran when on job
function mainLoop()
    _frameString = ""
    local current_field = nil
    local ply = GetPlayerPed(-1)
    local pos = GetEntityCoords(ply)
    if IsPedInAnyVehicle(ply) then pos = GetEntityCoords(GetVehiclePedIsIn(ply, false)) end

    -- Detect what field the player is in
    for k,v in next, fields do
        if GetDistanceBetweenCoords(v.edges[1].x, v.edges[1].y,0,pos.x,pos.y,0) <= 500.0 then
            -- Draw debug lines around all fields
            if debug then 
                if v.owned then 
                    debugDrawFieldMarkers(v,0,255) -- Green lines
                else
                    debugDrawFieldMarkers(v) -- Red lines
                end
            end
            if isPointInField(pos, v) then
                -- Draw a faint debug line around the current field if not already in debug
                if not debug then debugDrawFieldMarkers(v,255,255,255,20) end
                if v.owned then
                    addText(F(TEXT_FIELD_CURRENT, v.name, GetCargoName(v.type))) -- 
                    current_field = v
                else
                    if v.price == 0 then
                        if prev_field ~= k then ShowHint(F(HINT_BUY_FIELD_LOCKED, v.name, GetAreaOfField(v), GetCargoName(v.type))) end
                        addText(F(TEXT_FIELD_NOT_FOR_SALE, v.name))
                    else
                        if prev_field ~= k then ShowHint(F(HINT_BUY_FIELD, v.name, v.price, GetAreaOfField(v), GetCargoName(v.type))) end
                        addText(F(TEXT_BUY_FIELD, v.name, v.price))
                        if IsControlJustPressed(1, 38) and not OnCooldown() then -- E
                            Cooldown()
                            TryPurchaseField(v)
                        end
                    end
                end
                prev_field = k
            end
        end
    end

    -- Draw markers for dropped cargo
    for k,v in next, dropped_cargo do
        local c = GetCargo(v.type)
        local p,r,g,b = v.pos, c.r, c.g, c.b;
        local dist = GetDistanceBetweenCoords(p.x, p.y, p.z, pos.x, pos.y, pos.z, false)
        if dist < 50.0 then 
            local size = math.max(v.amount / 2000, 1.0)
            drawMarker(p.x, p.y, p.z - 1.0, r, g, b, size)
            if dist < 2.0 and not IsPedInAnyVehicle(ply) then addText(F(TEXT_DROPPED_CARGO, c.name, v.amount)) end
        end
        if v.amount <= 0 then table.remove(dropped_cargo, k) end
    end

    if IsPedInAnyVehicle(ply) then
        local veh = GetVehiclePedIsIn(ply, false)
        if IsVehicleAttachedToTrailer(veh) then 
            _, veh = GetVehicleTrailerVehicle(veh) 
            pos = GetEntityCoords(veh)
        end
        local vehModel = GetEntityModel(veh)   
        for k,v in next, vehicles do
            if vehModel == GetHashKey(k) then
                
                -- Show vehicle hint
                if prev_veh ~= k and v.hint then
                     ShowHint(F(HINT_VEHICLE_CONTROLS, v.hint))
                end
                prev_veh = k
                
                -- Run vehicle functions
                if v.enabled then
                    if v.infield ~= nil and current_field ~= nil then v.infield(veh, current_field, v.cargoes) end
                    if v.always ~= nil then v.always(veh) end
                end

                -- Add a prefix with vehicle feature mode
                local pref = COLOR_PREFIX_VEHICLE_NEUTRAL
                if v.toggleable then
                    if v.enabled then pref = COLOR_PREFIX_VEHICLE_ON .. "(" .. v.on .. ") " else pref = COLOR_PREFIX_VEHICLE_OFF .. "(" .. v.off .. ") " end
                end

                -- Toggleable Features using G
                if IsControlJustPressed(1, 47) then
                    v.enabled = not v.enabled
                end

                -- Draw vehicle load stats
                addText(F(TEXT_VEHICLE_NAME, pref, v.name))
                for _k,_v in next, v.cargoes do
                    local c = GetStorage(k, _k)

                    -- Draw cargo amount
                    if c and c > 0 then
                        addText(F(TEXT_CARGO_AMOUNT, GetCargoName(_k), c, _v.capacity)) 
                    end

                    -- Extras (bales on trailer etc)
                    if _v.extra ~= nil then
                        local b = (GetStorage(k, _k) <= 0)
                        SetVehicleExtra(veh, _v.extra, b)
                    end

                    -- Autopickup
                    if _v.autopickup and c <= _v.capacity and v.enabled then
                        for __k,__v in next, dropped_cargo do
                            local __c = GetCargo(__v.type)
                            local __p = __v.pos
                            if GetDistanceBetweenCoords(__p.x, __p.y, __p.z, pos.x, pos.y, pos.z, false) < 2.0 then 
                                local amount, __b = AddStorage(k, __v.type, math.min(__v.amount, 10))
                                __v.amount = __v.amount - amount
                            end
                        end
                    end

                    -- Autodump feature
                    if (_v.autodump and c >= _v.capacity and v.enabled) then
                        SetStorage(k, _k, 0)
                        local x,y,z = pos.x + GetEntityForwardX(veh)*-2.0,pos.y + GetEntityForwardY(veh)*-2.0,pos.z
                        DropMaterial(_k, c, {x=x,y=y,z=z})
                    end

                    -- Manual dump using B
                    if IsControlJustPressed(1, 29) then
                        SetStorage(k, _k, 0)
                        local x,y,z = pos.x + GetEntityForwardX(veh)*-5.0,pos.y + GetEntityForwardY(veh)*-5.0,pos.z
                        DropMaterial(_k, c, {x=x,y=y,z=z})
                    end
                    
                    -- Sell operation
                    for _shopKey, _shop in next, sell_locations do
                        if GetDistanceBetweenCoords(_shop.x, _shop.y, _shop.z, pos.x, pos.y, pos.z) <= 5.0 then
                            for _shopCargoKey, _shopCargo in next, _shop.cargoes do
                                if _shopCargo == _k then
                                    local _storage = GetStorage(k, _shopCargo)
                                    if _storage <= 0 or _storage == nil then break end
                                        SellMaterial(_shopCargo, _storage)
                                        SetStorage(k, _shopCargo, 0)
                                    break
                                end
                            end
                        end
                    end 
                    
                    -- Transformer Operations
                    for _tk, _tv in next, transformers do
                        if GetDistanceBetweenCoords(_tv.x, _tv.y, _tv.z, pos.x, pos.y, pos.z) <= 5.0 then
                            for _tck, _tcv in next, _tv.items_in do
                                if _tck == _k then
                                    local _storage = GetStorage(k, _tck)
                                    if _storage < _tcv or _storage == nil then break end
                                        SetStorage(k, _tck, _storage - _tcv)
                                        for _dropmatk, _dropmatv in next, _tv.items_out do
                                            DropMaterial(_dropmatk, _dropmatv, _tv)
                                        end
                                    break
                                end
                            end
                        end
                    end 
                end
            end
        end
    end
    drawText(_frameString)
    
    -- Iterate all locations defined where you can spawn vehicles
    for k,v in next, spawn_locations do
        v.cooldown = v.cooldown or 0 -- if cooldown is not set make it 0
        v.cooldown = math.max(0, v.cooldown - 1)
        if v.cooldown <= 0 then
            drawMarker(v.x, v.y, v.z)
            if GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z) <= 3.0 then
                drawText(F(PROMPT_SPAWN_VEHICLE, v.name))
                if IsControlJustPressed(1, 38) then -- E
                    v.cooldown = 2000
                    reqModel(v.vehicle)
                    if v.trailer then
                        -- Spawn Trailers with offset
                        CreateVehicle(v.vehicle, pos.x + GetEntityForwardX(ply) * -5.0, pos.y + GetEntityForwardY(ply) * -5.0, pos.z, GetEntityHeading(ply), true, false)
                    else
                        local _veh = CreateVehicle(v.vehicle, pos.x, pos.y, pos.z, GetEntityHeading(ply), true, false)
                        SetPedIntoVehicle(ply, _veh, -1)
                    end
                end
            end
        end
    end
    
    for k, v in next, sell_locations do
        if GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z) <= 100.0 then
            drawMarker(v.x, v.y, v.z)
        end
    end
    
    for k, v in next, transformers do
        if GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z) <= 100.0 then
            drawMarker(v.x, v.y, v.z)
        end
    end
    
    -- Debug spawn of items
    if IsControlJustPressed(1, 26) and IsControlPressed(1, 45) and debug then
        DropMaterial("grass", 2000, pos)
        DropMaterial("bales", 4, pos)
        DropMaterial("grain", 2000, pos)
        DropMaterial("oranges", 2000, pos)
        DropMaterial("strawberries", 2000, pos)
    end
    if IsControlJustPressed(1, 45) and IsControlPressed(1, 26) and debug then
        TriggerEvent("gd_farm:debug_toggle")
    end
    
end

function updateJobBlips()
    if not current_job.blips then return end
    for k,v in next, current_job.blips do
        RemoveBlip(v)
    end
    current_job.blips = {}
    
    for k,v in next, fields do
        local xx,yy = 0
        xx = v.edges[1].x + (v.edges[3].x - v.edges[1].x) / 2
        yy = v.edges[1].y + (v.edges[3].y - v.edges[1].y) / 2
        local bd = {name = BLIP_FIELD_OWNED, x = xx, y = yy}
        if v.owned then
            addJobBlip(bd, 164, 25)
        else
            if v.price == 0 then
                bd.name = BLIP_FIELD_LOCKED
                addJobBlip(bd, 163, 21)
            else
                bd.name = BLIP_FIELD_PURCHASABLE
                addJobBlip(bd, 163, 10)
            end
        end
    end
    for k,v in next, sell_locations do
        addJobBlip(v, 431, 5)
    end
    for k,v in next, buy_locations do
        addJobBlip(v, 466, 5)
    end
    for k,v in next, animal_locations do
        addJobBlip(v, 468, 25)
    end
    for k,v in next, transformers do
        addJobBlip(v, 467, 5)
    end
    for k,v in next, spawn_locations do
        local col = 21
        if not v.owned then col = 10 end
        addJobBlip(v, 479, col)
    end
end

function addJobBlip(blipdata, sprite, colour)
    local v = blipdata
    local blip = AddBlipForCoord(v.x,v.y,0)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipName(blip, v.name)
    SetBlipAsShortRange(blip, true)
    table.insert(current_job.blips, blip)
end

RegisterNetEvent("gd_farm:start_job")
AddEventHandler("gd_farm:start_job", function() startJob() end)

RegisterNetEvent("gd_farm:set_owned_fields")
AddEventHandler("gd_farm:set_owned_fields", function(namelist) 
    print("[gd_farm FIELDS]" .. namelist)
    local fieldnames = namelist:split("|")
    for k,v in next, fieldnames do
        for fid,fv in next, fields do
            if fv.name == v then
                fv.owned = true
            end
        end
    end
    updateJobBlips()
end)

function startJob()
    if next(current_job) ~= nil then return end
    current_job.name = "Farmer"
    current_job.blips = {}
    updateJobBlips()
end

function TryPurchaseField(field)
    print("Attempting purchase")
    TriggerServerEvent("gd_farm:request_buy_field", field)
end

function Cooldown()
    cooldown = 100 
end

function OnCooldown()
    return cooldown > 0
end

function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end
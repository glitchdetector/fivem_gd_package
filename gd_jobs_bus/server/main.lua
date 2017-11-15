RegisterServerEvent("gd_jobs_bus:tryStartJob")
AddEventHandler("gd_jobs_bus:tryStartJob", function(location, tier)
     -- Do all the shit about asking if energy is enough etc
    
    -- IF PLAYER IS NOT HIGH ENOUGH LEVEL FOR TIER
        -- Show message
    -- ELSE IF PLAYER DOES NOT HAVE ENERGY
        -- Show message
    -- ELSE
        -- Start job
        TriggerClientEvent("gd_jobs_bus:startJob", source, location, tier)
    -- END
end)

RegisterServerEvent("gd_jobs_bus:finishJob")
AddEventHandler("gd_jobs_bus:finishJob", function(total_fares, payment, tier)
     -- Give bonus money based on distance
    -- distance: length of entire job
    -- payment: cargo value multiplier
    -- tier: job tier
    local pay = (150 * payment) * tier
    local money = math.floor((total_fares * pay) / 10)
    TriggerClientEvent("chatMessage", source, "Bonus ^2$" .. money .. " ^0from ^3" .. total_fares .. " fares")
    -- give xp and whatever
end)

RegisterServerEvent("gd_jobs_bus:pickupJob")
AddEventHandler("gd_jobs_bus:pickupJob", function(fares, payment, tier)
     -- Give money based on distance
    -- distance: length from previous pickup point
    -- payment: cargo value multiplier
    -- tier: job tier
    local pay = (150 * payment) * tier
    local money = math.floor(fares * pay)
    TriggerClientEvent("chatMessage", source, "^0Received ^2$" .. money .. " ^0from ^3" .. fares .. " fares")
    -- give xp and whatever
end)

AddEventHandler("chatMessage",function(source,name,msg)
	if msg:sub(1,4) == "/pos" then
		TriggerClientEvent("gd:pos",source,msg)
		CancelEvent()
	end
end)

RegisterServerEvent("gd:pos")
AddEventHandler("gd:pos", function(text, pos)
    local name = text:sub(6)
    local str = string.format('{name = "%s", x = %f, y = %f, z = %f},', name, pos.x, pos.y, pos.z)
    print(str)
    local file = io.open("markers.dev", "a+")
    file:write(str .. "\n")
    file:close()
end)
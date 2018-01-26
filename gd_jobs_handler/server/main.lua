RegisterServerEvent("gd_jobs_handler:tryStartJob")
AddEventHandler("gd_jobs_handler:tryStartJob", function(location, tier)
     -- Do all the shit about asking if energy is enough etc

    -- IF PLAYER IS NOT HIGH ENOUGH LEVEL FOR TIER
        -- Show message
    -- ELSE IF PLAYER DOES NOT HAVE ENERGY
        -- Show message
    -- ELSE
        -- Start job
        TriggerClientEvent("gd_jobs_handler:startJob", source, location, tier)
    -- END
end)

RegisterServerEvent("gd_jobs_handler:finishJob")
AddEventHandler("gd_jobs_handler:finishJob", function(payment)
     -- Give bonus money based on distance
    -- distance: length of entire job
    -- payment: cargo value multiplier
    -- tier: job tier
    local pay = payment
    local money = payment * 1
    TriggerClientEvent("chatMessage", source, "Bonus ^2$" .. money .. " ^0from ^3" .. total_fares .. " fares")
    -- give xp and whatever
end)

RegisterServerEvent("gd_jobs_handler:pickupJob")
AddEventHandler("gd_jobs_handler:pickupJob", function(fares, payment, tier)
     -- Give money based on distance
    -- distance: length from previous pickup point
    -- payment: cargo value multiplier
    -- tier: job tier
    local pay = (150 * payment) * tier
    local money = math.floor(fares * pay)
    TriggerClientEvent("chatMessage", source, "^0Received ^2$" .. money .. " ^0from ^3" .. fares .. " fares")
    -- give xp and whatever
end)

RegisterServerEvent("gd_jobs_helicopter:tryStartJob")
AddEventHandler("gd_jobs_helicopter:tryStartJob", function(location, tier)
     -- Do all the shit about asking if energy is enough etc
    
    -- IF PLAYER IS NOT HIGH ENOUGH LEVEL FOR TIER
        -- Show message
    -- ELSE IF PLAYER DOES NOT HAVE ENERGY
        -- Show message
    -- ELSE
        -- Start job
        TriggerClientEvent("gd_jobs_helicopter:startJob", source, location, tier)
    -- END
end)

RegisterServerEvent("gd_jobs_helicopter:finishJob")
AddEventHandler("gd_jobs_helicopter:finishJob", function(distance, payment, tier)
     -- Give bonus money based on distance
    -- distance: length of entire job
    -- payment: cargo value multiplier
    -- tier: job tier
    local money = math.floor(((distance / 2) * (((payment - 1) + tier) / 2)) / 10)
    TriggerClientEvent("chatMessage", source, "^Bonus ^2$" .. money)
    -- give xp and whatever
end)

RegisterServerEvent("gd_jobs_helicopter:pickupJob")
AddEventHandler("gd_jobs_helicopter:pickupJob", function(distance, payment, tier)
     -- Give money based on distance
    -- distance: length from previous pickup point
    -- payment: cargo value multiplier
    -- tier: job tier
    local money = math.floor(distance * (((payment - 1) + tier) / 2))
    TriggerClientEvent("chatMessage", source, "^0Received ^2$" .. money)
    -- give xp and whatever
end)
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
    TriggerClientEvent("chatMessage", source, "Payment: ^3$" .. money)
    -- give xp and whatever
end)

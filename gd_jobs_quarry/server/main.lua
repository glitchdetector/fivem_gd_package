RegisterServerEvent("gd_jobs_quarry:tryStartJob")
AddEventHandler("gd_jobs_quarry:tryStartJob", function()
     -- Do all the shit about asking if energy is enough etc
    
    TriggerClientEvent("gd_jobs_quarry:startJob", source)
end)

RegisterServerEvent("gd_jobs_quarry:finishJob")
AddEventHandler("gd_jobs_quarry:finishJob", function(distance)
     -- Give money based on distance
    local money = math.floor(distance * 1.5)
    TriggerClientEvent("chatMessage", source, "^0Received ^2$" .. money)
    -- give xp and whatever
    TriggerClientEvent("chatMessage", source, "^0Earned ^185 xp")
end)
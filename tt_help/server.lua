RegisterCommand("help", function(source, args, rawCommand)
    TriggerClientEvent("tt_help:open", source)
end, false)
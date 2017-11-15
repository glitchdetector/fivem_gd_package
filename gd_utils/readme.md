TYPES OF MESSAGES: (name* means its optional)
message (Stock message with title and text)
	title
	text
	time*
overlay (Message with title and two lines of text)
	title
	line1
	line2
	time*
oneliner (One line of text with a dark background)
	text
	time*
popup
	title
	message
	time*
news (Weasel News breaking news reel)
	title
	bottomline
	topline
	time*
stats (Used for vehicle stats but can do other things, only works with 4 stat points!!)
	title
	message
	icontxd
	iconname
	{StatNames}(4)
	{StatValues}(4)
	time*
pedstats (The same as the stats but uses the players ped as an icon)
	title
	message
	{StatNames}(4)
	{StatValues}(4)
	time*
	
sfx_alert (Audible alert 1-6)
	alertno*
over_vehicle
	toggle*
	
Sample:
	TriggerClientEvent("gd_utils:message", -1, "PSA from Staff", "This is a sample PSA. Everyone should see this.")

SFX Alerts:
	Accepts 1-6
	No argument will make a default alert sound
	4 is the wasted sound effect
	
Over Vehicle Mode:
	To make the item appear over the LAST VEHICLE the player was in (aka the current),
	first, trigger the message/item, then use the event over_vehicle with the toggle parameter set to true.
	Example:
		TriggerClientEvent("gd_utils:message", -1, "PSA from Staff", "This is a sample PSA. Everyone should see this.")
		TriggerClientEvent("gd_utils:over_vehicle", -1, true)
	
Stats:
	To use the STATS, it needs 4 different stats to show. It will not work with less or more than 4.
	Example:
		TriggerClientEvent("gd_utils:stats", source, "Transport Tycoon ID Card", "Player: " .. GetPlayerName(source), "mpcharselect", "mp_generic_avatar", {"my", "name", "jeff", "xd"}, {32, 75, 12, 44})
	or
		TriggerClientEvent("gd_utils:pedstats", source, "Transport Tycoon ID Card", "Player: " .. GetPlayerName(source), {"my", "name", "jeff", "xd"}, {32, 75, 12, 44})
	
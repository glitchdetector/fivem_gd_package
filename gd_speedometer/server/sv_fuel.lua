RegisterServerEvent("gdf:getVehicleFuel");

local vehicleFuel = {};

function vehicleExists(veh) {
	return (type(vehicleFuel[veh]) ~= nil);
}

AddEventHandler("gdf:getVehicleFuel", function(vehicle, callback)
	if not vehicleExists(vehicle) then
		vehicleFuel[vehicle] = 65;
		callback(vehicleFuel[vehicle]);
	else
		callback(vehicleFuel[vehicle]);
	end
end);

AddEventHandler("gfd:setVehicleFuel", function(vehicle, fuel)
	vehicleFuel[vehicle] = fuel;
end);
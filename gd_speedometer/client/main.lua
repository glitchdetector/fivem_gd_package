
-- Don't mind me, I'm just touchy. -- glitchdetector
function GetVehHealthPercent() -- Thanks hbkz0r
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1);
		
		playerPed = GetPlayerPed(-1)
		if playerPed then
			playerCar = IsPedInAnyVehicle(playerPed, false)
			if playerCar then
				playerCar = GetVehiclePedIsIn(playerPed, false);
				carSpeed = GetEntitySpeed(playerCar);
				--speed = math.ceil(carSpeed * 3.6)
				speed = math.floor(carSpeed * 2.236936)
				fuel = GetVehHealthPercent();
				SendNUIMessage({
					showSpeed = true,
					setSpeed = true,
					speed = speed,
					setFuel = true,
					fuel = fuel
				})
			else
				SendNUIMessage({hideSpeed = true})
			end
		end
	end
end);
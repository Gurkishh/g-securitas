ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100);

        ESX = exports["es_extended"]:getSharedObject()  
    end 

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end 
end)

RegisterNetEvent("g-vaktare:dragPlayer")
AddEventHandler("g-vaktare:dragPlayer", function(source)
	cachedData["isDragged"] = not cachedData["isDragged"]
	cachedData["drag-copId"] = source
	while true do
		local sleepThread, player = 200, PlayerPedId()

		if cachedData["isDragged"] then
			sleepThread = 5 

			targetPed = GetPlayerPed(GetPlayerFromServerId(cachedData["drag-copId"]))

			if not IsPedSittingInAnyVehicle(player) then

				AttachEntityToEntity(player, targetPed, 11816, 0.20, 0.58, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true) 
			else
				ClearPedTasks(targetPed)
				cachedData["isDragged"] = false
				DetachEntity(player, true, false) 
			end

			if IsPedDeadOrDying(targetPed, true) then
				cachedData["isDragged"] = false
				DetachEntity(player, true, false)
			end

		else
			ClearPedTasks(targetPed)
			DetachEntity(player, true, false)
			break
		end
		if IsEntityAttached(player) and GetEntitySpeed(targetPed) == 0.0 then
			exports['g-tools']:PlayAnimation({
				Ped = player,
				Dict = 'mp_arresting',
				Lib = 'idle',
				Flag = 1
			})
		end

		if IsEntityAttached(player) and GetEntitySpeed(targetPed) >= 1.5 then
			exports['g-tools']:PlayAnimation({
				Ped = player,
				Dict = 'mp_arresting',
				Lib = 'walk',
				Flag = 1
			})
		end

		Citizen.Wait(sleepThread)
	end
end)   

RegisterNetEvent('CloseInventory')
AddEventHandler('CloseInventory', function()
    if CurrentStorage then
        exports["evrp_inventory"]:CloseUniqueTab(CurrentStorage);

        CurrentStorage = nil
    end
end)




Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(100);

        ESX = exports["es_extended"]:getSharedObject()  
    end 

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()
    end 

    local blip = AddBlipForCoord(vector3(19.14, -117.1, 56.22))

	SetBlipSprite(blip, 487)
	SetBlipScale(blip, 0.7)
	SetBlipColour(blip, 0)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName("Väktare")
	EndTextCommandSetBlipName(blip)
end) 

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(data)
	ESX.PlayerData = data
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(job)
	ESX.PlayerData["job"] = job
end) 

Citizen.CreateThread(function() 
    Citizen.Wait(100); 

    while true do  

        local pedPlayer, sleepThread = PlayerPedId(), 750; 

        for index, value in pairs(Config.Joblocations) do  

            local Dst = #(GetEntityCoords(pedPlayer) - value.Coords);  
            if Dst <= 2.0 and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "vaktare" then 
                sleepThread = 5; 
                exports['g-core']:DrawText3D(value.Coords, "[~g~E~s~] - " .. value.Text)
                if IsControlJustReleased(0, 38) then  
                    Action.GetAction(index);
                end
            end
        end

        Citizen.Wait(sleepThread); 
    end
end)  



     











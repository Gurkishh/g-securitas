ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj  
end)  

RegisterServerEvent("g-vaktare:dragPlayer")
AddEventHandler("g-vaktare:dragPlayer", function(target)
    TriggerClientEvent("g-vaktare:dragPlayer", target, source)
end)  


RegisterServerEvent("vaktare:NotfyAll")
AddEventHandler("vaktare:NotfyAll", function(job, message)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

		if xPlayer["job"]["name"] == job then
			TriggerClientEvent("esx:showNotification", xPlayers[i], message)
		end
	end
end)

RegisterServerEvent('g-vaktare:GiveKey')
AddEventHandler('g-vaktare:GiveKey', function(level, name)
    local xPlayer = ESX.GetPlayerFromId(source);


    print(level, name)

    if xPlayer then
        xPlayer.addInventoryItem({
            item = 'vaktarekey',
            data = {
                name = name,
                level = level
            }
        })
    end
end)

ESX.RegisterServerCallback('g-vaktare:Badge', function(source, cb)
    local Player = ESX.GetPlayerFromId(source);

    if Player then
        local Query = MySQL.Sync.fetchAll("SELECT firstname, lastname, rakel FROM users WHERE identifier = @identifier", {[ "@identifier"] = Player.identifier})

        if Query[1] then
            cb(Query[1], Player.getJob().grade_label)
        end
    end
end)

RegisterServerEvent('g-police:DeleteEntity')
AddEventHandler('g-police:DeleteEntity', function(netId)
    TriggerClientEvent('g-police:DeleteEntity', -1, netId)
end)

RegisterServerEvent('g-policejob:putInVehicle')
AddEventHandler('g-policejob:putInVehicle', function(target)
  TriggerClientEvent('g-policejob:putInVehicle', target)
end)

RegisterServerEvent('g-policejob:OutVehicle')
AddEventHandler('g-policejob:OutVehicle', function(target)
    TriggerClientEvent('g-policejob:OutVehicle', target)
end)
ESX.RegisterServerCallback('getPerson', function(source, cb, id)
    local Player = ESX.GetPlayerFromId(id or source);

    if Player then
        cb(Player)
    else
        cb(false)
    end
end)
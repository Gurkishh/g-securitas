Action = {}; 

Action.GetAction = function(action)     
    if action == "Dressing" then   
        Action.Dressing = 1
    end 
    if action == "BossAction" then  
		exports["evrp_bossmenu"]:open('vaktare')
    end 

    if action == "Keys" then 
        if ESX.GetPlayerData().job.grade >= 0 then
            local info = {}
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vaktarekey',
            {
                title = "Namn på nyckel",
            }, function(data, menu) 
                info.keyname = data.value
                if not tonumber(info.level) then
                    ESX.ShowNotification('Behörighetsnivån måste vara ett nummer', 'error')
                elseif tonumber(info.level) > 9 then
                    ESX.ShowNotification('Behörighetsnivån måste vara ett nummer från 1-3', 'error')
                elseif tonumber(info.keyname) then
                    ESX.ShowNotification('Namnet kan ej vara siffror', 'error')
                else
                    TriggerServerEvent('g-vaktare:GiveKey', info.level, info.keyname)
                end
                menu.close() 
            end,
            function(data, menu)
                menu.close()
            end)
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'vaktareLevel',
            {
                title = "Behörighetsnivå, 0 = Högsta, 9 = Lägst 0",
            }, function(data1, menu1) 
                    info.level = data1.value

                menu1.close() 
            end,
            function(data1, menu1)
                menu1.close()
            end)
        else
            ESX.ShowNotification('Du har inte tillgång till detta', 'error')
        end
    end
end



Action.OpenOwnedClothes = function()
	ESX.TriggerServerCallback("evrp_clotheshop:getPlayerDressing", function(dressings)
		local menuElements = {}

		for dressingIndex, dressingLabel in ipairs(dressings) do
		    table.insert(menuElements, {
                ["label"] = dressingLabel, 
                ["outfit"] = dressingIndex
            })
		end

		ESX.UI.Menu.Open("default", GetCurrentResourceName(), "motel_main_dressing_menu", {
			["title"] = "Garderob",
			["align"] = Config.Align,
			["elements"] = menuElements
        }, function(menuData, menuHandle)
            local currentOutfit = menuData["current"]["outfit"]

			TriggerEvent("skinchanger:getSkin", function(skin)
                ESX.TriggerServerCallback("esx_clotheshop:getPlayerOutfit", function(clothes)
                    TriggerEvent("skinchanger:loadClothes", skin, clothes)
                    TriggerEvent("esx_skin:setLastSkin", skin)

                    TriggerEvent("skinchanger:getSkin", function(skin)
                        TriggerServerEvent("esx_skin:save", skin)
                    end)
                end, currentOutfit)
			end)
        end, function(menuData, menuHandle)
			menuHandle.close()
        end)
	end)
end 

Action.OpenDressingRoom = function()  
    local mElements = {}
    for cIndex, cValue in pairs(Config.Clothes) do
        if cValue["slider"] then
            TriggerEvent('skinchanger:getSkin', function(skin)
    
                if Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]] == nil then ESX.PlayerData["job"]["grade_name"] = "vularling" end
                if Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]] == nil then ESX.PlayerData["job"]["grade_name"] = "vaktare2" end
                if Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]] == nil then ESX.PlayerData["job"]["grade_name"] = "erfaren" end
                if Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]] == nil then ESX.PlayerData["job"]["grade_name"] = "sakerhetsansvarig" end
                if Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]] == nil then ESX.PlayerData["job"]["grade_name"] = "vice" end
                if Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]] == nil then ESX.PlayerData["job"]["grade_name"] = "boss" end

                if skin["sex"] == 0 then
                    table.insert(mElements, {
                        label = cIndex,
                        value = 1, type = "slider",
                        min = 1, max = #Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]]["male"]
                    })
                else
                    table.insert(mElements, {
                        label = cIndex,
                        value = 1, type = "slider",
                        min = 1, max = #Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]]["female"]
                    })
                end
            end)
        else
            table.insert(mElements, {
                label = cIndex,
                clothes = Config.Clothes[cIndex][ESX.PlayerData["job"]["grade_name"]]
            })
        end
    end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "cloak", {
        ["title"] = "Omklädningsrum",
        ["align"] = Config.Align,
        ["elements"] = mElements
    }, function(data, menu)
        local action, clothes = data["current"]["action"], data["current"]["clothes"]
        if action == "myclothes" then
            ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(closet)
                local mElements = {}
                for closetIndex, closetValue in pairs(closet) do
                    table.insert(mElements, {
                        ["label"] = closetValue,
                        ["action"] = closetIndex
                    })
                end

                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open("default", GetCurrentResourceName(), "myclothes", {
                    ["title"] = "Din garderob",
                    ["align"] = Config.Align,
                    ["elements"] = mElements
                }, function(data2, menu2)
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        ESX.TriggerServerCallback('esx_clotheshop:getPlayerOutfit', function(clothes)
                            TriggerEvent('skinchanger:loadClothes', skin, clothes)
                            TriggerEvent('esx_skin:setLastSkin', skin)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                            TriggerServerEvent('esx_skin:save', skin)
                            end)
                        end, data2["current"]["action"])
                    end)
                end, function(data2, menu2)
                    menu2.close()
                end)
            end)
        elseif data["current"]["type"] == "slider" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin["sex"] == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[data["current"]["label"]][ESX.PlayerData["job"]["grade_name"]]["male"][data["current"]["value"]])
                else
                    TriggerEvent('skinchanger:loadClothes', skin, Config.Clothes[data["current"]["label"]][ESX.PlayerData["job"]["grade_name"]]["female"][data["current"]["value"]])
                end

                TriggerEvent('esx_skin:setLastSkin', skin)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    TriggerServerEvent('esx_skin:save', skin)
                end)
            end)
        else
            if clothes == nil then clothes = Config.Clothes[data["current"]["label"]]["recruit"] end
            TriggerEvent('skinchanger:getSkin', function(skin)
                if skin["sex"] == 0 then
                    TriggerEvent('skinchanger:loadClothes', skin, clothes["male"])
                else
                    TriggerEvent('skinchanger:loadClothes', skin, clothes["female"])
                end
                
                TriggerServerEvent('esx_skin:save', skin)
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end


-- Action Loop
Citizen.CreateThread(function() 
    Citizen.Wait(100); 

    while true do  

        local pedPlayer, sleepThread = PlayerPedId(), 750;  
  
        if Action.Dressing == 1 then   
            sleepThread = 5;

            exports['h_core']:DrawText3D(GetOffsetFromEntityInWorldCoords(pedPlayer, 0.0, 0.0, 1.0), "[~o~G~s~] - Dina kläder")
            exports['h_core']:DrawText3D(GetOffsetFromEntityInWorldCoords(pedPlayer, 0.0, 0.0, 0.9), "[~o~E~s~] - Omklädningsrum")

            if IsControlJustReleased(0, 47) then  
                Action.OpenOwnedClothes() 
                Action.Dressing = 0
            end 

            if IsControlJustReleased(0, 38) then  
                Action.OpenDressingRoom()  
                Action.Dressing = 0
            end
        end

        Citizen.Wait(sleepThread); 
    end
end) 

function Armory()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'armory',
        {
            title = 'Utrustningsmeny',
            align = "right",
            elements = {

            {label = ('Ta din utrustning'), value = 'get'},
            {label = ('Lägg in din utrustning'), value = 'remove'},
			
            }
        },

        function(data, menu)
            if data.current.value == 'get' then
                ESX.ShowNotification('Tar på dig utrustningen...')
                Citizen.Wait(2500)

                exports['evrp_inventory']:addInventoryItem({
                    item = 'polisflashlight',
                    count = 1,
                });
                Citizen.Wait(1000)
                exports['evrp_inventory']:addInventoryItem({
                    item = 'nightstick',
                    count = 1,
                });
            end
            if data.current.value == 'remove' then
                ESX.ShowNotification('Lägger in din utrustning...')
                Citizen.Wait(2200)		
                TriggerEvent('inventory:removeItem', 'nightstick', 1)
                TriggerEvent('inventory:removeItem', 'polisflashlight', 1)
                ESX.ShowNotification('Du har lagt in din utrustning')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end 
Citizen.CreateThread(function()
    local locations = {
        vector3(20.2, -100.16, 56.18)
    }

    Citizen.Wait(100);

    while true do
        local player, sleepThread = PlayerPedId(), 750;

        for i = 1, #locations do
            local distance = #(GetEntityCoords(player) - locations[i]);

            if distance < 2.0 then
                sleepThread = 5;
            
                if distance < 2.0 then 
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "vaktare" then
                        exports['h_core']:DrawText3D(locations[i], '[~o~E~w~] - Utrustningsmeny')
                        if IsControlJustReleased(0, 38) then  
                            Armory()
                        end
                    end
                end
                
            end
        end

        Citizen.Wait(sleepThread);
    end
end)

Citizen.CreateThread(function()
    local locations = {
        vector3(23.14, -107.05, 56.02)
    }

    Citizen.Wait(100);

    while true do
        local player, sleepThread = PlayerPedId(), 750;

        for i = 1, #locations do
            local distance = #(GetEntityCoords(player) - locations[i]);

            if distance < 2.0 then
                sleepThread = 5;
            
                if distance < 2.0 then 
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "vaktare" then
                        exports['h_core']:DrawText3D(locations[i], '[~b~E~w~] - Fordonsmeny')
                        if IsControlJustReleased(0, 38) then  
                            VehicleList()
                        end
                    end
                end
                
            end
        end

        Citizen.Wait(sleepThread);
    end
end)

Citizen.CreateThread(function()
    local locations = {
        vector3(32.95, -110.03, 55.55)
    }

    Citizen.Wait(100);

    while true do
        local player, sleepThread = PlayerPedId(), 750;
        local playerPed = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        for i = 1, #locations do
            local distance = #(GetEntityCoords(player) - locations[i]);

            if distance < 2.0 then
                sleepThread = 5;
            
                if distance < 2.0 then 
                    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "vaktare" then
                        if IsPedInAnyVehicle(player, false) then
                            exports['h_core']:DrawText3D(locations[i], '[~b~E~w~] - Ta bort fordon')
                            if IsControlJustReleased(0, 38) then
                                ESX.ShowNotification("Ställer in fordon..")
                                Wait(1500)  
                                SetEntityAsMissionEntity(vehicle, false, true)
                                DeleteVehicle(vehicle)
                            end
                        end
                    end
                end
                
            end
        end

        Citizen.Wait(sleepThread);
    end
end)

function VehicleList()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'menu', {
      title = 'Välj fordon',
      align = 'right',
      elements = {
          { label = 'Tjänstefordon', action = 'tjanst' },
      }
  }, function(data, menu)
      local action = data.current.action
  
      if action == 'tjanst' then
        ESX.Game.SpawnVehicle('securitas1', vector3(32.95, -110.03, 55.53), 70.01, function(vehicle)
        end)
        menu.close()
      end
  
  end, function(data, menu)
      menu.close()
  end)
end



                    
                


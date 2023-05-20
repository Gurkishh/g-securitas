Menu = {};
cachedData = {};

local cuff = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function() 
    while true do   
        Citizen.Wait(0)
        if IsControlJustReleased(0, 167) and ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == "vaktare" then  
            Menu.Open()
        end
    end
end)  

function Menu.Open()
    local mElements = {
		{
			label = "Faktura", 
			action = "billing"
		},    
		{
			label = "Handlingar", 
			action = "individual_measures"
		},     		 		
		
		
	} 

	if ESX.PlayerData.job.grade_name == "boss" then 
		table.insert(mElements, {
			label = "Chef meny",
			action = "bossMenu"
		})
	end


    ESX.UI.Menu.Open("default", GetCurrentResourceName(), "main_vaktare_actions", {
		["title"] = "Polisen - Handlingar",
		["align"] = Config.Align,
		["elements"] = mElements 
	}, function(data, menu) 
        local event = data.current.action       
		
		if event == "bossMenu" then 
			ESX.UI.Menu.Open("default", GetCurrentResourceName(), "bossMenu", {
				title = "Chef meny", 
				align = Config.Align, 
				elements = {
					{ label = "Skicka faktura till företag", event = "send_invoice_to_company" }, 
					{ label = "Kolla företagets fakturor", event = "check_company_billings" },
				}
			}, function(Data, Menu)
				local Value = Data.current.event

				if Value == "send_invoice_to_company" then  
					
					exports.billing:createbilling()
				else
					exports.billing:showJobInvoices("vaktare")
				end
			end, function(Data, Menu)
				Menu.close()
			end)
		end

		if event == "billing" then  
			exports.billing:createbilling()
		end 
        if event == "individual_measures" then  
            local player, distance = ESX.Game.GetClosestPlayer(); 
            if distance ~= -1 and distance <= 2.0 then
                cachedData["target"] = player
                cachedData["closestPlayer"] = GetPlayerPed(player)
            else
                ESX.ShowNotification("Det är ingen i närheten.") return
            end  
	
            local mElements = {
				{
					label = "Eskortera",
					action = "drag"
				}, 
				{
					label = "Visitera", 
					action = "search"
				},
				{
					label = "Ge böter",
					action = "billing"
				}, 
				{
					label = "Sätt in person i fordon", 
					action = "put_in_vehicle"
				},
				{
					label = "Ta ut ur fordon",
					action = "out_the_vehicle"
				}
				
			} 

            ESX.UI.Menu.Open("default", GetCurrentResourceName(), "individual_measures", {
				["title"] = "Individåtgärder.",
				["align"] = Config.Align,
				["elements"] = mElements
			}, function(data, menu) 
                local action = data.current.action  
                
				if action == 'search' then
					if IsEntityPlayingAnim(GetPlayerPed(player), "random@mugging3", 'handsup_standing_base', 3) or IsEntityPlayingAnim(GetPlayerPed(player), "mp_arresting", "idle", 3) or IsPedFatallyInjured(GetPlayerPed(player)) then 
						exports['g-tools']:PlayAnimation({
							Ped = PlayerPedId(),
							Dict = 'amb@prop_human_bum_bin@base',
							Lib = "base",
							Flag = 1
						})
						print('sök')
						TriggerServerEvent('searchPlayer', GetPlayerServerId(player))
					else
						ESX.ShowNotification('Åtgärd omöjlig')  
					end
				end

				if action == "billing" then  
					exports.billing:createbilling()
				end 
				
				
				if action == "drag" then  
					if IsEntityPlayingAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 3) then
						ClearPedTasks(PlayerPedId())
					end
					exports['g-tools']:PlayAnimation({
						Ped = PlayerPedId(),
						Dict = 'switch@trevor@escorted_out',
						Lib = '001215_02_trvs_12_escorted_out_idle_guard2',
						Flag = 49
					})
					TriggerServerEvent("g-vaktare:dragPlayer", GetPlayerServerId(cachedData["target"]))
				end
            end, function(data, menu) 
				menu.close() 
            end)
        end 
    end, function(data, menu) 
		menu.close() 
    end)
end


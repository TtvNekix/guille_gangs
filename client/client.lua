
local PlayerData = {}
local ped = GetPlayerPed(-1)
local iped = PlayerPedId(-1)
local pointscreated = true

ESX = nil

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
	--print("gang")
	PlayerData.job = job
	Citizen.Wait(5000)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	PlayerData.job = job
    --print("gang1")
end)

Citizen.CreateThread(function()
    while true do

        local wait = 2000
        local points = {}
        local cars = {}
        local job
        --local pedpos = GetEntityCoords(iped)
        ----print(pedpos)

        for _,v in pairs(Config.Gangs) do
            if PlayerData.job ~= nil and PlayerData.job.name == v.Job then
                job = v.Job
                points = v.Points
                ----print("load")
            end
        end

        for _,v in pairs(points) do
            ----print(v.coords.x)
            ----print(job)
            local coords = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.coords.x, v.coords.y, v.coords.z, true) 
            ----print(coords)
            if (coords < 13) then
                wait = 0
                ----print(job)
                if PlayerData.job.name == job then
                    --print("markers")
                    DrawMarker(1, v.coords.x, v.coords.y, v.coords.z-1.24, 0, 0, 0, 0, 0, 0, v.markerbig.a, v.markerbig.b, v.markerbig.c, v.colorm.r, v.colorm.g, v.colorm.b, 200, 0, 0, 0, 0)
                end
            end
            if (coords < v.distancetomarker) then
                if v.recogn == "Boss" then
                    if PlayerData.job.grade_name == Config.LeaderRank then
                        ESX.ShowHelpNotification(v.notification)
                        if IsControlJustPressed(1,38) then
                            ----print(v.recogn))
                            TriggerServerEvent('guille_gangs:societycheck', job)
                        end
                    end
                elseif v.recogn == "Weapons" then
                    ESX.ShowHelpNotification(v.notification)
                    if IsControlJustPressed(1,38) then
                        Weapons()
                        --print(v.recogn)
                    end
                elseif v.recogn == "Cars" then
                    ESX.ShowHelpNotification(v.notification)
                    if IsControlJustPressed(1,38) then
                        Cars(v.models.car1, v.models.car2, v.vehiclespawn, v.heading, v.color)
                    end
                    ----print(v.recogn)
                elseif v.recogn == "Storage" then
                    ESX.ShowHelpNotification(v.notification)
                    if IsControlJustPressed(1,38) then
                        Storage()
                        --print(v.recogn)
                    end
                elseif v.recogn == "Cardelete" then
                    ESX.ShowHelpNotification(v.notification)

                    if IsControlJustPressed(1,38) then
                        local vehicle = GetVehiclePedIsIn(PlayerPedId(-1), false)
                        local hash = GetHashKey(vehicle)
                        local model = GetEntityModel(vehicle)
                        local carname = GetDisplayNameFromVehicleModel(model)
                        local text = GetLabelText(carname)
                        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
                            --print(text)
                            if text == "NULL" then
                                --print("1")
                                if Config.progressBars then
                                    TaskLeaveVehicle(iped, vehicle, 0)
                                    FreezeEntityPosition(vehicle, true)
                                    exports['progressBars']:startUI(3000, 'Saving the vehicle into the garage')
                                    Citizen.Wait(3000)
                                    NetworkFadeOutEntity(vehicle, true, true)
                                    Citizen.Wait(1000)
                                    DeleteVehicle(vehicle)
                                else
                                    TaskLeaveVehicle(iped, vehicle, 0)
                                    Citizen.Wait(2000)
                                    NetworkFadeOutEntity(vehicle, true, true)
                                    Citizen.Wait(1000)
                                    DeleteVehicle(vehicle)
                                end
                                ESX.ShowNotification('You deleted a ' .. carname .. '')
                            else
                                --print("2")
                                if Config.progressBars then
                                    TaskLeaveVehicle(iped, vehicle, 0)
                                    FreezeEntityPosition(vehicle, true)
                                    exports['progressBars']:startUI(3000, 'Saving the vehicle into the garage')
                                    Citizen.Wait(3000)
                                    NetworkFadeOutEntity(vehicle, true, true)
                                    Citizen.Wait(1100)
                                    DeleteVehicle(vehicle)
                                else
                                    TaskLeaveVehicle(iped, vehicle, 0)
                                    Citizen.Wait(2000)
                                    NetworkFadeOutEntity(vehicle, true, true)
                                    Citizen.Wait(1000)
                                    DeleteVehicle(vehicle)
                                end
                                ESX.ShowNotification('You deleted a ' .. text .. '')
                            end
                        else
                            ESX.ShowNotification('You must be inside a vehicle to delete it')
                        end
                        TriggerServerEvent('guille_gangs:sendlog', 'cardel', carname)
                    end
                end
            end
        end      
        Citizen.Wait(wait)
    end
end)

-- Functions 

function Cars(car1, car2, vehiclespawn, heading, color)
    local elements = {}

    table.insert(elements, {label = "" .. car1 .. "", value = "car1" })
    table.insert(elements, {label = "" .. car2 .. "", value = "car2" })
    ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Vehicle spawn menu",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

        if action == "car1" then
            --print(table.unpack(color))
            ESX.Game.SpawnVehicle(car1, vector3(vehiclespawn.x, vehiclespawn.y, vehiclespawn.z), heading, function(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                SetVehicleCustomPrimaryColour(vehicle, table.unpack(color))
                SetVehicleCustomSecondaryColour(vehicle, table.unpack(color))
                TriggerServerEvent('guille_gangs:sendlog', 'carspawn', car1)
                ESX.UI.Menu.CloseAll()
            end)
        end
        if action == "car2" then
            --print(table.unpack(color))
            ESX.Game.SpawnVehicle(car2, vector3(vehiclespawn.x, vehiclespawn.y, vehiclespawn.z), heading, function(vehicle)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                SetVehicleCustomPrimaryColour(vehicle, table.unpack(color))
                SetVehicleCustomSecondaryColour(vehicle, table.unpack(color))
                TriggerServerEvent('guille_gangs:sendlog', 'carspawn', car2)
                ESX.UI.Menu.CloseAll()
            end)
        end 
        
	end, function(data, menu)
		menu.close()
	end)
end

RegisterNetEvent("guille_gangs:bossactions")
AddEventHandler("guille_gangs:bossactions", function(job)

    local options = {
        wash = Config.EnableMoneyWash,
    }
    ESX.UI.Menu.CloseAll()

    TriggerEvent('esx_society:openBossMenu', job, function(data, menu) 
        menu.close()
    end,options)

    TriggerServerEvent('guille_gangs:sendlog', 'society', job)


end)

RegisterNetEvent("guille_gangs:reglog")
AddEventHandler("guille_gangs:reglog", function(type, gang, msg)
    TriggerServerEvent('guille_gangs:sendlog', type, gang, msg)
end)

RegisterCommand('getmissions', function(source, args)
    ESX.TriggerServerCallback('getmissions', function(missions)
        for i = 1, #missions, 1 do
            Citizen.Wait(500)
            TriggerEvent('chat:addMessage', {args = {'Active mission ', {"Mission id: " .. missions[i]["keyid"] .. " " , " Gang mission: " .. missions[i]["gang"] .. " ", " Mission text: " .. missions[i]["mission"]}}, color = {200, 20, 20}})
        end
    end)
end, false)

RegisterCommand('seemissions', function(source, args)
    ESX.TriggerServerCallback('getmissions', function(missions)
        local elements = {}
        for i = 1, #missions, 1 do
            if missions[i]["gang"] == PlayerData.job.name then
                table.insert(elements, {
                    label = missions[i]["mission"],
                    value = missions[i]["mission"]
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'get_missions', {
            title = ('' .. PlayerData.job.name .. ' missions'),
            align = 'top-right',
            elements = elements
        }, function(data, menu)
            ESX.ShowNotification(''.. data.current.value .. '')
        end, function(data, menu)

            menu.close()
        end)
    end)
end)


function isgang(job)
    for k, v in pairs(Config.Gangs) do
        --print(v.Job)
       if (v.Job == job) then 
        return true
       end
    end 
    --print("--------------------------------------")
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(1, 167) then
            if isgang(PlayerData.job.name) then
                local elements = {}
                table.insert(elements, { label = "Handcuff", value = "handcuff" })
                table.insert(elements, { label = "UnHandcuff", value = "unarrest" })
                table.insert(elements, { label = "See licenses", value = "licenses" })
                table.insert(elements, { label = "Escort", value = "escort" })
                table.insert(elements, { label = "Search", value = "search" })
                table.insert(elements, { label = "Put inside the vehicle", value = "vehiclein" })
                table.insert(elements, { label = "Get out from the vehicle", value = "vehicleout" })

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'get_missions', {
                title = ('' .. PlayerData.job.name .. ' actions'),
                align = 'top-right',
                elements = elements
                }, function(data, menu)
                local v = data.current.value
                local player, distance = ESX.Game.GetClosestPlayer()
                if v == 'handcuff' then
                    local playerheading = GetEntityHeading(GetPlayerPed(-1))
                    local playerlocation = GetEntityForwardVector(PlayerPedId())
                    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
                    if distance < 3 then
                        TriggerServerEvent('esx_policejob:requestarrest', GetPlayerServerId(player), playerheading, playerCoords, playerlocation)
                    end
                elseif v == 'unarrest' then
                    local target, distance = ESX.Game.GetClosestPlayer()
                    playerheading = GetEntityHeading(GetPlayerPed(-1))
                    playerlocation = GetEntityForwardVector(PlayerPedId())
                    playerCoords = GetEntityCoords(GetPlayerPed(-1))
                    local target_id = GetPlayerServerId(target)
                    if distance <= 2.0 then
                    TriggerServerEvent('esx_policejob:requestrelease', target_id, playerheading, playerCoords, playerlocation)
                    else
                        ESX.ShowNotification('No estás lo suficientemente cerca')
                    end
                elseif v == 'search' then
                    print("test")
                    if distance < 3 then
                        OpenBodySearchMenu(player)
                    else
                        ESX.ShowNotification('No players near')
                    end
                elseif v == "vehiclein" then
                    if distance < 3 then
                        TriggerServerEvent('guille_gangs:putinvehicle', GetPlayerServerId(player))
                    end
                elseif v == "vehicleout" then
                    if distance < 3 then
                        TriggerServerEvent('guille_gangs:outfromveh', GetPlayerServerId(player))
                    end
                elseif v == "escort" then
                    if distance < 3 then
                        TriggerServerEvent('guille_gangs:escort', GetPlayerServerId(player))
                    end
                elseif v == "licenses" then
                    if distance < 3 then
                        OpenIdentityCardMenu(player)
                    end
                end
                end, function(data, menu)
                menu.close()
                end)
            end
        end
    end
end)



function OpenBodySearchMenu(player)
    print("test")
	ESX.TriggerServerCallback('esx_policejob:getOtherPlayerData', function(data)
		local elements = {}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				table.insert(elements, {
					label    = 'Confiscar dinero negro: ' ..ESX.Math.Round(data.accounts[i].money),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				})

				break
			end
		end

		table.insert(elements, {label = ('Armas')})

		for i=1, #data.weapons, 1 do
			table.insert(elements, {
				label    = 'Confiscar arma: ' ..ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo,
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			})
		end

		table.insert(elements, {label = ('Inventario')})

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				table.insert(elements, {
					label    = 'Confiscar item: ' .. data.inventory[i].count, data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search', {
			title    = ('search'),
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			if data.current.value then
				TriggerServerEvent('esx_policejob:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, GetPlayerServerId(player))
end


RegisterNetEvent('guille_gans:outfromv')
AddEventHandler('guille_gans:outfromv', function(target)
    local ped = GetPlayerPed(target)
    local iped = GetPlayerPed(-1)
    ClearPedTasks(ped)
    plyPos = GetEntityCoords(iped,  true)
    local xnew = plyPos.x+2
    local ynew = plyPos.y+2
    SetEntityCoords(iped, xnew, ynew, plyPos.z)
end)

function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('guille_gangs:getOtherPlayerData', function(data)
        print(data)
		local elements = {
			{label = ('name:' ..data.name)},
			{label = ('job' .. ('%s - %s'):format(data.job, data.grade) .. '')}
		}

		if Config.EnableESXIdentity then
			table.insert(elements, {label = ('Sex ' .. (data.sex))})
			table.insert(elements, {label = ('dob ' .. data.dob)})
			table.insert(elements, {label = ('Height' .. data.height)})
		end

		if data.drunk then
			table.insert(elements, {label = ('Bac' .. data.drunk)})
		end

		if data.licenses then
			table.insert(elements, {label = ('license')})

			for i=1, #data.licenses, 1 do
				table.insert(elements, {label = data.licenses[i].label})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_interaction2', {
			title    = ('citizen_interaction'),
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
				
			end, function(data, menu)
			menu.close()

		end)

	end, GetPlayerServerId(player))
end

function OpenPutStocksMenu()

	ESX.TriggerServerCallback('guille_gangs:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type  = 'item_standard',
					value = item.name
				})
			end
		end

		for i=1, #inventory.weapons, 1 do
			local weapon = inventory.weapons[i]

			table.insert(elements, {
				label = weapon.label .. ' [' .. weapon.ammo .. ']',
				type  = 'item_weapon',
				value = weapon.name,
				ammo  = weapon.ammo
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Your inventory',
			align    = 'top-right',
			elements = elements
		}, function(data, menu)
			if data.current.type == 'item_weapon' then
				menu.close()
				TriggerServerEvent('guille_gangs:putStockItems', data.current.type, data.current.value, data.current.ammo)

				ESX.SetTimeout(300, function()
					OpenPutStocksMenu()
				end)
			else

				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
					title = 'quantity'
				}, function(data2, menu2)
					local count = tonumber(data2.value)

					if count == nil then
						TriggerEvent("pNotify:SendNotification", {text = "Cantidad invalida, intentolo de nuevo", type = "warning", timeout = 3400, layout = "bottomLeft"})
					else
						menu2.close()
						menu.close()
						TriggerServerEvent('guille_gangs:putStockItems', data.current.type, data.current.value, count)

						Citizen.Wait(500)
						OpenPutStocksMenu()
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenGetStockMenu()
    
	ESX.TriggerServerCallback('guille_gangs:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = items[i].name .. ' x' .. items[i].count,
				type = 'item_standard',
				value = items[i].name,
				haveImage = true
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armario2_menu', {
			title    = '' .. PlayerData.job.name .. ' inventory',
			align    = 'top-right',
			elements = elements,
			enableImages = true
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sacar_items', {
				title = 'quantity'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if not count then
					ESX.ShowNotification('Invalid quantity')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('guille_gangs:getStockItem', itemName, count)

					Citizen.Wait(300)
					OpenGetArmarioMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function Storage()
    TriggerServerEvent('guille_gangs:sendlog', 'stock')
    local elements = {}
    table.insert(elements, { label = "Put Items", value = "put" })
    table.insert(elements, { label = "Get Items", value = "get" })

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'get_missions', {
        title = ('' .. PlayerData.job.name .. ' actions'),
        align = 'top-right',
        elements = elements
    }, function(data, menu)
        local v = data.current.value
        if v == "put" then
            OpenPutStocksMenu()
        elseif v == "get" then
            OpenGetStockMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end


function Weapons()
    TriggerServerEvent('guille_gangs:sendlog', 'weapons')
	ESX.TriggerServerCallback('guille_gangs:getWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
            --print(weapons[i].name)
            table.insert(elements, {
                label = ESX.GetWeaponLabel(weapons[i].name),
                value = weapons[i].name,
                type = 'item_weapon',
                haveImage = true
            })
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon', {
			title    = ('' .. PlayerData.job.name .. ' weapons'),
			align    = 'top-right',
			elements = elements,
			enableImages = true
		}, function(data, menu)
			menu.close()
			ESX.TriggerServerCallback('guille_gangs:removeweapon', function()
				Weapons()
			end, data.current.value)
		end, function(data, menu)
			menu.close()
		end)
	end)
end



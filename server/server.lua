ESX = nil
local doorInfo = {}
local doorStatus = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('cfx_gangs:updateState')
AddEventHandler('cfx_gangs:updateState', function(doorID, state, isMember)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if isMember then
        doorInfo[doorID] = state
    end
	--doorInfo[doorID] = state

    TriggerClientEvent('cfx_gangs:setState', -1, doorID, state)
end)

RegisterServerEvent('cfx_gangs:breakDoor')
AddEventHandler('cfx_gangs:breakDoor', function(doorID, state)
	doorStatus[doorID] = state
	-- print(doorID)
	-- print(state)
	TriggerClientEvent('cfx_gangs:breakDoor', -1, doorID, state)
end)

RegisterServerEvent('cfx_gangs:forceOpen')
AddEventHandler('cfx_gangs:forceOpen', function(doorID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	doorInfo[doorID] = state

	TriggerClientEvent('cfx_gangs:setState', -1, doorID, state)
end)

RegisterServerEvent('cfx_gangs:breachDoor')
AddEventHandler('cfx_gangs:breachDoor', function(doorID, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	doorInfo[doorID] = state

	TriggerClientEvent('cfx_gangs:setState', -1, doorID, state)
end)

RegisterNetEvent('cfx_gangs:sendNews')
AddEventHandler('cfx_gangs:sendNews', function(streetName)
    TriggerClientEvent('cfx_gangs:sendNewsToAll', -1, streetName)
end)


ESX.RegisterServerCallback('cfx_gangs:getDoorInfo', function(source, cb)
	cb(doorInfo)
end)

ESX.RegisterServerCallback('cfx_gangs:getDoorStatus', function(source, cb)
	cb(doorStatus)
end)

ESX.RegisterServerCallback('cfx_gangs:getPlayerInfo', function(source, cb, target)
    local src = source
    local targetxPlayer = ESX.GetPlayerFromId(target)
    local playerName = targetxPlayer.name
	cb(playerName)
end)

ESX.RegisterServerCallback('cfx_gangs:getGangMembers', function(source, cb, gangName)
    MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, gang, gang_rank FROM users WHERE gang = @gang', {
        ['@gang'] = gangName
    }, function (results)
        local members = {}

        for i=1, #results, 1 do
            table.insert(members, {
                name       = results[i].firstname .. ' ' .. results[i].lastname,
                identifier = results[i].identifier,
                grade       = results[i].gang_rank,
                gang = {
                    name        = results[i].gang,
                    grade       = results[i].gang_rank,
                }
            })
        end

        cb(members)
    end)
end)

ESX.RegisterServerCallback('cfx_gangs:getWeaponStock', function(source, cb, gangName)
    local weaponStock = MySQL.Sync.fetchScalar('SELECT weaponStocks FROM gangs WHERE name = @name', {
		['@name'] = gangName
	})

	if weaponStock then
		weaponStock = weaponStock
	else
		weaponStock = 0
    end
	cb(weaponStock)
end)

ESX.RegisterServerCallback('cfx_gangs:getItemStock', function(source, cb, gangName)
    local itemStocks = MySQL.Sync.fetchScalar('SELECT itemStocks FROM gangs WHERE name = @name', {
		['@name'] = gangName
    })
    if itemStocks then
		itemStocks = itemStocks
	else
		itemStocks = 0
    end
    local currentGang = gangName
	cb(itemStocks, currentGang)
end)

ESX.RegisterServerCallback('cfx_gangs:getGangAccount', function(source, cb, gangName)
    local gangFunds = MySQL.Sync.fetchScalar('SELECT gangFunds FROM gangs WHERE name = @name', {
		['@name'] = gangName
    })
    local itemStock = MySQL.Sync.fetchScalar('SELECT itemStocks FROM gangs WHERE name = @name', {
		['@name'] = gangName
    })
    local weaponStock = MySQL.Sync.fetchScalar('SELECT weaponStocks FROM gangs WHERE name = @name', {
		['@name'] = gangName
	})
	cb(gangFunds, itemStock, weaponStock)
end)

local isMember = false
local canProcess = false

ESX.RegisterServerCallback('cfx_gangs:getGangInfo', function(source, cb, gangName)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT gang, gang_rank FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier}, function(result)
		if result[1].gang then
            local playerrank = tostring(result[1].gang_rank)
            local gang = result[1].gang

            if gang == gangName then
                isMember = true
                cb(isMember, canProcess)
            else
                isMember = false
                cb(isMember, canProcess)
            end
		end
    end)
end)

RegisterServerEvent('cfx_gangs:AddNewMember')
AddEventHandler('cfx_gangs:AddNewMember', function(target, gangName, playerName)
    local _source = source
	local gang = gang
	local rank = rank
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xTarget = ESX.GetPlayerFromId(target)

    MySQL.Async.execute('UPDATE users SET gang = @gang, gang_rank = @gang_rank WHERE identifier = @identifier', {
		['@gang'] = gangName,
		['@gang_rank'] = 'member',
		['@identifier'] = xTarget.identifier
	}, function(rowsChanged)

        if rowsChanged then
            TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'You hired '..playerName..'!', length = 2500})
            TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'inform', text = 'You were hired in the gang by '..xPlayer.name, length = 2500})
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Gang: System Error')
		end
		
	end)
end)

RegisterServerEvent('cfx_gangs:LeaveGang')
AddEventHandler('cfx_gangs:LeaveGang', function(gangName)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('UPDATE users SET gang = @gang, gang_rank = @gang_rank WHERE identifier = @identifier', {
		['@gang'] = nil,
		['@gang_rank'] = nil,
		['@identifier'] = xPlayer.identifier
	}, function(rowsChanged)

        if rowsChanged then
            TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'You left the gang!', length = 2500})
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Gang: System Error')
		end
		
	end)
end)

RegisterServerEvent('cfx_gangs:KickMember')
AddEventHandler('cfx_gangs:KickMember', function(gangName, identifier, membername)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('UPDATE users SET gang = @gang, gang_rank = @gang_rank WHERE identifier = @identifier', {
		['@gang'] = nil,
		['@gang_rank'] = nil,
		['@identifier'] = identifier
	}, function(rowsChanged)

        if rowsChanged then
            TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'You kicked '..membername..' out of the gang!', length = 2500})
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Gang: System Error')
		end
		
	end)
end)

RegisterServerEvent('cfx_gangs:SetLeader')
AddEventHandler('cfx_gangs:SetLeader', function(gangName, identifier, membername)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    MySQL.Async.execute('UPDATE users SET gang = @gang, gang_rank = @gang_rank WHERE identifier = @identifier', {
		['@gang'] = gangName,
		['@gang_rank'] = 'Leader',
		['@identifier'] = identifier
	}, function(rowsChanged)

        if rowsChanged then
            TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'You set '..membername..' as a leader of the gang!', length = 2500})
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, 'Gang: System Error')
		end
		
	end)
end)

RegisterServerEvent('cfx_gangs:giveWeapon')
AddEventHandler('cfx_gangs:giveWeapon', function(gangName, weaponStock)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addWeapon(Config.Zone[gangName].weapon, 40)
    Citizen.Wait(1000)
    MySQL.Async.execute('UPDATE gangs SET weaponStocks = weaponStocks - 1 WHERE name = @name', {
        ['@name'] = gangName
    }, nil)
end)

RegisterServerEvent('cfx_gangs:checkHarvester')
AddEventHandler('cfx_gangs:checkHarvester', function(gangName, item, itemStock, amount, currentGang)
    local _source = source
    local gang = Config.Zone[gangName]
    local oldItemStocks = GetItemStocks(gangName)

    if item == gang.item1 then
        ProcessTime = gang.processWait1
    elseif item == gang.item2 then
        ProcessTime = gang.processWait2
    end

    if gangName ~= currentGang then
        if ProcessTime <= 15000 then
            ProcessTime = ProcessTime + 15000
        elseif ProcessTime >= 30000 then
            ProcessTime = ProcessTime + 30000
        end
    end

    if item == gang.item1 then
        if gang.isGangHarvesting2 ~= true then
            TriggerClientEvent('cfx_gangs:harvestItem', _source, gangName, item, itemStock, amount, currentGang)
            
            MySQL.Async.execute('UPDATE gangs SET itemStocks = @itemStocks WHERE name = @name', {
                ['@itemStocks'] = oldItemStocks - gang.amount,
                ['@name'] = gangName
            }, nil)
            
            gang.isGangHarvesting1 = true
            Citizen.Wait(ProcessTime)
            gang.isGangHarvesting1 = false
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You can\'t craft items at the same time', length = 2500})
        end
    elseif item == gang.item2 then
        if gang.isGangHarvesting1 ~= true then
            TriggerClientEvent('cfx_gangs:harvestItem', _source, gangName, item, itemStock, amount, currentGang)
            
            MySQL.Async.execute('UPDATE gangs SET itemStocks = @itemStocks WHERE name = @name', {
                ['@itemStocks'] = oldItemStocks - gang.amount,
                ['@name'] = gangName
            }, nil)
            
            gang.isGangHarvesting2 = true
            Citizen.Wait(ProcessTime)
            gang.isGangHarvesting2 = false
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You can\'t craft items at the same time', length = 2500})
        end
    end
end)

RegisterServerEvent('cfx_gangs:buyStocks')
AddEventHandler('cfx_gangs:buyStocks', function(gangName, type, price)
    local _source = source
    local funds = GetGangFunds(gangName)
    local oldItemStocks = GetItemStocks(gangName)
    local oldWeaStocks = GetWeaponStocks(gangName)
    if type == 'Items' then
        if funds >= price then
            MySQL.Async.execute('UPDATE gangs SET itemStocks = @itemStocks WHERE name = @name', {
                ['@itemStocks'] = oldItemStocks + 100,
                ['@name'] = gangName
            }, nil)
            
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You bought 100 Gang Resources!', length = 2500})
        
            MySQL.Async.execute('UPDATE gangs SET gangFunds = @gangFunds WHERE name = @name', {
                ['@gangFunds'] = funds - price,
                ['@name'] = gangName
            }, nil)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Not enought gang funds!', length = 2500})
        end
    elseif type == 'Weapons' then
        if funds >= price then
            MySQL.Async.execute('UPDATE gangs SET weaponStocks = @weaponStocks WHERE name = @name', {
                ['@weaponStocks'] = oldWeaStocks + 20,
                ['@name'] = gangName
            }, nil)
            
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You bought 20 Weapon Resources!', length = 2500})
            
            MySQL.Async.execute('UPDATE gangs SET gangFunds = @gangFunds WHERE name = @name', {
                ['@gangFunds'] = funds - price,
                ['@name'] = gangName
            }, nil)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Not enought gang funds!', length = 2500})
        end
    end
end)

RegisterServerEvent('cfx_gangs:removeItem')
AddEventHandler('cfx_gangs:removeItem', function(name, amount)
	local xPlayer  = ESX.GetPlayerFromId(source)
	if name == 'money' then
		xPlayer.removeMoney(amount)
	else 
		xPlayer.removeInventoryItem(name, amount)
	end
end)

RegisterServerEvent('cfx_gangs:receiveItem')
AddEventHandler('cfx_gangs:receiveItem', function(name, amount)
	local xPlayer  = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(name)
	if xItem.limit ~= -1 and (xItem.count) > xItem.limit then
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = "You can't carry more"})
    else
		if name == 'money' then
			xPlayer.addMoney(amount)
		else 
			xPlayer.addInventoryItem(name, amount)
		end
	end
end)

ESX.RegisterUsableItem('bolt_cutter', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('cfx_gangs:AttemptGangStashBoltCutter', source) 
end)

local raided = false

RegisterServerEvent('cfx_gangs:raidStash')
AddEventHandler('cfx_gangs:raidStash', function(gangName)
    if not raided then
        TriggerClientEvent('cfx_gangs:getStash', source, gangName, 'bolt_cutter')
    end
end)

RegisterServerEvent('cfx_gangs:giveStash')
AddEventHandler('cfx_gangs:giveStash', function(gangName, itemToRaid)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    if not raided then
        raided = true

        local funds = GetGangFunds(gangName)
        local robbedFunds = math.random(25000,35000)

        MySQL.Async.execute('UPDATE gangs SET gangFunds = @gangFunds WHERE name = @name', {
            ['@gangFunds'] = funds - robbedFunds,
            ['@name'] = gangName
        }, nil)
        
        MySQL.Async.fetchAll('SELECT gang FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier}, function(result)
            if result[1].gang then
                local robbergang = result[1].gang
                local robberfunds = GetGangFunds(robbergang)

                MySQL.Async.execute('UPDATE gangs SET gangFunds = @gangFunds WHERE name = @name', {
                    ['@gangFunds'] = robberfunds + robbedFunds,
                    ['@name'] = robbergang
                }, nil)
            end
        end)

        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You got '..ESX.Math.GroupDigits(robbedFunds)..'$ from their gang funds!', length = 2500})

        canProcess = true
        ResetCanProcessTimer()
        TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You can now craft and open their stash!', length = 2500})
    end
end)

RegisterServerEvent('cfx_gangs:cancelledRobbing')
AddEventHandler('cfx_gangs:cancelledRobbing', function(gangName)
    raided = false
    canProcess = false
end)

function ResetCanProcessTimer()
    SetTimeout(Config.RaidCooldown * (60 * 1000), function()
        if canProcess then
            raided = false
            canProcess = false
        end
    end)
end


-- GANG DELIVERY --
delivery_is_running = false
delivery_destination = nil

delivery_vehicle = nil
delivery_gang = nil
vehicle_plate = nil
delivery_blip = nil

RegisterServerEvent('cfx_gangs:setupDelivery')
AddEventHandler('cfx_gangs:setupDelivery', function(gangName, item)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    if not delivery_is_running then
        TriggerClientEvent('cfx_gangs:spawnVehicle', source, gangName)
        delivery_is_running = true
        xPlayer.removeInventoryItem(item, Config.Zone[gangName].requiredItem)
    end
end)

RegisterServerEvent('cfx_gangs:getWayPoint')
AddEventHandler('cfx_gangs:getWayPoint', function(gangName, veh, plate)
    if delivery_is_running and delivery_destination == nil then
        delivery_destination =Config.Zone[gangName].deliveryPoint
        TriggerClientEvent('cfx_gangs:setWayPoint', source, gangName, veh, plate, delivery_destination)
    end
end)

RegisterServerEvent('cfx_gangs:resetDelivery')
AddEventHandler('cfx_gangs:resetDelivery', function()
    delivery_is_running = false
    delivery_destination = nil
end)

RegisterServerEvent('cfx_gangs:completeDelivery')
AddEventHandler('cfx_gangs:completeDelivery', function(gangName)
    local _source = source
    local funds = GetGangFunds(gangName)
    local oldItemStocks = GetItemStocks(gangName)
    local oldWeaStocks = GetWeaponStocks(gangName)
    local price = 5000

    MySQL.Async.execute('UPDATE gangs SET gangFunds = @gangFunds WHERE name = @name', {
        ['@gangFunds'] = funds + price,
        ['@name'] = gangName
    }, nil)

    MySQL.Async.execute('UPDATE gangs SET itemStocks = @itemStocks WHERE name = @name', {
        ['@itemStocks'] = oldItemStocks + 42,
        ['@name'] = gangName
    }, nil)

    MySQL.Async.execute('UPDATE gangs SET weaponStocks = @weaponStocks WHERE name = @name', {
        ['@weaponStocks'] = oldWeaStocks + 1,
        ['@name'] = gangName
    }, nil)

    TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Delivery successful recieved 5,000$ gang funds!', length = 2500})
    
    TriggerClientEvent('cfx_gangs:resetDelivery', -1)
    delivery_is_running = false
    delivery_destination = nil
    
    local repLuck = math.random(1, 100)

    if repLuck > 80 then
        TriggerEvent("salty_crafting:addrep", source, math.random(1, 10))
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You recieved reputation!', length = 2500})
    end
end)

RegisterCommand('gangmenu', function(source)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local playerrank, gang, gangPosition
    MySQL.Async.fetchAll('SELECT gang, gang_rank FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier}, function(result)
		if result[1].gang then
            local playerrank = tostring(result[1].gang_rank)
            local gang = result[1].gang
            TriggerClientEvent('cfx_gangs:OpenGangMenu', _source, gang, playerrank)
		end
    end)
end)

RegisterCommand('setgang', function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local targetPlayer = ESX.GetPlayerFromId(args[1])
    if isAllowed(_source) then
        if args[1] and args[2] and args[3] == nil then
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Invalid use! /setgang [playerId] [gang] [rank]', length = 4500}) 
        else
            if targetPlayer then

                MySQL.Async.execute('UPDATE users SET gang = @gang, gang_rank = @gang_rank WHERE identifier = @identifier', {
                    ['@gang'] = tostring(args[2]),
                    ['@gang_rank'] = tostring(args[3]),
                    ['@identifier'] = targetPlayer.identifier
                }, function(rowsChanged)
                    if rowsChanged then
                        TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'You hired '..targetPlayer.name..'!', length = 2500})
                        TriggerClientEvent('mythic_notify:client:SendAlert', targetPlayer.source, { type = 'inform', text = 'You were hired in the gang as a '..tostring(args[3]), length = 2500})
                    else
                        print('Gang: System Error')
                    end
                end)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Player not online!', length = 2500})
            end
        end
    else
        print('^4[cfx_gangs]^0 ^3SOMEONE TRIED TO USE ADMIN COMMAND NOT AN ADMIN^0\n^4[cfx_gangs]^0 ^3NAME:^0 ^1'..xPlayer.name..' ^3STEAM:^0 ^1'..xPlayer.identifier..'^0')
    end
end)

-- GANG ITEMS --
ESX.RegisterUsableItem('kevlar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('cfx_gangs:kevlar', source, false)
end)

ESX.RegisterUsableItem('policekevlar', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('cfx_gangs:kevlar', source, true)
end)


function isAllowed(player)
    local allowed = false
    for i,id in ipairs(Config.admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

function GetGang(identifier)
    MySQL.Async.fetchAll('SELECT gang FROM users WHERE identifier=@identifier', {['@identifier'] = identifier}, function(result)
		if result[1].gang then
            gang = result[1].gang
            print(gang)
		end
    end)
end

function GetGangFunds(gangName)
    local gangFunds = MySQL.Sync.fetchScalar('SELECT gangFunds FROM gangs WHERE name = @name', {
		['@name'] = gangName
    })
    if gangFunds then
		return gangFunds
	else
		return 0
	end
end

function GetWeaponStocks(gangName)
    local weaponStocks = MySQL.Sync.fetchScalar('SELECT weaponStocks FROM gangs WHERE name = @name', {
		['@name'] = gangName
    })
    if weaponStocks then
		return weaponStocks
	else
		return 0
	end
end

function GetItemStocks(gangName)
    local itemStocks = MySQL.Sync.fetchScalar('SELECT itemStocks FROM gangs WHERE name = @name', {
		['@name'] = gangName
    })
    if itemStocks then
		return itemStocks
	else
		return 0
	end
end
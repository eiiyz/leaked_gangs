local ESX = nil
local nitroCount = 0
local isNitroActive = false
local vehicleWithNitro = nil
local streetName = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()

    -- Update the door list
    ESX.TriggerServerCallback('cfx_gangs:getDoorInfo', function(doorInfo)
        for doorID,state in pairs(doorInfo) do
            Config.DoorList[doorID].locked = state
        end
    end)

    -- Update the door status
    ESX.TriggerServerCallback('cfx_gangs:getDoorStatus', function(doorStatus)
        for doorID, state in pairs(doorStatus) do
            Config.DoorList[doorID].destroyed = state
        end
    end)    
end)

-- Get Street Name

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)

        local playerCoords = GetEntityCoords(PlayerPedId())
        streetName,_ = GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z)
        streetName = GetStreetNameFromHashKey(streetName)
    end
end)

-- Weapon Attachments
local WeaponAttachments = {
    [GetHashKey('WEAPON_PISTOL')] = { suppressor = GetHashKey('component_at_pi_supp_02') },
    [GetHashKey('WEAPON_PISTOL50')] = { suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
    [GetHashKey('WEAPON_COMBATPISTOL')] = { suppressor = GetHashKey('COMPONENT_AT_PI_SUPP') },
    [GetHashKey('WEAPON_APPISTOL')] = { suppressor = GetHashKey('COMPONENT_AT_PI_SUPP') },
    [GetHashKey('WEAPON_MICROSMG')] = { suppressor = GetHashKey('COMPONENT_AT_AR_SUPP_02') },
    [GetHashKey('WEAPON_CARBINERIFLE')] = { suppressor = GetHashKey('COMPONENT_AT_AR_SUPP') }
}


-- End of Weapon Attachments

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- ADD GANG MEMBER
RegisterNetEvent('cfx_gangs:AddNewMember')
AddEventHandler('cfx_gangs:AddNewMember', function(gangName)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 3.0 then
        exports['mythic_notify']:DoCustomHudText ('error', 'There are no players nearby.', 5000)
    else
        TriggerServerEvent('cfx_gangs:AddNewMember', GetPlayerServerId(closestPlayer), gangName)
    end 
end)

-- ADD LEADER GANG MEMBER
RegisterNetEvent('cfx_gangs:AddNewLeader')
AddEventHandler('cfx_gangs:AddNewLeader', function(gangName)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 3.0 then
        exports['mythic_notify']:DoCustomHudText ('error', 'There are no players nearby.', 5000)
    else
        TriggerServerEvent('cfx_gangs:AddNewLeader', GetPlayerServerId(closestPlayer), gangName)
    end 
end)

-- GANG MENU
RegisterNetEvent('cfx_gangs:OpenGangMenu')
AddEventHandler('cfx_gangs:OpenGangMenu', function(gangName, gangPosition)
    local elements = {}

    if gangPosition == 'Leader' or gangPosition == 'Boss' then
        table.insert(elements, {label = 'Invite Member', value = 'addMember'})
    end
    if gangPosition == 'Boss' then
        table.insert(elements, {label = 'Gang Members', value = 'openGangMembers'})
        table.insert(elements, {label = 'Gang Account', value = 'openGangAccount'})
        table.insert(elements, {label = 'Gang Options', value = 'openGangOptions'})
    end

    if gangPosition ~= 'Boss' then
        table.insert(elements, {label = 'Leave Gang', value = 'leaveGang'})
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_actions', {
        title    = 'Gang Actions',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'addMember' then
            ConfirmAddMember(gangName)
        elseif data.current.value == 'openGangMembers' then
            OpenGangMembers(gangName)           
        elseif data.current.value == 'openGangAccount' then
            OpenGangAccount(gangName)    
        elseif data.current.value == 'openGangOptions' then
            OpenGangOptions(gangName)                    
        elseif data.current.value == 'leaveGang' then
            ConfirmLeaveGang(gangName)
        end
    end, function(data, menu)
        menu.close()
    end)    
end)

-- Confirm Add New Member
function ConfirmAddMember(gangName)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if closestPlayer == -1 or closestDistance > 3.0 then
        exports['mythic_notify']:DoCustomHudText ('error', 'There are no players nearby.', 5000)
    else
        ESX.TriggerServerCallback('cfx_gangs:getPlayerInfo', function(playerName)
            ESX.UI.Menu.CloseAll()

            local elements = {
                {label = 'Yes', value = 'confirmYes'},
                {label = 'No', value = 'confirmNo'}
            }

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_add_member',
            {
                title    = 'Are you sure you want to invite ' .. playerName .. ' into your gang?' ,
                align    = 'top-right',
                elements = elements
            }, function(data, menu)

                if data.current.value == 'confirmYes' then
                    TriggerServerEvent('cfx_gangs:AddNewMember', GetPlayerServerId(closestPlayer), gangName, playerName)
                    menu.close()
                else
                    menu.close()
                end

            end, function(data, menu)
                menu.close()
            end)
        end, GetPlayerServerId(closestPlayer))
    end   
end

-- LEAVE GANG MENU
function ConfirmLeaveGang(gangName)

    local elements = {
        {label = 'Yes', value = 'confirmYes'},
        {label = 'No', value = 'confirmNo'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_confirm_leave', {
        title    = 'Do you really want to your gang?',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'confirmYes' then
            TriggerServerEvent('cfx_gangs:LeaveGang', gangName)
            menu.close()
        elseif data.current.value == 'confirmNo' then
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)    
end

-- GANG ACCOUNT MENU
function OpenGangAccount(gangName)

    ESX.TriggerServerCallback('cfx_gangs:getGangAccount', function(gangFunds, itemStock, weaponStock)

        local elements = {
            {label = 'Gang Funds: $'.. gangFunds, value = 'gang_funds'},
            {label = 'Gang Resources: '.. itemStock, value = 'gang_funds'},
            {label = 'Weapon Stock: '.. weaponStock, value = 'gang_funds'},
        }

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_open_account', {
            title    = 'Gang Account',
            align    = 'top-right',
            elements = elements
        }, function(data, menu)
        end, function(data, menu)
            menu.close()
        end)  


    end, gangName)
  
end

-- GANG OPTIONS MENU
function OpenGangOptions(gangName)
    local ItemPrice = Config.StockPrices["ItemStock"].onehundedpcs
    local WeaponPrice = Config.StockPrices["WeaponStock"].twentypcs

    local elements = {
        {label = 'Buy Item Stocks 100 - $' .. ItemPrice, value = 'buy_itemstocks'},
        {label = 'Buy Weapon Stocks 20 - $' .. WeaponPrice, value = 'buy_weaponstocks'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_open_options', {
        title    = 'Gang Options',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'buy_itemstocks' then
            TriggerServerEvent('cfx_gangs:buyStocks', gangName, 'Items', ItemPrice)
        elseif data.current.value == 'buy_weaponstocks' then
            TriggerServerEvent('cfx_gangs:buyStocks', gangName, 'Weapons', WeaponPrice)
        elseif data.current.value == 'upgrade_weapon' then
            OpenWeaponUpgrade(gangName)
        end    
    end, function(data, menu)
        menu.close()
    end)  
end

-- GANG MEMBERS MENU
function OpenGangMembers(gangName)

    ESX.TriggerServerCallback('cfx_gangs:getGangMembers', function(members)
        ESX.UI.Menu.CloseAll()
        local elements = {}

        for i=1, #members, 1 do

            if members[i].grade == 'Leader' or members[i].grade == 'Boss' then
            table.insert(elements, {
                label  = members[i].name .. ' - ' .. members[i].grade,
                memberidentifier = members[i].identifier,
                membername = members[i].name,
                memberposition = members[i].grade
            })
            else
            table.insert(elements, {
                label  = members[i].name,
                memberidentifier = members[i].identifier,
                membername = members[i].name,
                memberposition = members[i].grade
            })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_open_members',
        {
            title    = 'Gang Members',
            align    = 'top-right',
            elements = elements
        }, function(data, menu)

            if data.current.memberidentifier == data.current.memberidentifier then                
                OpenGangMemberAction(gangName, data.current.memberidentifier, data.current.membername, data.current.memberposition)
            end

        end, function(data, menu)
            menu.close()
        end)
    end, gangName)
end

-- GANG MEMBER ACTION
function OpenGangMemberAction(gangName, identifier, membername, memberposition)
    local elements = {}

    table.insert(elements, {label = 'Kick Member', value = 'kick_member'})

    if memberposition ~= 'Leader' then
        table.insert(elements, {label = 'Set Leader', value = 'set_leader'})
    end

    table.insert(elements, {label = 'Back', value = 'option_back'})

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_open_member_action', {
        title    = membername,
        align    = 'top-right',
        elements = elements
    }, function(data, menu)

        if data.current.value == 'kick_member' then
            ConfirmKickMember(gangName, identifier, membername)
        elseif data.current.value == 'set_leader' then
            ConfirmSetLeader(gangName, identifier, membername)            
        elseif data.current.value == 'option_back' then
            OpenGangMembers(gangName)
        end
   
    end, function(data, menu)
        menu.close()
    end)  
end

-- KICK MEMBER
function ConfirmKickMember(gangName, identifier, membername)

    local elements = {
        {label = 'Yes', value = 'confirmYes'},
        {label = 'No', value = 'confirmNo'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_confirm_kick', {
        title    = 'Do you really want to kick ' .. membername .. ' out of your gang?',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'confirmYes' then
            TriggerServerEvent('cfx_gangs:KickMember', gangName, identifier, membername)
            menu.close()
        elseif data.current.value == 'confirmNo' then
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)    
end

-- SET LEADER
function ConfirmSetLeader(gangName, identifier, membername)

    local elements = {
        {label = 'Yes', value = 'confirmYes'},
        {label = 'No', value = 'confirmNo'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_confirm_leader', {
        title    = 'Are you sure you want to set ' .. membername .. ' as your gang leader?',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'confirmYes' then
            TriggerServerEvent('cfx_gangs:SetLeader', gangName, identifier, membername)
            menu.close()
        elseif data.current.value == 'confirmNo' then
            menu.close()
        end
    end, function(data, menu)
        menu.close()
    end)    
end

-- GANG STASH MENU
function OpenStashMenu(gangName)

    local elements = {
        {label = 'Get Weapons', value = 'get_weapon'},
        {label = 'Stash', value = 'withdraw_item'},
    }


    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_open_account', {
        title    = 'Gang Account',
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'get_weapon' then
            ESX.TriggerServerCallback('cfx_gangs:getWeaponStock', function(weaponStock)
                if weaponStock >= 1 then

                    TriggerEvent("mythic_progbar:client:progress", {
                        name = "unique_action_name",
                        duration = 5000,
                        label = "Retrieving weapons",
                        useWhileDead = false,
                        canCancel = true,
                        controlDisables = {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        },
                        animation = {
                            animDict = "amb@prop_human_bum_bin@base",
                            anim = "base",
                        }
                        --prop = {
                        --    model = "prop_bomb_01_s",
                        --}
                    }, function(status)
                        if not status then
                            TriggerServerEvent('cfx_gangs:giveWeapon', gangName, weaponStock)
                        end

                    end)

                else
                    exports['mythic_notify']:DoLongHudText('error', 'Your gang armory is empty.') 
                end
            end, gangName)  

        elseif data.current.value == 'withdraw_item' then
            menu.close()
            OpenWithdrawItem(gangName)
        end
    end, function(data, menu)
        menu.close()
    end)  

end

function OpenWithdrawItem(gangName)
    ESX.TriggerServerCallback("cfx_stashes:getStashInventory", function(inventory)
        TriggerEvent('esx_inventoryhud:openStashInventory', inventory)
    end, ESX.GetPlayerData().identifier, gangName)   
end

RegisterNetEvent('cfx_gangs:closeMenus')
AddEventHandler('cfx_gangs:closeMenus', function()
    ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('cfx_gangs:AttemptGangStashBoltCutter')
AddEventHandler('cfx_gangs:AttemptGangStashBoltCutter', function()
    local closestGang = nil
    for gangName, gang in pairs(Config.Zone) do
        local pedCoords = GetEntityCoords(PlayerPedId())
        local StashDistance = GetDistanceBetweenCoords(pedCoords, gang.stashRaid.x, gang.stashRaid.y, gang.stashRaid.z, 1)

        if StashDistance < 2.0 then
            closestGang = gangName
            break
        end
    end

    if closestGang == nil then
        return
    end

    ESX.TriggerServerCallback('cfx_gangs:getGangInfo', function(isMember)
        if not isMember then
            TriggerServerEvent('cfx_gangs:raidStash', closestGang)
        else
            exports['mythic_notify']:DoLongHudText('error', 'You can not steal from your own gang stash.') 
        end
    end, closestGang)

end)

-- GANG ITEMS --

RegisterNetEvent('cfx_gangs:kevlar')
AddEventHandler('cfx_gangs:kevlar', function(policeVest)
    local playerPed = PlayerPedId()

    if policeVest then
        local finished = exports['np-butch_skillbar']:taskBar(2000, math.random(5, 7))
        if finished <= 0 then
          exports['mythic_notify']:DoLongHudText('error', 'Failed.')
          return
        end
    else
        local finished = exports['np-taskbarskill']:taskBar(1500, math.random(5, 7))
        if finished <= 0 then
          exports['mythic_notify']:DoLongHudText('error', 'Failed.')
          return
        end       

        local finished = exports['np-taskbarskill']:taskBar(1500, math.random(3, 4))
        if finished <= 0 then
          exports['mythic_notify']:DoLongHudText('error', 'Failed.')
          return
        end             
    end


    if policeVest then
        TriggerServerEvent('cfx_gangs:removeItem', 'policekevlar', 1)
    else
        TriggerServerEvent('cfx_gangs:removeItem', 'kevlar', 1)
    end

    SetPedArmour(playerPed, 100)
end)

-- GANGS --

-- DOORS --
local closeDoors = {}

Citizen.CreateThread(function()
    while true do

        for i = 1, #Config.DoorList, 1 do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = 1000

            if Config.DoorList[i].doors then
                distance = #(playerCoords - Config.DoorList[i].doors[1].objCoords)
            else
                distance = #(playerCoords - Config.DoorList[i].objCoords)
            end

            if distance <= 100.0 then
                if Config.DoorList[i] ~= nil then
                    closeDoors[i] = Config.DoorList[i]
                end
            else
                if closeDoors[i] ~= nil then
                    closeDoors[i] = nil
                end
            end
        end

        Citizen.Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
        for _,doorID in pairs(closeDoors) do
            if doorID.doors then
                for k,v in ipairs(doorID.doors) do
                    if not v.object or not DoesEntityExist(v.object) then
                        if type(v.objName) == "number" then
                            v.object = GetClosestObjectOfType(v.objCoords, 1.0, v.objName, false, false, false)
                        else
                            v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
                        end
                    end
                end
            else
                if not doorID.object or not DoesEntityExist(doorID.object) then
                    if type(doorID.objName) == "number" then
                        doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, doorID.objName, false, false, false)
                    else
                        doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('cfx_gangs:FixGangDoors')
AddEventHandler('cfx_gangs:FixGangDoors', function()
    if ESX.PlayerData.job.name ~= 'mechanic' then
        return
    end

    local playerCoords = GetEntityCoords(PlayerPedId())     
    local closestTimer = 999999

    for k,doorID in pairs(closeDoors) do
        local distance

        if doorID.doors then
            distance = #(playerCoords - doorID.doors[1].objCoords)
        else
            distance = #(playerCoords - doorID.objCoords)       
        end

        if distance < 2.0 and doorID.destroyed then
            local success = true
            RequestAnimDict("mini@repair")
            while not HasAnimDictLoaded("mini@repair") do
                Citizen.Wait(0)
            end
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_player", 8.0, -8, -1, 49, 0, 0, 0, 0)        

            for i = 1, 5, 1 do
                local finished = exports['np-taskbarskill']:taskBar(5000, math.random(3, 5))
                if finished <= 0 then
                    exports['mythic_notify']:DoCustomHudText ('error', 'Failed.' , 3000)
                    ClearPedTasks(PlayerPedId())
                    success = false
                    break
                end  
            end
            ClearPedTasks(PlayerPedId())    

            if success then     
                TriggerServerEvent('cfx_gangs:breakDoor', k, false)
            end         
        end
    end
end)

local lastDoorAccess = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())     
        local closestTimer = 999999

        for k,doorID in pairs(closeDoors) do
            local distance

            if doorID.doors then
                distance = #(playerCoords - doorID.doors[1].objCoords)
            else
                distance = #(playerCoords - doorID.objCoords)
            end

            --local isAuthorized = IsAuthorized(doorID)
            local maxDistance = 2

            if doorID.distance then
                maxDistance = doorID.distance
            end

            if distance < closestTimer then
                closestTimer = math.floor(distance)
            end              

            if distance < 50 then
                closestTimer = 0

                if doorID.doors then
                    for _,v in ipairs(doorID.doors) do
                        --v.object = GetClosestObjectOfType(v.objCoords, 1.0, GetHashKey(v.objName), false, false, false)
                        FreezeEntityPosition(v.object, doorID.locked)

                        if doorID.locked and v.objYaw and GetEntityRotation(v.object).z ~= v.objYaw then
                            SetEntityRotation(v.object, 0.0, 0.0, v.objYaw, 2, true)
                        end
                    end

                    -- Explosion
                    if IsExplosionInSphere(2, doorID.doors[1].objCoords.x, doorID.doors[1].objCoords.y, doorID.doors[1].objCoords.z, 5.0) then
                        TriggerServerEvent('cfx_gangs:forceOpen', k, false)
                        TriggerServerEvent('cfx_gangs:sendNews', streetName)
                        TriggerServerEvent('cfx_gangs:breakDoor', k, true)
                    end                    
                else
                    --doorID.object = GetClosestObjectOfType(doorID.objCoords, 1.0, GetHashKey(doorID.objName), false, false, false)
                    FreezeEntityPosition(doorID.object, doorID.locked)

                    if doorID.locked and doorID.objYaw and GetEntityRotation(doorID.object).z ~= doorID.objYaw then
                        SetEntityRotation(doorID.object, 0.0, 0.0, doorID.objYaw, 2, true)
                    end

                    -- Explosion
                    if IsExplosionInSphere(2, doorID.objCoords.x, doorID.objCoords.y, doorID.objCoords.z, 5.0) then
                        TriggerServerEvent('cfx_gangs:forceOpen', k, false)
                        TriggerServerEvent('cfx_gangs:sendNews', streetName)
                        TriggerServerEvent('cfx_gangs:breakDoor', k, true)
                    end                     
                end
            end

            if distance < maxDistance then
                if IsControlJustReleased(0, 38) then

                    if not doorID.destroyed then
                        ESX.TriggerServerCallback('cfx_gangs:getGangInfo', function(isMember)

                            if isMember then
                                if lastDoorAccess[doorID] == nil then
                                    lastDoorAccess[doorID] = 0
                                end

                                if ( GetGameTimer() - lastDoorAccess[doorID] ) < 1000 and not doorID.destroyed then
                                    local luck = math.random(100)

                                    if luck < 15 then
                                        TriggerServerEvent('cfx_gangs:breakDoor', k, true)
                                        exports['mythic_notify']:DoLongHudText('inform', 'Ayee! You broke the door knob.')
                                    end
                                end

                                lastDoorAccess[doorID] = GetGameTimer()
                                doorID.locked = not doorID.locked
                            end
                            if doorID.locked then
                                exports['mythic_notify']:DoLongHudText('inform', 'Door locked.')
                            else
                                exports['mythic_notify']:DoLongHudText('inform', 'Door unlocked.')
                            end
                            TriggerServerEvent('cfx_gangs:updateState', k, doorID.locked, isMember)
                        end, closeDoors[k].gangName) 
                    else
                        exports['mythic_notify']:DoLongHudText('inform', 'Door lock is broken.')
                    end                   
                end         
            end

        end

        if closestTimer > 50 and closestTimer ~= 999999 then
            Citizen.Wait(5000)
        end          
    end
end)

RegisterNetEvent('cfx_gangs:sendNewsToAll')
AddEventHandler('cfx_gangs:sendNewsToAll', function(streetName)
    ESX.Scaleform.ShowBreakingNews("EXPLOSION", "EXPLOSION AT " .. streetName, bottom, 3)
end)

RegisterNetEvent('cfx_gangs:breachDoor')
AddEventHandler('cfx_gangs:breachDoor', function(doorID, state)

    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = 25000,
        label = "Breaching the door...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "missheistfbi3b_ig7",
            anim = "lift_fibagent_loop",
        }
        --prop = {
        --    model = "prop_paper_bag_small",
        --}
    }, function(status)
        if not status then
            TriggerServerEvent('cfx_gangs:breachDoor', doorID, state)
            exports['mythic_notify']:DoLongHudText('success', 'You have breached the door')            
        end

    end)    

end)


-- Set state for a door
RegisterNetEvent('cfx_gangs:setState')
AddEventHandler('cfx_gangs:setState', function(doorID, state)
    Config.DoorList[doorID].locked = state
end)

RegisterNetEvent('cfx_gangs:breakDoor')
AddEventHandler('cfx_gangs:breakDoor', function(doorID, state)
    Config.DoorList[doorID].destroyed = state
    Config.DoorList[doorID].locked = false
end)

-- END OF DOORS --

-- START OF GANGS --


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local isClose = false

        for gangName, gang in pairs(Config.Zone) do
            local ProcessDistance1 = GetDistanceBetweenCoords(playerCoords, gang.process1.x, gang.process1.y, gang.process1.z, 1)
            local ProcessDistance2 = GetDistanceBetweenCoords(playerCoords, gang.process2.x, gang.process2.y, gang.process2.z, 1)
            local ArmoryDistance = GetDistanceBetweenCoords(playerCoords, gang.armory.x, gang.armory.y, gang.armory.z, 1)
            local DeliveryDistance = GetDistanceBetweenCoords(playerCoords, gang.setDelivery.x, gang.setDelivery.y, gang.setDelivery.z, 1)
            local StashDistance = GetDistanceBetweenCoords(playerCoords, gang.stashRaid.x, gang.stashRaid.y, gang.stashRaid.z, 1)
            -- local RedZoneDistance = GetDistanceBetweenCoords(playerCoords, gang.redZone.x, gang.redZone.y, gang.redZone.z, 1)
            local weaponStock = Config.Zone[gangName].weaponStock

            if ProcessDistance1 <= 1.0 then
                isClose = true
                Draw3DText(gang.process1.x, gang.process1.y, gang.process1.z, gang.processText1)

                if IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback('cfx_gangs:getGangInfo', function(isMember, canProcess)
                        if isMember or canProcess then
                            ESX.TriggerServerCallback('cfx_gangs:getItemStock', function(itemStock, currentGang)
                                if itemStock < gang.amount and gangName == currentGang then
                                    exports['mythic_notify']:DoLongHudText('error', 'Your gang is out of resources.')
                                else
                                    local item = gang.item1
                                    TriggerServerEvent('cfx_gangs:checkHarvester', gangName, item, itemStock, gang.amount, currentGang) 
                                end
                            end, gangName) 
                        else
                            exports['mythic_notify']:DoLongHudText('error', 'You are not a member of this gang.') 
                        end
                    end, gangName) 
                end
            end

            if ProcessDistance2 <= 1.0 then
                isClose = true
                Draw3DText(gang.process2.x, gang.process2.y, gang.process2.z, gang.processText2)

                if IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback('cfx_gangs:getGangInfo', function(isMember, canProcess)
                        if isMember or canProcess then
                            local item = gang.item2
                            TriggerServerEvent('cfx_gangs:checkHarvester', gangName, item)
                        else
                            exports['mythic_notify']:DoLongHudText('error', 'You are not a member of this gang.') 
                        end
                    end, gangName) 
                end
            end

            if ArmoryDistance <= 1.0 then
                isClose = true
                Draw3DText(gang.armory.x, gang.armory.y, gang.armory.z, '[E] Stash')

                if IsControlJustReleased(0, 38) then

                    ESX.TriggerServerCallback('cfx_gangs:getGangInfo', function(isMember, canProcess)
                        if isMember or canProcess or (ESX.PlayerData.job.name == "police" and ESX.PlayerData.job.grade >= 2)  then
                            OpenStashMenu(gangName)
                        else
                            exports['mythic_notify']:DoLongHudText('error', 'You are not a member of this gang.') 
                        end
                    end, gangName) 
                    
                end
            end

            if DeliveryDistance <= 1.0 then
                isClose = true
                Draw3DText(gang.setDelivery.x, gang.setDelivery.y, gang.setDelivery.z, '[E] Set Up a Gang Delivery')

                if IsControlJustReleased(0, 38) then
                    ESX.TriggerServerCallback('cfx_gangs:getGangInfo', function(isMember)
                        if isMember then
                            local item = gang.item2
                            if checkHasItem(item, Config.Zone[gangName].requiredItem) then
                                TriggerServerEvent('cfx_gangs:setupDelivery', gangName, item)
                            else
                                exports['mythic_notify']:DoLongHudText('error', 'You do not have enough materials.') 
                            end
                        else
                            exports['mythic_notify']:DoLongHudText('error', 'You are not a member of this gang.') 
                        end
                    end, gangName)                
                end
            end

            if StashDistance <= 3.0 then
                isClose = true
                DrawMarker(27, gang.stashRaid.x, gang.stashRaid.y, gang.stashRaid.z - 0.85, 0, 0, 0, 0, 0, 0, 0.60, 0.60, 0.3, 115, 15, 12, 60, 0, 0, 2, 0, 0, 0, 0)
            end

        end

        if not isClose then
            Citizen.Wait(3000)
        end

    end
end)

RegisterNetEvent('cfx_gangs:harvestItem')
AddEventHandler('cfx_gangs:harvestItem', function(gangName, item, itemStock, amount, currentGang)
    local ProcessTime = 0

    if item == Config.Zone[gangName].item1 then
        ProcessTime = Config.Zone[gangName].processWait1
    elseif item == Config.Zone[gangName].item2 then
        ProcessTime = Config.Zone[gangName].processWait2
    end

    if gangName ~= currentGang then
        if ProcessTime <= 15000 then
            ProcessTime = ProcessTime + 15000
        elseif ProcessTime >= 30000 then
            ProcessTime = ProcessTime + 30000
        end
    end

    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = ProcessTime,
        label = Config.Zone[gangName].label1,
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = Config.Zone[gangName].dict1,
            anim = Config.Zone[gangName].anim1,
        }
        --prop = {
        --    model = "prop_bomb_01_s",
        --}
    }, function(status)
        if not status then
            if item == Config.Zone[gangName].item1 then
                TriggerServerEvent('cfx_gangs:receiveItem', item, amount)
            elseif item == Config.Zone[gangName].item2 then
                if checkHasItem(Config.Zone[gangName].item1, Config.Zone[gangName].requiredItem2) then
                    TriggerServerEvent('cfx_gangs:receiveItem', item, 1)
                    TriggerServerEvent('cfx_gangs:removeItem', Config.Zone[gangName].item1, Config.Zone[gangName].requiredItem2)
                else
                    exports['mythic_notify']:DoLongHudText('error', 'You do not have the required item.') 
                end
            end

            TriggerServerEvent('cfx_gangs:clearGangHarvester', gangName, item)
        else
            TriggerServerEvent('cfx_gangs:clearGangHarvester', gangName, item)
        end

    end)

end)

RegisterNetEvent('cfx_gangs:getStash')
AddEventHandler('cfx_gangs:getStash', function(gangName, itemToRaid)
    local robbing = true
    local chance2break = math.random(1, 100)

    for i = 1, math.random(2, 3), 1 do
        local finished = exports['np-taskbarskill']:taskBar(5000, math.random(5, 7))
        if finished <= 0 then
            TriggerServerEvent('cfx_gangs:removeGangItem', 'bolt_cutter')  
            exports['mythic_notify']:DoLongHudText('inform', 'You break the bolt cutter.')      
            return
        end
    end

    if chance2break < 15 then
        TriggerServerEvent('cfx_gangs:removeGangItem', 'bolt_cutter')  
        exports['mythic_notify']:DoLongHudText('inform', 'You break the bolt cutter.')
    end

    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = Config.Zone[gangName].raidTime,
        label = "Robbing gang stash...",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "amb@prop_human_bum_bin@base",
            anim = "base",
        }
        --prop = {
        --    model = "prop_bomb_01_s",
        --}
    }, function(status)
        if not status then
            ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(isDead)
                if not isDead then
                    TriggerServerEvent('cfx_gangs:giveStash', gangName, itemToRaid)
                else
                    exports['mythic_notify']:DoLongHudText('error', 'Failed to rob the stash.')
                end
            end)
        else
            TriggerServerEvent('cfx_gangs:cancelledRobbing', gangName)
        end
        robbing = false
    end)  

    while robbing do 
        Citizen.Wait(0)
        local pedCoords = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(pedCoords, Config.Zone[gangName].stashRaid.x, Config.Zone[gangName].stashRaid.y, Config.Zone[gangName].stashRaid.z, 1)

        if dist > 5.0 then
            exports['mythic_notify']:DoLongHudText('error', 'Too far away from stash.')

            TriggerServerEvent('cfx_gangs:cancelledRobbing', gangName)
            TriggerEvent('mythic_progbar:client:cancel')
            robbing = false
        elseif IsEntityPlayingAnim(GetPlayerPed(-1), 'dead', 'dead_a', 1) then
            exports['mythic_notify']:DoLongHudText('error', 'Failed to rob the stash.')

            TriggerServerEvent('cfx_gangs:cancelledRobbing', gangName)
            TriggerEvent('mythic_progbar:client:cancel')
            robbing = false            
        end
    end 

end)

-- GANG DELIVERY --
delivery_is_running = false
delivery_destination = nil
delivery_vehicle = nil
delivery_gang = nil
vehicle_plate = nil
delivery_blip = nil


RegisterNetEvent('cfx_gangs:spawnVehicle')
AddEventHandler('cfx_gangs:spawnVehicle', function(gangName)
    local myPed = GetPlayerPed(-1)
    local player = PlayerPedId()
    local vehicle = "gburrito2"

    RequestModel(vehicle)

    while not HasModelLoaded(vehicle) do 
        Wait(1)
    end

    local spawned_car = CreateVehicle(vehicle, Config.Zone[gangName].spawnDelivery.x, Config.Zone[gangName].spawnDelivery.y, Config.Zone[gangName].spawnDelivery.z , false, true)    

    SetEntityHeading(spawned_car, Config.Zone[gangName].spawnDelivery.h)
    SetVehicleOnGroundProperly(spawned_car)
    SetPedIntoVehicle(myPed, spawned_car, - 1)
    SetModelAsNoLongerNeeded(vehicle)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
    CruiseControl = 0
    DTutOpen = false
    SetEntityVisible(myPed, true)
    FreezeEntityPosition(myPed, false)
    local veh = spawned_car
    plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    
    TriggerServerEvent('garage:addKeys', plate)
    cop_alert = true

    TriggerServerEvent('cfx_gangs:getWayPoint', gangName, veh, plate)    

end)

RegisterNetEvent('cfx_gangs:setWayPoint')
AddEventHandler('cfx_gangs:setWayPoint', function(gangName, veh, plate, deliveryPoint)

    delivery_is_running = true
    delivery_destination = deliveryPoint
    delivery_vehicle = veh
    vehicle_plate = plate
    delivery_gang = gangName

end)

RegisterNetEvent('cfx_gangs:resetDelivery')
AddEventHandler('cfx_gangs:resetDelivery', function()
    RemoveBlip(delivery_blip)
    delivery_is_running = false
    delivery_destination = nil
    delivery_vehicle = nil
    delivery_gang = nil
    vehicle_plate = nil
    delivery_blip = nil    
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if delivery_is_running and GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == vehicle_plate then

            if GetVehicleEngineHealth(delivery_vehicle) < 150 and delivery_vehicle ~= nil then
                TriggerServerEvent('cfx_gangs:resetDelivery')
                SetEntityAsNoLongerNeeded(delivery_vehicle)
                SetEntityAsMissionEntity(delivery_vehicle,true,true)
                DeleteEntity(delivery_vehicle)

                exports['mythic_notify']:DoLongHudText('error', 'Your package inside has been destroyed')

            end

            if GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false)) == vehicle_plate then
                if not DoesBlipExist(delivery_blip) then
                    delivery_blip = AddBlipForCoord(delivery_destination.x,delivery_destination.y,delivery_destination.z)
                    SetBlipSprite(delivery_blip,351)
                    SetBlipColour(delivery_blip,5)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString('Gang Delivery')
                    EndTextCommandSetBlipName(delivery_blip)
                    SetBlipRoute(delivery_blip, 1)
                end
            end
        end                 

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        
        local pos = GetEntityCoords(GetPlayerPed(-1), false)
        local pVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

        if delivery_is_running then

            if GetVehicleNumberPlateText(pVehicle) == vehicle_plate and GetPedInVehicleSeat(pVehicle, -1) == GetPlayerPed(-1)  then

                local dpos = delivery_destination
                local delivery_point_distance = Vdist(dpos.x, dpos.y, dpos.z, pos.x, pos.y, pos.z)
                if delivery_point_distance < 50.0 then
                    DrawMarker(1, dpos.x, dpos.y, dpos.z,0, 0, 0, 0, 0, 0, 3.5, 3.5, 3.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
                    if delivery_point_distance < 1.5 then
                        local vehicle = GetVehiclePedIsUsing(GetPlayerPed(-1))

                        SetEntityAsNoLongerNeeded(vehicle)
                        SetEntityAsMissionEntity(vehicle,true,true)
                        DeleteEntity(vehicle)

                        TriggerServerEvent('cfx_gangs:completeDelivery', delivery_gang)                     
                    end
                end
            end
        else
            Citizen.Wait(2000)
        end
    end
end)

-- END OF GANGS


-- FUNCTIONS --
function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 75)
end

function DrawMissionText(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function checkHasItem(item_name, qty)
    local inventory = ESX.GetPlayerData().inventory
    for i=1, #inventory do
        local item = inventory[i]
        if item_name == item.name and item.count >= qty then
            return true
        end
    end
    return false
end
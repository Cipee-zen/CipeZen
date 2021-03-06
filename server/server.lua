local path = GetResourcePath(GetCurrentResourceName())
local CZPlayersLoad = {}
CZ = {}

CZServerCallBack = {}
CipeZenPlayers = {}
CipeZenItems = {}
CipeZenUniqueItems = {}

RegisterServerEvent("InitializeCipeZenFrameWork")
RegisterServerEvent("CZ:requestExistCallback")
RegisterServerEvent("CZ:returnRequstExistCallback")
RegisterServerEvent("CipeZen:playerLoad")
RegisterServerEvent("CipeZen:updatePlayerCoords")
RegisterServerEvent("CZ:addInventoryItem")
AddEventHandler("InitializeCipeZenFrameWork", function(cb)
    if CZ then
        local cz = CZDuplicateObject(CZ)
        cb(CZ)
    end
end)
AddEventHandler("onResourceStop", function(resource)
    for k,v in pairs(CZServerCallBack) do
        if type(v.CB) ~= "function" and string.find(v.CB.__cfx_functionReference,resource) then
            v = nil
        end
    end
    if #CZServerCallBack == 1 then
        if type(CZServerCallBack[1].CB) ~= "function" and string.find(CZServerCallBack[1].CB.__cfx_functionReference,resource) then
            CZServerCallBack = {}
        end
    end
end)
AddEventHandler("CZ:requestExistCallback", function(_idcallback,callbackname,...)
    local source = source
    local idcallback = _idcallback
    function CB(...)
        TriggerClientEvent("CZ:returnRequstExistCallback", source, idcallback,true,...)
    end
    if CZServerCallBack[callbackname] then
        CZServerCallBack[callbackname].CB(source,CB,...)
    else
        TriggerClientEvent("CZ:returnRequstExistCallback", source, idcallback,false)
    end
end)
AddEventHandler("CipeZen:playerLoad",function()
    LoadAllSuggestion(source)
    local license = CZGetIdentifiers(source)[Config.identifer]
    if not CZPlayersLoad[license] then
        CZPlayersLoad[license] = true
        local source = source
        MySQL.ready(function ()
            CipeZenLoadPlayer(source)
            TriggerEvent("CZ:playerLoad", source)
        end)
    else
        print("The player"..GetPlayerName(source).." try to trigger another time the player load event")
        CZPrint(CZGetIdentifiers(source))
        DropPlayer(source, "You try to trigger another time the player load event")
    end
end)
AddEventHandler("CipeZen:updatePlayerCoords",function(coords)
    MySQL.Async.execute('UPDATE players SET position = @position WHERE rockstarlicense = @rockstarlicense', {
        ["@rockstarlicense"] = CZGetIdentifiers(source)[Config.identifer],
        ["@position"] = json.encode(coords),
    })
end)
AddEventHandler("CZ:addInventoryItem",function (id,name,count)
end)
AddEventHandler("playerDropped",function(reason)
    local source = source
    local license = CZGetIdentifiers(source)[Config.identifer]
    CZPlayersLoad[license] = nil
end)
AddEventHandler("playerConnecting", function(name,setKickReason,deferrals)
    local player = source
    local identifiers = CZGetIdentifiers(player)
    deferrals.defer()

    Wait(0)

    deferrals.update(string.format("Hello %s. Your %s ID is being checked.", name,Config.identifer))

    Wait(100)

    if not identifiers[Config.identifer] then
        deferrals.done("Your "..Config.identifer.." ID is not connected.")
    else
        deferrals.done()
    end
end)

function CZDuplicateObject(orig,copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[CZDuplicateObject(orig_key, copies)] = CZDuplicateObject(orig_value, copies)
            end
            setmetatable(copy, CZDuplicateObject(getmetatable(orig), copies))
        end
    else
        copy = orig
    end
    return copy
end

function CZPrint(a)
    local text = ""
    if a then
        if type(a) == "number" then
            text = "["..tostring(a).."]"
        elseif type(a) == "string" then
            text = "['"..tostring(a).."']"
        elseif type(a) == "table" then
            text = text .. CipeZenReturnArrayText(0,a)
        else 
            text = "["..tostring(a).."]"
        end
    else
        if a == nil then
            text = "[nil]"
        elseif a == false then
            text = "[false]"
        elseif a == true then
            text = "[true]"
        else
            if type(a) == "number" then
                text = "["..tostring(a).."]"
            elseif type(a) == "string" then
                text = "['"..tostring(a).."']"
            end
        end
    end
    print("CipeZen Print: \n"..text)
end 

function CipeZenReturnArrayText(spacen,a)
    local space = ""
    local text = ""
    for i=1,spacen do
        space = space .. " "
    end
    local count = 0
    for k,v in pairs(a) do
        count = count + 1
        local extra = "\n"
        if type(v) == "table" then
            if count ~= 1 then
                text = text ..space.."???["..k.."]???" ..extra..CipeZenReturnArrayText(spacen + 1,v)
            else
                text = text ..space.."???["..k.."]" ..extra..CipeZenReturnArrayText(spacen + 1,v)
            end
        else
            extra = ",\n"
            if count ~= 1 then
                if type(v) == "number" then
                    text = text ..space.."???["..k.."]??? = " .. tostring(v)..extra
                elseif type(v) == "string" then
                    text = text ..space.."???["..k.."]??? = " .. "'"..tostring(v).."'"..extra
                else
                    text = text ..space.."???["..k.."]??? = " .. tostring(v)..extra
                end
            else
                if type(v) == "number" then
                    text = text ..space.. "???["..k.."] = "..tostring(v)..extra
                elseif type(v) == "string" then
                    text = text ..space.. "???["..k.."] = '"..tostring(v)..extra
                else
                    text = text ..space.. "???["..k.."] = "..tostring(v)..extra
                end
            end
        end
    end
    if #text == 0 then
        text = space .. "???{}\n"
    end
    return text
end

function CZRegisterCallback(callbackname,cb)
    if CZServerCallBack[callbackname] then
        print("[CipeZen][ALLERT]The callback \'"..callbackname.."\' will be overwritten with a new function!")
    end
    CZServerCallBack[callbackname] = {CB = cb}
end

function CZTriggerCallback(name,_to,cb,...)
    local to = _to
    local id = math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)
    TriggerClientEvent("CZ:requestExistCallback",to,id,name,...)
    AddEventHandler("CZ:returnRequstExistCallback",function(_id,exist,...)
        if id == _id then
            if not exist then
                print("[CipeZen][ERROR]The callback \'"..name.."\' not exist !")
            else
                cb(...)
            end
        end
    end)
end

function CZTry(access,negate)
    local status, result = pcall(access)
    if not status then
        negate(result)
    end
    return result
end

function CZGetIdentifiers(id)
    local identifiers = {}
    for i = 0,7 do
        local identifier = GetPlayerIdentifier(id,i)
        if identifier then
            local extracted1 = string.match(identifier, "(.*):")
            local extracted2 = string.match(identifier, ":(.*)")
            identifiers[extracted1] = extracted2
        end
    end
    return identifiers
end

function CipeZenLoadPlayer(id)
    local player = {}
    player.License = CZGetIdentifiers(id)[Config.identifer]
    local playerData = MySQL.Sync.fetchAll('SELECT * FROM players WHERE rockstarlicense = @license',{["@license"] = player.License})
    player.Job = {JobName = "unemployed",JobLabel = "Unemployed",Grade = 0,GradeLabel = "Unemployed",GradeName = "unemployed"}
    player.Inventory = {}
    player.Money = {money = 0,bankmoney = 0,dirtymoney = 0}
    player.LastPosition = {}
    player.Weapons = {}
    player.Permission = "player"

    if playerData and #playerData > 0 then 
        player.LastPosition = json.decode(playerData[1].position)
        player.Permission = playerData[1].permission
        for k,v in pairs(json.decode(playerData[1].inventory)) do
            if v.id then
                if CipeZenUniqueItems[tostring(v.id)] then
                    local item = CZDuplicateObject(CipeZenUniqueItems[tostring(v.id)])
                    item.count = 1
                    item.limit = 1
                    player.Inventory[tostring(v.id)] = item
                end
            else
                if CipeZenItems[v.name] then
                    local item = CZDuplicateObject(CipeZenItems[v.name])
                    item.count = tonumber(v.count)
                    item.other = item.other
                    player.Inventory[v.name] = item
                end
            end
        end
    else
        MySQL.Async.execute('INSERT INTO players (rockstarlicense,money,position,permission,inventory,weapons,job,jobgrade) VALUES(@rockstarlicense,@money,@position,@permission,@inventory,@weapons,@job,@jobgrade)',{
            ['@rockstarlicense'] = player.License,
            ['@money'] = json.encode(player.Money),
            ['@position'] = json.encode(Config.SpawnPosition ),
            ['@permission'] = "player",
            ['@inventory'] = json.encode(player.Inventory),
            ['@weapons'] = json.encode(player.Weapons),
            ['@job'] = player.Job.JobName,
            ['@jobgrade'] = player.Job.Grade,
        }, function (result2)
        end)
        player.LastPosition = Config.SpawnPosition
    end
    local ped = GetPlayerPed(id)
    SetEntityCoords(ped,player.LastPosition.x,player.LastPosition.y,player.LastPosition.z)
    SetEntityHeading(ped, player.LastPosition.h)
    ExecuteCommand(('remove_principal identifier.%s:%s group.%s'):format(Config.identifer,player.License, "player"))
    ExecuteCommand(('remove_principal identifier.%s:%s group.%s'):format(Config.identifer,player.License, "admin"))
    ExecuteCommand(('add_principal identifier.%s:%s group.%s'):format(Config.identifer,player.License, player.Permission))
    CipeZenPlayers[player.License] = player
end

function CipeZenAddMoney(id,money,count)
    local license = CZGetIdentifiers(id)[Config.identifer]
    if not CipeZenPlayers[license].Money then
        CipeZenPlayers[license].Money = {money = 0,bankmoney = 0,dirtymoney = 0}
    end
    CipeZenPlayers[license].Money[money] = CipeZenPlayers[license].Money[money] + count
    MySQL.Async.execute('UPDATE players SET money = @money WHERE rockstarlicense = @rockstarlicense', {
        ["@rockstarlicense"] = license,
        ["@money"] = json.encode(CipeZenPlayers[license].Money)
    })
    return true
end

function CipeZenRemoveMoney(id,money,count)
    local license = CZGetIdentifiers(id)[Config.identifer]
    if not CipeZenPlayers[license].Money then
        CipeZenPlayers[license].Money = {money = 0,bankmoney = 0,dirtymoney = 0}
    end
    CipeZenPlayers[license].Money[money] = CipeZenPlayers[license].Money[money] - count
    if CipeZenPlayers[license].Money[money] < 0 then
        CipeZenPlayers[license].Money[money] = 0
    end
    MySQL.Async.execute('UPDATE players SET money = @money WHERE rockstarlicense = @rockstarlicense', {
        ["@rockstarlicense"] = license,
        ["@money"] = json.encode(CipeZenPlayers[license].Money)
    })
    return true
end

function CZGetPlayerFromId(_id)
    if tonumber(_id) and GetPlayerName(tonumber(_id)) then
        local player = {}
        local id = tonumber(_id)
        player.Identifiers = CZGetIdentifiers(id)
        player.Id = id
        player.Name = GetPlayerName(id)
        player.Ped = GetPlayerPed(id)
        player.Job = nil
        player.Inventory = {}
        player.Money = {money = 0,bankmoney = 0,dirtymoney = 0}
        player.Permission = "player"
        player.AddMoney = function (money,count)
            return CipeZenAddMoney(_id,money,count)
        end
        player.RemoveMoney = function (money,count)
            return CipeZenRemoveMoney(_id,money,count)
        end
        player.AddUniqueItem = function (uniqueid)
            return CipeZenAddUniqueItem(_id,uniqueid)
        end
        player.RemoveUniqueItem = function (uniqueid)
            return CipeZenRemoveUniqueItem(_id,uniqueid)
        end
        player.AddItem = function (name,count)
            return CipeZenAddItem(_id,name,count)
        end
        player.RemoveItem = function (name,count)
            return CipeZenRemoveItem(_id,name,count)
        end
        player.GetItem = function (name)
            if player.Inventory[name] then
                player.Inventory[name].count = tonumber(player.Inventory[name].count)
                return player.Inventory[name]
            end
            return nil
        end 
        while not CipeZenPlayers[player.Identifiers[Config.identifer]] do
            Wait(10)
        end
        if CipeZenPlayers[player.Identifiers[Config.identifer]] then
            player.Money = CipeZenPlayers[player.Identifiers[Config.identifer]].Money
            player.Job = CipeZenPlayers[player.Identifiers[Config.identifer]].Job
            player.Inventory = CipeZenPlayers[player.Identifiers[Config.identifer]].Inventory
            player.Permission = CipeZenPlayers[player.Identifiers[Config.identifer]].Permission
        end
        return player
    end
end

function GetAllVehicleInRange(id,range)
    local vehicles = GetAllVehicles()
    local findVehicles = {}
    local pedPos = GetEntityCoords(GetPlayerPed(id))
    for k,v in pairs(vehicles) do
        local pos = GetEntityCoords(v)
        if #(pedPos - pos) <= tonumber(range) then
            table.insert(findVehicles,v)
        end
    end
    return findVehicles
end

function CZChangePermission(id,group)
    local license = CZGetIdentifiers(id)[Config.identifer]
    local lastGroup = CipeZenPlayers[license].Permission
    ExecuteCommand(('remove_principal identifier.%s:%s group.%s'):format(Config.identifer,license, lastGroup))
    CipeZenPlayers[license].Permission = group
    ExecuteCommand(('add_principal identifier.%s:%s group.%s'):format(Config.identifer,license, group))
    MySQL.Async.execute('UPDATE players SET permission = @permission WHERE rockstarlicense = @rockstarlicense', {
        ["@rockstarlicense"] = license,
        ["@permission"] = group
    })
    TriggerClientEvent("CZ:updatePermission", id,group )
end

function CZGetItem(name)
    if CipeZenItems[name] then
        return CZDuplicateObject(CipeZenItems[name])
    else
        return nil
    end
end

function CZCreateUniqueItem(cb,name,label,description,weight,other,owner)
    local playerId = CZGetPlayerIdFromIdentifier(owner)
    if owner then
        if not playerId then
            CZ.Print("[CipeZen][ERROR] Player '"..owner.."' not online !")
            cb(nil)
            return
        end
    end
    MySQL.Async.execute('INSERT INTO uniqueitems (name,label,description,other,owner,weight) VALUES(@name,@label,@description,@other,@owner,@weight)',{
        ['@name'] = name,
        ['@label'] = label,
        ['@description'] = description or "",
        ['@other'] = json.encode(other) or nil,
        ['@weight'] = weight,
        ['@owner'] = nil,
    }, function (result2)
        local id = MySQL.Sync.fetchAll('SELECT * FROM uniqueitems')
        id[#id].other = json.decode(id[#id].other)
        id[#id].limit = 1
        CipeZenUniqueItems[tostring(id[#id].id)] = id[#id]
        if owner then
            CipeZenAddUniqueItem(playerId,id[#id].id)
        end
        cb(id[#id])
    end)
end

function CZGetPlayerIdFromIdentifier(license)
    local players = GetPlayers()
    for k,v in pairs(players) do
        local l = CZGetIdentifiers(v)[Config.identifer]
        if l == license then
            return v
        end
    end
    return nil
end

function CZGetUniqueItem(id)
    if CipeZenUniqueItems[tostring(id)] then
        return CZDuplicateObject(CipeZenUniqueItems[tostring(id)])
    else
        return nil
    end
end

function CZEditUniqueItem(id,name,label,weight,description,other)
    local tid = tostring(id)
    if CipeZenUniqueItems[tid] then
        CipeZenUniqueItems[tid].name = name
        CipeZenUniqueItems[tid].label = label
        CipeZenUniqueItems[tid].description = description or ""
        CipeZenUniqueItems[tid].weight = weight
        CipeZenUniqueItems[tid].other = other or {}
        if other then
            other = json.encode(other)
        end
        local uniqItem = CZGetUniqueItem(tid)
        if uniqItem.owner then
            local player = CipeZenPlayers[uniqItem.owner]
            if player then
                player.Inventory[tid] = CipeZenUniqueItems[tid]
                player.Inventory[tid].count = 1
                MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE rockstarlicense = @rockstarlicense', {
                    ["@rockstarlicense"] = uniqItem.owner,
                    ["@inventory"] = json.encode(player.Inventory)
                })
            end
        end

        MySQL.Async.execute('UPDATE uniqueitems SET name = @name,label = @label,weight = @weight,description = @description,other = @other WHERE id = @id', {
            ["@name"] = name,
            ["@label"] = label,
            ["@weight"] = weight,
            ["@description"] = description or "",
            ["@other"] = other or "[]",
            ["@id"] = tid
        })  
    else
        return false
    end
end

function CZDeleteUniqueItem(id)
    local tid = tostring(id)
    if CipeZenUniqueItems[tid] then
        if CipeZenUniqueItems[tid].owner then
            local playerId = CZGetPlayerIdFromIdentifier(CipeZenUniqueItems[tid].owner)
            if playerId then
                CipeZenRemoveUniqueItem(playerId,tid)
            end
        end
        MySQL.Async.execute('DELETE FROM uniqueitems WHERE id = @id', {
            ["@id"] = tid
        })
        CipeZenUniqueItems[tid] = nil
    else
        return false
    end
end

function CipeZenRemoveUniqueItem(id,uniqueitem)
    local license = CZGetIdentifiers(id)[Config.identifer]
    local player = CipeZenPlayers[license]
    if uniqueitem and tostring(uniqueitem) then
        if player.Inventory[tostring(uniqueitem)] then
            player.Inventory[tostring(uniqueitem)] = nil
            MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE rockstarlicense = @rockstarlicense', {
                ["@rockstarlicense"] = license,
                ["@inventory"] = json.encode(player.Inventory)
            })
            MySQL.Async.execute('UPDATE uniqueitems SET owner = @owner WHERE id = @id', {
                ["@owner"] = nil,
                ["@id"] = uniqueitem
            })
            CipeZenUniqueItems[tostring(uniqueitem)].owner = nil
            TriggerEvent("CZ:removeInventoryItem",id,uniqueitem,1,uniqueitem)
            return true
        else
            CZ.Print("[CipeZen][ERROR] don't have this items with unique id: \'"..uniqueitem.."\' !")
            return false
        end
    end
end

function CipeZenRemoveItem(id,name,_count)
    if name then
        local count = tonumber(_count)
        local license = CZGetIdentifiers(id)[Config.identifer]
        local player = CipeZenPlayers[license]
        if player.Inventory[name] then
            if tonumber(player.Inventory[name].count) >= count then
                player.Inventory[name].count = tonumber(player.Inventory[name].count) - count
                if player.Inventory[name].count <= 0 then
                    player.Inventory[name] = nil
                end
                MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE rockstarlicense = @rockstarlicense', {
                    ["@rockstarlicense"] = license,
                    ["@inventory"] = json.encode(player.Inventory)
                })
                TriggerEvent("CZ:removeInventoryItem",id,name,count)
                return true
            else
                CZ.Print("[CipeZen][ERROR]don't have enought "..name.." !")
                return false
            end
        else
            CZ.Print("[CipeZen][ERROR] don't have \'"..name.."\' !")
            return false
        end
    end
end

function CipeZenAddUniqueItem(id,uniqueitem)
    local license = CZGetIdentifiers(id)[Config.identifer]
    local player = CipeZenPlayers[license]
    local tid = tostring(uniqueitem)
    if CipeZenUniqueItems[tid] and not CipeZenUniqueItems[tid].owner then
        CipeZenUniqueItems[tid].owner = license
        local item = CZGetUniqueItem(uniqueitem)
        item.count = 1
        player.Inventory[tid] = item
        MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE rockstarlicense = @rockstarlicense', {
            ["@rockstarlicense"] = license,
            ["@inventory"] = json.encode(player.Inventory)
        })
        MySQL.Async.execute('UPDATE uniqueitems SET owner = @owner WHERE id = @id', {
            ["@owner"] = license,
            ["@id"] = uniqueitem
        })
        TriggerEvent("CZ:addInventoryItem",id,uniqueitem,1,uniqueitem)
        return true
    else
        return false
    end
end

function CipeZenAddItem(id,name,count)
    local license = CZGetIdentifiers(id)[Config.identifer]
    local item = CZGetItem(name)
    count = tonumber(count)
    if item then
        if CipeZenPlayers[license].Inventory[name] then
            CipeZenPlayers[license].Inventory[name].count = tonumber(CipeZenPlayers[license].Inventory[name].count) + count
        else
            item.count = count
            CipeZenPlayers[license].Inventory[name] = item
        end
        MySQL.Async.execute('UPDATE players SET inventory = @inventory WHERE rockstarlicense = @rockstarlicense', {
            ["@rockstarlicense"] = license,
            ["@inventory"] = json.encode(CipeZenPlayers[license].Inventory)
        })
        TriggerEvent("CZ:addInventoryItem",id,name,count)
        return true
    else
        CZ.Print("[CipeZen][ERROR]This item doesn't exist !")
        return false
    end
end

CZ.GetUniqueItem = CZGetUniqueItem
CZ.RegisterCallback = CZRegisterCallback
CZ.ChangePermission = CZChangePermission
CZ.TriggerCallback = CZTriggerCallback
CZ.GetIdentifiers = CZGetIdentifiers
CZ.GetItem = CZGetItem
CZ.Print = CZPrint
CZ.DuplicateObject = CZDuplicateObject
CZ.GetPlayerFromId = CZGetPlayerFromId
CZ.Try = CZTry
CZ.CreateUniqueItem = CZCreateUniqueItem
CZ.GetPlayerIdFromIdentifier = CZGetPlayerIdFromIdentifier
CZ.EditUniqueItem = CZEditUniqueItem
CZ.DeleteUniqueItem = CZDeleteUniqueItem

CZRegisterCallback("cz:getPlayerData",function(source,cb)
    cb(CZGetPlayerFromId(source))
end)

MySQL.ready(function ()
    local items = MySQL.Sync.fetchAll('SELECT * FROM items')
    local items2 = MySQL.Sync.fetchAll('SELECT * FROM uniqueitems')
    if items then
        for k,v in pairs(items) do
            v.other = json.decode(v.other)
            CipeZenItems[v.name] = v
        end
    end
    if items2 then
        for k,v in pairs(items2) do
            v.limit = 1
            v.other = json.decode(v.other)
            CipeZenUniqueItems[tostring(v.id)] = v
        end
    end
end)
CZ = {}
CZEvent = {}
CipeZenEventsCount = 14
CipeZenEventsLoadCount = 0
CipeZenTriggerEventLoad = false
CZClientCallBack = {}
CZUpdateCallback = nil
local previousCoords = nil
Job = {}
Permission = "player"

local allCZControlThreads = {}
local allCZThreads = {}

RegisterNetEvent("InitializeCipeZenFrameWork")
RegisterNetEvent("CZ:returnRequstExistCallback")
RegisterNetEvent("CZ:requestExistCallback")
RegisterNetEvent("CZ:updateJob")
RegisterNetEvent("CZ:updatePermission")
RegisterNetEvent("CipeZen:spawnVehicleOnPlayer")
RegisterNetEvent("CZ:onUpdate")
AddEventHandler("CZ:updateJob", function(job)
    CZ.Job = job
    UpdateCZ()
end)
AddEventHandler("CZ:updatePermission",function(permission)
    CZ.Permission = permission
    UpdateCZ()
end)
AddEventHandler("InitializeCipeZenFrameWork",function(_cb,_cb2)
    local cb = _cb
    local cb2 = _cb2
    Citizen.CreateThread(function()
        while CipeZenEventsLoadCount ~= CipeZenEventsCount do
            Citizen.Wait(10)
        end
        cb(CZ)
    end)
    if cb2 then
        Citizen.CreateThread(function()
            while CipeZenTriggerEventLoad == false do
                Citizen.Wait(10)
            end
            cb2(CZEvent)
        end)
    end
end)
AddEventHandler("onResourceStop", function(resource)
    for k,v in pairs(allCZThreads) do
        for s,t in pairs(v) do
            if type(t.CB) ~= "function" and string.find(t.CB.__cfx_functionReference,resource) then
                table.remove(v,s)
            end
        end
        if #v == 1 then
            if type(v[1].CB) ~= "function" and string.find(v[1].CB.__cfx_functionReference,resource) then
                v = {}
            end
        end
    end
    for k,v in pairs(allCZControlThreads) do
        if type(v.CB) ~= "function" and string.find(v.CB.__cfx_functionReference,resource) then
            table.remove(allCZControlThreads,k)
        end
    end
    if #allCZControlThreads == 1 then
        if type(allCZControlThreads[1].CB) ~= "function" and string.find(allCZControlThreads[1].CB.__cfx_functionReference,resource) then
            allCZControlThreads = {}
        end
    end
    for k,v in pairs(CZClientCallBack) do
        if type(v.CB) ~= "function" and string.find(v.CB.__cfx_functionReference,resource) then
            CZClientCallBack[k] = nil
        end
    end
end)
AddEventHandler("CZ:requestExistCallback", function(_idcallback,_callbackname,...)
    local idcallback = _idcallback
    local callbackname = _callbackname
    local data = table.pack(...)
    function CB(...)
        TriggerServerEvent("CZ:returnRequstExistCallback",idcallback,true,...)
    end
    Citizen.CreateThread(function()
        while CipeZenEventsLoadCount ~= CipeZenEventsCount do
            Citizen.Wait(300)
        end
        Wait(100)
        if CZClientCallBack[callbackname] then
            CZClientCallBack[callbackname].CB(CB,table.unpack(data))
        else
            TriggerServerEvent("CZ:returnRequstExistCallback",idcallback,false)
        end
    end)
end)
AddEventHandler("CipeZen:spawnVehicleOnPlayer", function (model)
    local ped = PlayerPedId()
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
          Citizen.Wait(10)
        end
        local vehicle = CreateVehicle(model, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
        SetModelAsNoLongerNeeded(model)
        SetPedIntoVehicle(ped,vehicle,-1)
    else
        TriggerEvent('chat:addMessage',{
            color = { 0, 0, 0},
            multiline = true,
            args = {"~s~No ~y~vehicle~s~ with model ~g~\'"..model.."\'~s~ ~r~found~s~ !"}
        })
    end
end)
AddEventHandler("playerSpawned", function(spawn)
	SetCanAttackFriendly(PlayerPedId(), true, false)
	NetworkSetFriendlyFireOption(true)
end)

function UpdateCZ()
    TriggerEvent("CZ:onUpdate", CZ)
end

function CZPrint(a)
    local text = ""
    local cane = true
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
                text = text ..space.."["..k.."]" .. extra..CipeZenReturnArrayText(spacen + 1,v)
            else
                text = text ..space.."["..k.."]" .. extra..CipeZenReturnArrayText(spacen + 1,v)
            end
        else
            extra = ",\n"
            if type(v) == "number" then
                text = text ..space.."["..k.."]┤ = " .. tostring(v)..extra
            elseif type(v) == "string" then
                text = text ..space.."["..k.."]┤ = " .. "'"..tostring(v).."'"..extra
            else
                text = text ..space.."["..k.."]┤ = " .. tostring(v)..extra
            end
        end
    end
    if #text == 0 then
        text = space .. "{}\n"
    end
    return text
end

function CZTry(access,negate)
    local status, result = pcall(access)
    if not status then
        negate(result)
    end
    return result
end

function CZNotify(_title,_description,_time)
    SendNUIMessage({
        action = "notify",
        title = _title or "",
        description = _description or "",
        time = _time or 5000
    })
end

function CZHelpNotify(_title,_description,_time)
    Citizen.CreateThread(function()
        SendNUIMessage({
            action = "helpnotify",
            title = _title,
            description = _description,
            time = _time or 100
        })
    end)
end

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

CZ.DuplicateObject = CZDuplicateObject
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.Try = CZTry
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.HelpNotify = CZHelpNotify
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.Notify = CZNotify
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.Print = CZPrint
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1

function CZCreateThread(_time,cb)
    Citizen.CreateThread(function()
        if tonumber(_time) then
            Wait(1000)
            local randomId = math.random(0,100) .. math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)
            local time = _time
            function Delete()
                if allCZThreads[tostring(time) .. "t"] then
                    for k,v in pairs(allCZThreads[tostring(time) .. "t"]) do
                        if v.Id == randomId then
                            table.remove(allCZThreads[tostring(time) .. "t"],k)
                        end
                    end
                end
            end
            function Pause()
                if allCZThreads[tostring(time) .. "t"] then
                    for k,v in pairs(allCZThreads[tostring(time) .. "t"]) do
                        if v.Id == randomId then
                            v.Pause = true
                        end
                    end
                end
            end
            function Reasume()
                if allCZThreads[tostring(time) .. "t"] then
                    for k,v in pairs(allCZThreads[tostring(time) .. "t"]) do
                        if v.Id == randomId then
                            v.Pause = false
                        end
                    end
                end
            end
            if allCZThreads[tostring(time) .. "t"] then
                table.insert(allCZThreads[tostring(time) .. "t"],{CB = cb,Id = randomId})
            else
                allCZThreads[tostring(time) .. "t"] = {{CB = cb,Id = randomId}}
                Citizen.CreateThread(function()
                    while true do
                        if allCZThreads[tostring(time) .. "t"] and #allCZThreads[tostring(time) .. "t"] == 0 then
                            allCZThreads[time .. "t"] = nil
                            break;
                        end
                        Citizen.Wait(time)
                        for k,v in pairs(allCZThreads[tostring(time) .. "t"]) do
                            if not v.Pause then
                                CZ.Try(function ()
                                    v.CB(Pause,Reasume,Delete)
                                end,function(error)
                                    table.remove(allCZThreads[tostring(time) .. "t"],k)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end)
end

function CZDrawMarker(options)
    DrawMarker(options.type or 2, options.posX or 0.0, options.posY or 0.0, options.posZ or 0.0, options.dirX or 0.0, options.dirY or 0.0, options.dirZ or 0.0, options.rotX or 0.0, options.rotY or 0.0, options.rotZ or 0.0, options.scaleX or 1.0, options.scaleY or 1.0, options.scaleZ or 1.0, options.red or 200, options.green or 200, options.blue or 200, options.alpha or 200, options.bobUpAndDown or false, options.faceCamera or false, options.p19 or 2, options.rotate or false, options.textureDict or nil, options.textureName or nil, options.drawOnEnts or false)
end

function CZTriggerCallback(name,cb,...)
    local id = math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)..math.random(0,100)
    TriggerServerEvent("CZ:requestExistCallback",id,name,...)
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

function CZRegisterCallback(callbackname,cb)
    if CZClientCallBack[callbackname] then
        print("[CipeZen][ALLERT]The callback \'"..callbackname.."\' will be overwritten with a new function!")
    end
    CZClientCallBack[callbackname] = {CB = cb}
end

CZEvent.RegisterCallback = CZRegisterCallback
CZEvent.TriggerCallback = CZTriggerCallback
CipeZenTriggerEventLoad = true

function CZGetNearestPlayer()
    local players = GetActivePlayers()
    local entity = -1
    local distance = -1
    local playerPos = GetEntityCoords(CZ.PlayerPedId)   
    for k,v in pairs(players) do
        if v ~= CZ.PlayerId then
            local pos = GetEntityCoords(GetPlayerPed(v))
            local dist = Vdist(pos, playerPos)
            if distance == -1 then
                distance = dist
                entity = v
            else
                if dist < distance then
                    distance = dist
                    entity = v
                end
            end
        end
    end
    return entity,distance
end

function CZControlPressed(_key,cb)
    Citizen.CreateThread(function()
        local key = _key
        if type(_key) == "string" then
            if Controls[string.upper(_key)]  then
                key = Controls[string.upper(_key)]
            else
                key = nil
            end
        end
        if key and #allCZControlThreads > 0 then
            table.insert(allCZControlThreads,{CB = cb,Key = key})
        end
        if #allCZControlThreads == 0 then
            table.insert(allCZControlThreads,{CB = cb,Key = key})
            CZCreateThread(1,function(pause,reasume,delete)
                if #allCZControlThreads == 0 then
                    delete()
                end
                for k,v in pairs(allCZControlThreads) do
                    if not v.Used then
                        if IsControlJustPressed(0, v.Key) then
                            v.Used = true
                            v.CB()
                            Citizen.CreateThread(function()
                                Wait(100)
                                v.Used = false
                            end)
                        end
                    end
                end
            end)
        end 
    end)
end

function CZMenu(name,data,cb,cb1,cb2)
    TriggerEvent("c_menu_z:openMenu",name,data,cb,cb1,cb2)
end

function CZCloseAllMenu()
    TriggerEvent("c_menu_z:closeAllMenu")
end


Citizen.CreateThread(function()
    while GetEntityCoords(PlayerPedId()) == vector3(0,0,0) or GetEntityCoords(PlayerPedId()) == vector3(0,0,1)  do
        Citizen.Wait(100)
    end
    Wait(1000)
    previousCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("CipeZen:playerLoad")
    CZ.PlayerPedId = PlayerPedId()
    CZ.PlayerId = PlayerId()
    CZ.PlayerServerId = GetPlayerServerId(CZ.PlayerId)
    CZ.PlayerName = GetPlayerName(CZ.PlayerId)
    CZTriggerCallback("cz:getPlayerData",function(data)
        CZ.Permission = data.Permission
        CZ.Job = data.Job
        CZ.Idenrifiers = data.Identifiers
        CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
        UpdateCZ()
    end)
    Wait(5000)
    ClearPlayerWantedLevel(CZ.PlayerPedId)
	SetMaxWantedLevel(0)
    CZCreateThread(1000,function (pause,reasume,delete)
        local playerPed = CZ.PlayerPedId
		if DoesEntityExist(playerPed) then
			local coords = GetEntityCoords(playerPed)
			local distance = #(coords - previousCoords)
			if distance > 3 then
                previousCoords = coords
				local heading = GetEntityHeading(playerPed)
				local formattCoords = {x = coords.x, y = coords.y, z = coords.z, h = heading}
				TriggerServerEvent('CipeZen:updatePlayerCoords', formattCoords)
			end
        else
            CZ.PlayerPedId = PlayerPedId()
            UpdateCZ()
        end
    end)
end)

Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

CZ.GetNearestPlayer = CZGetNearestPlayer
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.Menu = CZMenu
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.CloseAllMenu = CZCloseAllMenu
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.TriggerCallback = CZTriggerCallback
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.RegisterCallback = CZRegisterCallback
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.CreateThread = CZCreateThread
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.DrawMarker = CZDrawMarker
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
CZ.ControlPressed = CZControlPressed
CipeZenEventsLoadCount = CipeZenEventsLoadCount + 1
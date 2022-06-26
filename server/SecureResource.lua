-- directory of CipeZen
local dir = GetResourcePath(GetCurrentResourceName())

-- read file
function ReadFile(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

-- handle the resource start to send files to clients and server
AddEventHandler("onResourceStart", function(resourceName)
    local resourceConfig =  ReadFile(dir .. "/SecureResource/ResourceConfig.json")
    resourceConfig = json.decode(resourceConfig)
    if resourceConfig then
        local resource = resourceConfig[resourceName]
        if resource then
            if resource.client then
                for k,v in pairs(resource.client) do
                    local file = ReadFile(dir .. "/SecureResource/module/" .. v)
                    if file then
                        TriggerClientEvent("CipeZen:sendFiles",-1,v,file)

                    else
                        return
                    end
                end
            end
        end
    end
end)

SendFile = function(source)
    local resourceConfig =  ReadFile(dir .. "/SecureResource/ResourceConfig.json")
    resourceConfig = json.decode(resourceConfig)
    if resourceConfig then
        for k,v in pairs(resourceConfig) do
            local resource = v
            if resource then
                if resource.client then
                    for s,t in pairs(resource.client) do
                        local file = ReadFile(dir .. "/SecureResource/module/" .. t)
                        if file then
                            TriggerClientEvent("CipeZen:sendFiles",source,t,file)
                        else
                            return
                        end
                    end
                end
            end
        end
    end
end

AddEventHandler("playerConnecting", function()
    local source = source
    local license = CZGetIdentifiers(source).license
    Wait(2000)
    for k,v in pairs(GetPlayers()) do
        local l = CZGetIdentifiers(v).license
        if l == license then
            source = v
            break
        end
    end
    SendFile(source)
end)
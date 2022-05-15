CZ.Command = function(permission,command,cb,suggestions)
    if permission then
        RegisterCommand(command, cb, true)
        ExecuteCommand(('add_ace group.%s command.%s allow'):format(permission,command))
    else
        RegisterCommand(command, cb, false)
    end
    if suggestions and suggestions.HelpText then
        TriggerClientEvent('chat:addSuggestion', -1,'/'..command, suggestions.HelpText,suggestions.Suggestions)
    end
end

local commands = {
    {
        name = "setpermission",
        permission = "admin",
        suggestion = {
            HelpText = "Set player permission",
            Suggestions = {
                { name="id", help="player id" },
                { name="group", help="exemple admin or player" },
            }
        },
        func = function (source,args,rawcommand)
            if #args == 2 then
                if args[1] == "me" and source ~= 0 then
                    args[1] = source
                end
                local licenses = CZ.GetIdentifiers(args[1])
                if licenses and licenses.license then
                    CZ.ChangePermission(args[1],args[2])
                    if source ~= 0 then
                        TriggerClientEvent('chat:addMessage', source,{
                            color = { 0, 0, 0},
                            multiline = true,
                            args = {"~y~Player~s~ permission change to group ~g~\'"..args[2].."\'~s~"}
                          })
                    else
                        CZ.Print("Player permission change to group \'"..args[2].."\'")
                    end
                else
                    if source ~= 0 then
                        TriggerClientEvent('chat:addMessage', source,{
                            color = { 0, 0, 0},
                            multiline = true,
                            args = {"No ~y~player~s~ ~r~found~s~ !"}
                          })
                    else
                        CZ.Print("No player found !")
                    end
                end
            end
        end
    },
    {
        name = "car",
        permission = "admin",
        suggestion = {
            HelpText = "Spawn a car",
            Suggestions = {
                { name="model", help="model of car adder..." },
            }
        },
        func = function (source,args,rawcommand)
            if args[1] then
                if source ~= 0 then
                    TriggerClientEvent("CipeZen:spawnVehicleOnPlayer",source,args[1])
                else
                    CZ.Print("This command can be execute only in game !")
                end
            end
        end
    },
    {
        name = "dv",
        permission = "admin",
        suggestion = {
            HelpText = "Delete near vehicle",
            Suggestions = {
                { name="range", help="range of deleting" },
            }
        },
        func = function (source,args,rawcommand)
            if args[1] then
                if source ~= 0 then
                    local vehicles = GetAllVehicleInRange(source,args[1])
                    local pedPos = GetEntityCoords(GetPlayerPed(source))
                    for k,v in pairs(vehicles) do
                        DeleteEntity(v)
                    end
                else
                    CZ.Print("This command can be execute only in game !")
                end
            else
                if source ~= 0 then
                    local vehicles = GetAllVehicleInRange(source,2)
                    local pedPos = GetEntityCoords(GetPlayerPed(source))
                    for k,v in pairs(vehicles) do
                        DeleteEntity(v)
                    end
                else
                    CZ.Print("This command can be execute only in game !")
                end
            end
        end
    },
    {
        name = "giveitem",
        permission = "admin",
        suggestion = {
            HelpText = "Give item to player",
            Suggestions = {
                { name="to", help="Id of player or \'me\'" },
                { name="item", help="Item name es:bread" },
                { name="amount", help="Amount of item" },
            }
        },
        func = function (source,args,rawcommand)
            if #args[3] then
                local to = args[1]
                if args[1] == "me" then
                    to = source
                end
                if to ~= 0 then
                    local item = args[2]
                    local amount = args[3]
                    local CZp = CZ.GetPlayerFromId(to)
                    CZp.AddItem(item,amount)
                    if source ~= 0 then
                        TriggerClientEvent('chat:addMessage', source,{
                            color = { 0, 0, 0},
                            multiline = true,
                            args = {"~y~Player~s~ give ~g~\'"..item.."\'~s~ ~g~"..amount.."~s~ to ~y~player~s~"}
                          })
                    else
                        CZ.Print("Player give "..item.." "..amount.." to player")
                    end
                else
                    if source ~= 0 then
                        TriggerClientEvent('chat:addMessage', source,{
                            color = { 0, 0, 0},
                            multiline = true,
                            args = {"No ~y~player~s~ ~r~found~s~ !"}
                          })
                    else
                        CZ.Print("No player found !")
                    end
                end
            else
                if source ~= 0 then
                    
                else
                    CZ.Print("Need all arguments !")
                end
            end
        end
    }
}

for k,v in pairs(commands)do
    CZ.Command(v.permission,v.name,v.func,v.suggestion)
end
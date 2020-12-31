
local Remotes = {}

local SetData, GetData = require(_G.ServerStorage.SyncScripts.Server.ServerCore).SetData, require(_G.ServerStorage.SyncScripts.Server.ServerCore).GetData

Types = {
    --# Will create Remote Events #--

    --# Client -> Server
    ['1.1'] = 'ClientToServerEvent',
    
    --# Client -> Server -> Client(s)
    ['2.1'] = 'ClientToAllClientsEvent',

    
    --# Will create Remote Functions #--

    --# Client -> Server ( Client waiting for Server Return )
    ['1.2'] = 'ClientToServerFunction',

    --# Client -> Server -> Client(s) ( Client waiting for Server Return )
    ['2.2'] = 'ClientToAllClientsFunction',
}

local AllRemotes = {
    DropObject = {
        Script = require(_G.RS.Client.UI.Placement),
        Func = 'DropDown', --# Call function with: Player, PlayerData, Params
        Type = '1.1',
    }
}

function Remotes.Register()
    local generatedRemotes = _G.inew('Folder', _G.RS)
    generatedRemotes.Name = 'GeneratedRemotes'
    local clientToHandle = _G.inew('Folder', generatedRemotes)
    clientToHandle.Name = 'ClientToHandle'

    for remoteName, remoteData in pairs(AllRemotes) do
        local connType, remType = _G.split(remoteData.Type)[1], _G.split(remoteData.Type)[2]
        
        if remType == '1' then
            local re = _G.inew('RemoteEvent')
            re.Name = remoteName

            if connType == '1' then
                re.Parent = generatedRemotes
                re.OnServerEvent:Connect(function(player, params)
                    (remoteData.Script)[remoteData.Name](player, GetData(player.UserId), params)
                    return nil
                end)
            elseif connType == '2' then
                re.Parent = clientToHandle
                re.OnServerEvent:Connect(function(player, params)
                    for _,otherPlayer in pairs(_G.Players:GetChildren()) do
                        if player.UserId ~= otherPlayer.UserId then
                            re.FireClient(
                                {
                                    ScriptName = remoteData.Script:GetFullName(),
                                    FuncName = remoteData.Func,
                                },
                                params
                            )
                        end
                    end
                    return nil
                end)
            end
        
        elseif remType == '2' then
            local rf = _G.inew('RemoteFunction')
            rf.Name = remoteName
            rf.Parent = generatedRemotes
            rf.OnServerInvoke = function()

                return true
            end
        end
    end
end

return Remotes
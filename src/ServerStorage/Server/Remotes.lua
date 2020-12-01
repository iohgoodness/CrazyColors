
local Remotes = {}

local RemoteData = {
    ['DropDown'] = require(_G.RS.Client.Placement).DropDown,
}

local SetData, GetData = require(_G.ServerStorage.SyncScripts.Server.ServerCore).SetData, require(_G.ServerStorage.SyncScripts.Server.ServerCore).GetData

function Remotes:CreateRemotes()
    for remoteName,remoteFunc in pairs(RemoteData) do
        local remote = Instance.new('RemoteEvent', _G.RS.Remotes)
        remote.Name = remoteName
        remote.OnServerEvent:Connect(function(player, params)
            remoteFunc(player, GetData(self, player.UserId), params)
        end)
    end
end

return Remotes

local Remotes = {}

local RemoteData = {
    DropDown = require(_G.RS.Client.UI.Placement).DropDown,
}

local SetData, GetData = require(_G.ServerStorage.SyncScripts.Server.ServerCore).SetData, require(_G.ServerStorage.SyncScripts.Server.ServerCore).GetData

function Remotes:CreateRemotes()
    for remoteName,remoteFunc in pairs(RemoteData) do
        local remote = Instance.new('RemoteEvent', _G.RS.Remotes)
        remote.Name = remoteName
        remote.OnServerEvent:Connect(function(player, params)
            local data = remoteFunc(self, player, GetData(self, player.UserId), params)
            if data then
                SetData(self, player.UserId, data)
            end
        end)
    end
end

return Remotes
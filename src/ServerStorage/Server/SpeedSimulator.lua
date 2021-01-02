
local SpeedSimulator = {}

local SetData, GetData = require(_G.ServerStorage.SyncScripts.Server.ServerCore).SetData, require(_G.ServerStorage.SyncScripts.Server.ServerCore).GetData

function SpeedSimulator.NewPlayer(player)
    local data = GetData(player.UserId)
    player.Character.Humanoid.WalkSpeed = data.WalkSpeed

    _G.cr(function() --# Thread to track and record player movement
        while wait(0.1) do
            if player.Character.Humanoid.MoveDirection.Magnitude > 0 then
                --print(player.Character.Humanoid.MoveDirection.Magnitude)
                --data.TotalMovement = data.TotalMovement + 1
                --print(data.TotalMovement)
            end
        end
    end)()
end

function SpeedSimulator.Init()
    
end

return SpeedSimulator
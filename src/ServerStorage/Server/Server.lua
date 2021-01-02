
local Server = {}

function Server.Init()
    require(_G.Sync.Server.SpeedSimulator).Init()
end

function Server.NewPlayer(player)
    local timeout = 50
    repeat
        wait(0.1)
        timeout = timeout - 1
    until (timeout == 0 or player.Character)
    if player.Character == nil then return end --# Character was never loaded ( player left the game while still being configured )

    --# require(_G.Sync.Server.SpeedSimulator).NewPlayer(player)
end

return Server


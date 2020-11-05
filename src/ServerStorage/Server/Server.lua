
local Server = {}

function Server:Init()
    wait(3)
    require(_G.gb.Sync.Server.AStarPathfinding.AStarPathfinding):Init()
end

return Server

local Server = {}

function Server:Init()
    require(_G.Sync.Server.AStarPathfinding.AStarPathfinding):Init()
end

return Server
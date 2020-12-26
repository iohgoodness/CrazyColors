
local Server = {}

function Server:Init()
    -- require(_G.Sync.Server.AStarPathfinding.AStarPathfinding):Init()
    _G.SendStats('testuserid', {
        ['DevProduct.Mana1'] = 100,
    })
end

return Server
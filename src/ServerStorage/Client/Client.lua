
local gb

local Client = {}

function Client:Init()
    gb = require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox'))

    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    require(gb.ReplicatedStorage:WaitForChild('Client'):WaitForChild('Data')):Init()
end

return Client
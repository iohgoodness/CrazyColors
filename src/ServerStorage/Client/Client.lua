
local Client = {}

function Client:Init()
    --game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox')):Init()
    require(_G.RS:WaitForChild('Client'):WaitForChild('Data')):Init()
    require(_G.RS:WaitForChild('Client'):WaitForChild('Placement')):Init()
end

return Client
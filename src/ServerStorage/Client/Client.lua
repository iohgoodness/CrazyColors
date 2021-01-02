
local Client = {}

function Client:Init()
    --game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    
    --# Util Modules
    require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox')).Init()
    require(_G.RS:WaitForChild('Client'):WaitForChild('Data')).Init()

    --# Game Modules
    --require(_G.RS:WaitForChild('Client'):WaitForChild('UI'):WaitForChild('Placement')):Init()
    --require(_G.RS:WaitForChild('Client'):WaitForChild('GridSystem')).Init()

    require(_G.RS:WaitForChild('Client'):WaitForChild('DoubleJump')).Init()

    --require(_G.RS:WaitForChild('Client'):WaitForChild('MetatablesTesting')):Init()
end

return Client
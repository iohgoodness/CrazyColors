
local Client = {}

function Client:Init()
    --game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    --require(_G.ReplicatedStorage:WaitForChild('Client'):WaitForChild('Data')):Init()

    require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox')):Init()
end

return Client
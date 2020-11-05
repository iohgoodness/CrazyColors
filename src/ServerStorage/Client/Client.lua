
local Client = {}

function Client:Init()
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

    require(_G.ReplicatedStorage:WaitForChild('Client'):WaitForChild('Data')):Init()
end

return Client
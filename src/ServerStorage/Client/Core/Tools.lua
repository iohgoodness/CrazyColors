
local Tools = {}

local ToolsFolder = _G.RS:WaitForChild('Tools')

local StartingTools = {
    'Rock'
}

Tools.Init = function(player)
    
    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

    local backpack = player.Backpack
    for _, tool in pairs(StartingTools) do
        local newtool = ToolsFolder:WaitForChild(tool)
        if newtool then
            newtool:Clone().Parent = backpack
        end
    end
end

return Tools
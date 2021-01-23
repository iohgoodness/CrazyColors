
local Tools = {}

local ToolsFolder = _G.RS:WaitForChild('Tools')

local STARTING_TOOLS = {
    'Rock'
}


Tools.Init = function(player)

    game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

    local backpack = player.Backpack
    for _, tool in pairs(STARTING_TOOLS) do
        local newtool = ToolsFolder:WaitForChild(tool)
        if newtool then
            newtool:Clone().Parent = backpack
        end
    end
    
    keysconn = _G.UIS.InputBegan:connect(function(inputObject, gameProcessedEvent)
        if inputObject.KeyCode == Enum.KeyCode.One or inputObject.KeyCode == Enum.KeyCode.KeypadOne then

        elseif inputObject.KeyCode == Enum.KeyCode.Two or inputObject.KeyCode == Enum.KeyCode.KeypadTwo then

        elseif inputObject.KeyCode == Enum.KeyCode.Three or inputObject.KeyCode == Enum.KeyCode.KeypadThree then

        elseif inputObject.KeyCode == Enum.KeyCode.Four or inputObject.KeyCode == Enum.KeyCode.KeypadFour then

        elseif inputObject.KeyCode == Enum.KeyCode.Five or inputObject.KeyCode == Enum.KeyCode.KeypadFive then

        elseif inputObject.KeyCode == Enum.KeyCode.Six or inputObject.KeyCode == Enum.KeyCode.KeypadSix then

        elseif inputObject.KeyCode == Enum.KeyCode.Seven or inputObject.KeyCode == Enum.KeyCode.KeypadSeven then

        end
    end)
end

return Tools
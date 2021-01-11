
local Lobby = {}

function Lobby.Init()
    spawn(function()
        local block = workspace.Assets.Lobby.Block
        while true do
            
            --_G.TweenModelCFrame(block, _G.cfn(block.PrimaryPart.CFrame)*_G.cfa(math.rad(90), 0, 0), 3)
            wait(3)
        end
    end)
end

return Lobby
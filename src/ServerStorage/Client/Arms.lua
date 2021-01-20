
local Arms = {}

function Arms.Init()
    local c = workspace.TestRig:Clone()
    c.Parent = workspace
    
    _G.RunService:BindToRenderStep('update', Enum.RenderPriority.First.Value, function()
        c.HumanoidRootPart.CFrame = _G.Player.Character.HumanoidRootPart.CFrame
    end)

    local anim = Instance.new('Animation')
    anim.AnimationId = 'rbxassetid://6274327658'
    local hum = c.Humanoid
    local track = hum:LoadAnimation(anim)
    

    shopConnection = _G.UIS.InputBegan:connect(function(inputObject, gameProcessedEvent)
        if inputObject.KeyCode == Enum.KeyCode.R then
            print 'playing track'
            track:Play()
        end
    end)

end

return Arms
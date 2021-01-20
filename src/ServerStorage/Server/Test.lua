
local Test = {}

function Test.Init()
    local anim = Instance.new('Animation')
    anim.AnimationId = 'rbxassetid://6274327658'
    local hum = workspace.TestRig.Humanoid
    local track = hum:LoadAnimation(anim)
    wait(2)
    print 'playing track'
    track:Play()
end

return Test
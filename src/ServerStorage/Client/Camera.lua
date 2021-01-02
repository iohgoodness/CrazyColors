
local Camera = {}

function Camera.Init()
    _G.Camera.CameraType = Enum.CameraType.Scriptable
    _G.RunService:BindToRenderStep('camera_movement', Enum.RenderPriority.First.Value, function()
        local offset = _G.Player.Character.PrimaryPart.CFrame * _G.cfn(0, 50, 0)
        local cf = _G.cfn(offset.p, _G.Player.Character.PrimaryPart.Position)
        local tween = _G.TweenService:Create(_G.Camera, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {CFrame = cf})
        tween:Play()
    end)
end

return Camera
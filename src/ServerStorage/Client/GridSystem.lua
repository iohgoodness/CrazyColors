
local GridSystem = {}


local GridItems = _G.RS:WaitForChild('Assets'):WaitForChild('Grid')

function GridSystem.Init()

    local cliStorage = _G.inew('Folder', workspace)
    cliStorage.Name = 'ClientStorage'
    _G.Mouse.TargetFilter = cliStorage

    local couch = GridItems:WaitForChild('Realistic Couch')

    local c = couch:Clone()
    c.Parent = cliStorage

    _G.RunService:BindToRenderStep('grid_system', Enum.RenderPriority.First.Value, function()
        if _G.Player and _G.Player.Character then
            if _G.Player.Character:FindFirstChild('Humanoid') and _G.Player.Character.Humanoid.Health > 0 and _G.Player.Character.PrimaryPart then
                local charPos = _G.Player.Character.PrimaryPart.Position
                --c:SetPrimaryPartCFrame(_G.cfn(_G.Mouse.Hit.p))

                local mousepos = _G.Mouse.Hit.p
                local index = 1
                local x = (((math.floor(mousepos.X / index))*index) + ((math.ceil(mousepos.X / index))*index)) / 2
                local y = (((math.floor(mousepos.Y / index))*index) + ((math.ceil(mousepos.Y / index))*index)) / 2
                local z = (((math.floor(mousepos.Z / index))*index) + ((math.ceil(mousepos.Z / index))*index)) / 2
                local v = _G.v3n(x, y, z)
                _G.TweenModelCFrame(c, _G.cfn(v), 0.05, Enum.EasingStyle.Quad)
                --wait(0.04)

            end
        end
    end)
end

return GridSystem
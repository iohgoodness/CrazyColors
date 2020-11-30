
local Database = require(_G.RS:WaitForChild('Sandbox'):WaitForChild(script.Name))

local Placement = {}

local roundingInc = 0.35

local rounded
local objectCopy

local pos, rot = _G.v3n(), 0

function Placement:Rotate(rotation)
    rot = rot + rotation
end

function Placement:PlaceObject(objectName)
    objectCopy = _G.Clone(_G.RS.Assets.Placeables[Database.GetCategoryName(objectName)][objectName], workspace)
    _G.Mouse.TargetFilter = objectCopy
    _G.RunService.RenderStepped:Connect(function()
        pos = _G.Mouse.Hit.p
        local adjustedPos = _G.v3n((math.ceil(pos.X/roundingInc)*roundingInc), pos.Y+1, (math.ceil(pos.Z/roundingInc)*roundingInc))
        _G.TweenModel(objectCopy, (_G.cfn(adjustedPos) * _G.cfa(0, rot, 0)), 0.09, Enum.EasingStyle.Linear)
        --print(objectCopy.PrimaryPart.Rotation)
        wait(0.1)
    end)
end

function Placement:Init()
    Placement:PlaceObject('Fancy Bed')
    _G.UIS.InputBegan:connect(function(inputObject, gameProcessedEvent)
        if inputObject.KeyCode == Enum.KeyCode.E then
            Placement:Rotate(5)
        elseif inputObject.KeyCode == Enum.KeyCode.Q then
            Placement:Rotate(-5)
        end
    end)
end

return Placement
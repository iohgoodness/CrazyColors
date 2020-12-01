
local Database = require(_G.RS:WaitForChild('Sandbox'):WaitForChild(script.Name))

local Placement = {}

local ROUNDING_INC = 0.05
local DROP_DOWN = 2.5

local rounded
local objectCopy
local placeConn = nil

local pos, rot, cf  = _G.v3n(), 0, 0
local staticRot = 30

function Placement:Rotate(rotation)
    rot = rot + rotation
end

function Placement:GiveUp()
    if placeConn then
        placeConn:Disconnect()
        placeConn = nil
        objectCopy:Destroy()
    end
end

function Placement:DropDown(player, data, params)
    local objectName, CFrame = params.ObjectName, params.CFrame
    local object = _G.RS.Assets.Placeables[Database.GetCategoryName(objectName)][objectName]:Clone()
    object:SetPrimaryPartCFrame(CFrame * _G.cfn(0, DROP_DOWN, 0))
    object.Parent = workspace.Homes.Placeables
    --_G.InvisibleModel(object)
    --_G.TweenModelTransparency(object, 0.8, 0, {object.PrimaryPart})
    _G.TweenModelCFrame(object, CFrame, 0.8, Enum.EasingStyle.Quad)
end

function Placement:Confirm()
    _G.FireRemote('DropDown', {
        ObjectName = objectCopy.Name,
        CFrame = cf,
    })
    Placement:GiveUp()
end

function Placement:PlaceObject(objectName)
    objectCopy = _G.RS.Assets.Placeables[Database.GetCategoryName(objectName)][objectName]:Clone()
    objectCopy.Parent = workspace
    local halfSize = objectCopy.PrimaryPart.Size.Y/2
    _G.Mouse.TargetFilter = objectCopy
    placeConn = _G.RunService.RenderStepped:Connect(function()
        pos = _G.Mouse.Hit.p
        local adjustedPos = _G.v3n((math.ceil(pos.X/ROUNDING_INC)*ROUNDING_INC), pos.Y+halfSize, (math.ceil(pos.Z/ROUNDING_INC)*ROUNDING_INC))
        cf = (_G.cfn(adjustedPos) * _G.cfa(0, math.rad(rot), 0))
        _G.TweenModelCFrame(objectCopy, cf, 0.09, Enum.EasingStyle.Linear)
        wait(0.1)
    end)
end

function Placement:Init()
    Placement:PlaceObject('Spa')
    _G.UIS.InputBegan:connect(function(inputObject, gameProcessedEvent)
        if not gameProcessedEvent then
            if inputObject.KeyCode == Enum.KeyCode.E then
                Placement:Rotate(staticRot)
            elseif inputObject.KeyCode == Enum.KeyCode.Q then
                Placement:Rotate(-1*staticRot)
            elseif inputObject.KeyCode == Enum.KeyCode.X then
                Placement:GiveUp()
            elseif inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
                Placement:Confirm()
            end
        end
    end)
end

return Placement

local Database = require(_G.RS:WaitForChild('Sandbox'):WaitForChild(script.Name))

local Placement = {}

local roundingInc = 0.05

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
    print(player, data, params)
end

function Placement:Confirm()
    _G.FireRemote('DropDown', {
        objectCopy.Name,
        cf,
    })
    Placement:GiveUp()
end

function Placement:PlaceObject(objectName)
    objectCopy = _G.Clone(_G.RS.Assets.Placeables[Database.GetCategoryName(objectName)][objectName], workspace)
    _G.Mouse.TargetFilter = objectCopy
    placeConn = _G.RunService.RenderStepped:Connect(function()
        pos = _G.Mouse.Hit.p
        local adjustedPos = _G.v3n((math.ceil(pos.X/roundingInc)*roundingInc), pos.Y+1, (math.ceil(pos.Z/roundingInc)*roundingInc))
        cf = (_G.cfn(adjustedPos) * _G.cfa(0, math.rad(rot), 0))
        _G.TweenModelCFrame(objectCopy, cf, 0.09, Enum.EasingStyle.Linear)
        wait(0.1)
    end)
end

function Placement:Init()
    Placement:PlaceObject('Fancy Bed')
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
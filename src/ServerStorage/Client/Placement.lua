
local Database = require(_G.RS:WaitForChild('Sandbox'):WaitForChild(script.Name))

local Placement = {}

local ROUNDING_INC = 0.05
local DROP_DOWN = 2.5

local rounded
local objectCopy
local viewportframe
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

local tweenInfo = TweenInfo.new(
    0.4,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out,
    0,
    false,
    0
)

local MouseOverModule = require(game.ReplicatedStorage.MouseOverModule)

local placeables = _G.RS:WaitForChild('Assets'):WaitForChild('Placeables')
local function updateOptions(category)
    for k,v in pairs(_G.UI.PlacingFrameFrame:GetChildren()) do if v:IsA('ViewportFrame') then v:Destroy() end end
    for k,v in pairs(Database.Categories[category]) do
        local dir = placeables[category]
        local obj = dir[v]:Clone()
        local viewportFrameClone = viewportframe:Clone()
        obj.Parent = viewportFrameClone
        local viewportCamera = Instance.new("Camera")
        viewportFrameClone.CurrentCamera = viewportCamera
        viewportCamera.Parent = viewportFrameClone
        viewportCamera.CFrame = _G.cfn( (obj.PrimaryPart.CFrame*_G.cfn(0, 0, -3)).p , obj.PrimaryPart.Position )
        viewportFrameClone.Parent = _G.UI.PlacingFrameFrame
        viewportFrameClone.TextButton.MouseButton1Click:Connect(function()
            Placement:PlaceObject(v)
        end)
    end
end

local function tabUI()
    local min, max = -5, 5
    local leftTween, rightTween = nil, nil
    local iswiggling = false
    local obj = nil
    local lastpressed = ''
    local showing = false

    local function wiggle()
        leftTween = _G.TweenService:Create(obj, tweenInfo, {Rotation = min})
        rightTween = _G.TweenService:Create(obj, tweenInfo, {Rotation = max})
        while iswiggling do
            leftTween:Play()
            wait(0.4)
            rightTween:Play()
            wait(0.4)
            _G.TweenService:Create(obj, tweenInfo, {Rotation = 0}) : Play()
        end
    end

    viewportframe = _G.UI.PlacingFrameFrameViewportFrame:Clone()
    _G.UI.PlacingFrameFrameViewportFrame:Destroy()

    for k,v in pairs(_G.UI.PlacingTabs:GetChildren()) do
        if v:IsA('TextButton') then
            local MouseEnter, MouseLeave = MouseOverModule.MouseEnterLeaveEvent(v)
            MouseEnter:Connect(function()
                if not iswiggling then
                    iswiggling = true
                    obj = v
                    wiggle()
                end
            end)
            MouseLeave:Connect(function()
                iswiggling = false
                if leftTween then
                    if not iswiggling then
                        _G.TweenService:Create(obj, tweenInfo, {Rotation = 0}) : Play()
                    end
                end
            end)
            v.MouseButton1Click:Connect(function()
                if v.Name == lastpressed then
                    _G.UI.PlacingFrame:TweenPosition(UDim2.new(1.10, 0, 0.131, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
                    lastpressed = ''
                else
                    _G.UI.PlacingFrameTextLabel.Text = v.Name
                    if not showing then
                        updateOptions(v.Name)
                        _G.UI.PlacingFrame:TweenPosition(UDim2.new(0.87, 0, 0.131, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
                    end
                    lastpressed = v.Name
                end
            end)
        end
    end
end

function Placement:Init()
    tabUI()
    _G.UIS.InputBegan:connect(function(inputObject, gameProcessedEvent)
        if not gameProcessedEvent then
            if objectCopy then
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
        end
    end)
end

return Placement
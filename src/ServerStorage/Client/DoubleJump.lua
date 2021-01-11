
local DoubleJump = {}

local j1Time, j2Time, j3Time = 0.8, 1.1, 2
local j1, j2, j3 = false, false, false
local jp1, jp2, jp3 = 0, 85, 95

--# os.time

local function up(jp)
    _G.Player.Character.PrimaryPart.Velocity = _G.v3n(0, jp, 0)
end

local function reset()
    j1, j2, j3 = false, false, false
end

local function attemptJump()
    if not j1 then
        j1 = true
        _G.cr(function()
            wait(j1Time)
            if not j2 then
                reset()
            end
        end)()
    elseif j1 then
        if not j2 then
            j2 = true
            _G.cr(function()
                wait(j2Time)
                if not j3 then
                    reset()
                end
            end)()
            up(jp2)
        elseif j2 then
            if not j3 then
                j3 = true
                up(jp3)
                _G.cr(function()
                    wait(j3Time)
                    reset()
                end)()
            elseif j3 then
                reset()
            end 
        end
    end
end
--[[
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- All these WaitforChilds might not be necessary.
local jumpButton = plr:WaitForChild("PlayerGui"):WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton")

local function startedToHold()
    print("User started to hold the jump button.")
end

local function released()
    print("User released the jump button")
end

jumpButton.MouseButton1Down:Connect(startedToHold)
jumpButton.MouseButton1Up:Connect(released)
]]

function DoubleJump.Init()
    if not _G.Mobile then
        _G.UIS.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Space then
                    attemptJump()
                end
            end
        end)
    else
        local jumpButton = _G.Player:WaitForChild("PlayerGui"):WaitForChild("TouchGui"):WaitForChild("TouchControlFrame"):WaitForChild("JumpButton")
        jumpButton.MouseButton1Down:Connect(function()
            attemptJump()
        end)
    end
end

return DoubleJump
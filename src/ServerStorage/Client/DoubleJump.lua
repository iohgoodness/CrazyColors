
local DoubleJump = {}

local lastSpace = 0
local j1Time, j2Time, j3Time = 0.8, 1.1, 2
local j1, j2, j3 = false, false, false

--# os.time

local function up()
    _G.Player.Character.PrimaryPart.Velocity = _G.v3n(0, 85, 0)
end

local function reset()
    j1, j2, j3 = false, false, false
end

function DoubleJump.Init()
    _G.UIS.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Space then
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
                        up()
                    elseif j2 then
                        if not j3 then
                            j3 = true
                            up()
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
        end
    end)
end

return DoubleJump
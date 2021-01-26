
--# iohgoodness #--
--# Created: 10/16/2020 #--
--# Last Update: 12/31/2020 #--

--# Easability Module #--
--# Usable for both CLIENT/SERVER to require #--

--# Usage:
--# local gb = require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox'))

local Glowblox = {}

-- rbxassetid://6130157373

--# CONFIGURATION #--

-- local m = 1.1; workspace.MeshPart.Size = workspace.MeshPart.Size * Vector3.new(m, m, m)

--# Using the custom proximity promt #--
USE_PROXIMITY = false

CLICK_IMG = 'rbxassetid://6130157373' --# e.g. a mouse for the player to click on (an object that is in range, but not the closest image)
QUICK_IMG = 'rbxassetid://6130139134' --# e.g. the letter 'e' (always going to be the closest object)
PROXIMITY_FADE_TIME = 0.3
PROXIMITY_DEFAULT_DISTANCE = 20


--#  #--

function Glowblox.Init()

    _G.StringToInstance = function(str, parent)
        local segments = str:split(".")
        local current = parent or game
        for i,v in pairs(segments) do
            current = current[v]
        end
        return current or 'DNE'
    end

    _G.split = function(s, delimiter)
        local result = {}
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match)
        end
        return result
    end

    --#                                   #--
    --# Built in Lua/Roblox Lua Functions #--
    --#                                   #--

    --# Return Instances #--
    _G.wfc   = game.WaitForChild
    _G.ffc   = game.FindFirstChild
    _G.ffcoc = game.FindFirstChildOfClass

    --[[
    _G.Clone = function(item, parent)
        if parent then
            item:Clone().Parent = parent
        end
        return item:Clone()
    end
    ]]

    --# 3D space #--
    _G.zvec  = Vector3.new(0, 0, 0)
    _G.v3n   = Vector3.new
    _G.cfn   = CFrame.new
    _G.cfa   = CFrame.Angles

    --# Common Functions #--
    _G.cr    = coroutine.wrap
    _G.inew  = Instance.new

    --# UI #--
    _G.ud2 = UDim2.new

    --# Math #--
    _G.random = math.random
    _G.pi     = math.pi
    _G.floor  = math.floor
    _G.ceil   = math.ceil

    _G.abs    = math.abs
    _G.acos   = math.acos
    _G.asin   = math.asin
    _G.atan   = math.atan
    _G.atan2  = math.atan2
    _G.cos    = math.cos
    _G.sin    = math.sin
    _G.tan    = math.tan
    _G.cosh   = math.cosh

    --_G.clamp  = math.clamp
    _G.deg    = math.deg
    _G.exp    = math.exp
    --_G.noise  = math.noise
    _G.pow    = math.pow
    _G.rad    = math.rad

    --#                                     #--
    --# Custom functions for Lua/Roblox Lua #--
    --#                                     #--

    --# Roblox event connections #--

    _G.conns = {}
    _G.addconn = function(id, conn)
        if not _G.conns[id] then
            _G.conns[id] = {}
        end
        _G.conns[id][#_G.conns[id]+1] = conn
    end
    _G.remconn = function(id)
        if _G.conns[id] then
            for k,conn in pairs(_G.conns[id]) do
                conn:Disconnect()
            end
        end
        _G.conns[id] = nil
    end

    --# Custom 3D space #--

    --# Check two positions and see if they are "close enough to each other"
    --# @params: Vector3.newA, Vector3.newB, intDist, stringCheck(if le then <= for checking, otherwise, <)
    _G.inproximity = function(pA, pB, dist, check) if check == 'le' then return (pA - pB).magnitude <= dist end return (pA - pB).magnitude < dist end

    --# Check two positions and see if they are "far enough away"
    --# @params: Vector3.newA, Vector3.newB, intDist, stringCheck(if ge then >= for checking, otherwise, >)
    _G.outproximity = function(pA, pB, dist, check) if check == 'ge' then return (pA - pB).magnitude >= dist end return (pA - pB).magnitude > dist end

    --# Custom Math #--

    --# Random number, but has the chance to be negative OR positive
    --# @params: intX( <= intY), intY( >= intX)
    _G.randomPosNeg = function(x, y) if math.random(1,2) == 1 then return math.random(x,y) else return math.random(-y, x) end end
    --# Rounding
    --# @params: floatX(number to round), intY(decimal place to round to)
    _G.round = function(x, y, roundUp) if roundUp then return (math.ceil(x * (math.pow(10, y))))/math.pow(10, y) end return (math.floor(x * (math.pow(10, y))))/math.pow(10, y) end

    --# A* Pathfinding
    _G.astarpf = function(pointA, pointB)

    end

    --# Custom Tweening #--
    _G.ti = function(time, easingStyle, easingDirection, repeatCount, reverses, delayTime)
        return TweenInfo.new (
            time or 0.4,
            easingStyle or Enum.EasingStyle.Quad,
            easingDirection or Enum.EasingDirection.Out,
            repeatCount or 0,
            reverses or false,
            delayTime or 0
        )
    end

    --# Get a deep copy of a table (because lua tables are seen as pointers, this will create and return a fresh new pointer/table copy)
    -- @params: orig(original table to be copied)
    _G.deepcopy = function(orig)
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            copy = {}
            for orig_key, orig_value in next, orig, nil do
                copy[_G.deepcopy(orig_key)] = _G.deepcopy(orig_value)
            end
            setmetatable(copy, _G.deepcopy(getmetatable(orig)))
        else
            copy = orig
        end
        return copy
    end
    
    --# Linear Search
    _G.lsearch = function(value, tbl, getName)
        if getName then
            for k,v in pairs(tbl) do
                if v.Name == value then
                    return v.Name
                end
                return false
            end
        else
            for k,v in pairs(tbl) do
                if v == value then
                    return v
                end
                return false
            end
        end
    end

    --# Iterate through table and return same table of properties 
    _G.RemakeTable = function(tbl, property)
        local newTbl = {}
        for k,v in pairs(tbl) do newTbl[#newTbl+1] = v[property] end
        return newTbl
    end

    --# Stop all animations in either humanoid/animation controller
    --# @params: obj(humanoid/animation controller), toExclude({})
    _G.StopAnims = function(obj, toExclude)
        for k,animation in pairs(obj:GetPlayingAnimationTracks()) do
            if not _G.lsearch(animation, true) then
                animation:Stop()
            end
        end
    end

    --# Handle that will allow for buttons to have built in debounce

    --# Implementation of FireRemote code from God Game
    --# (Register Remote)
    --# (Replicate Code to all other clients)
    --# Swapping DB from server to client

    --# Abreviate numbers
    --# @params: num(number to convert into abreivated string)
    _G.abreviate = function(num)
        local s,m = tostring,math.floor
        if num>=1e+21 -1 then
            local stp = 1e+21
            return s( m(num/stp*10)/10  )..'Sx'
        elseif num>=1e+18 -1 then
            local stp = 1e+18
            return s( m(num/stp*10)/10  )..'Qn'
        elseif num>=1e+15 -1 then
            local stp = 1e+15
            return s( m(num/stp*10)/10  )..'Qd'
        elseif num>=1e+12 -1 then
            local stp = 1e+12
            return s( m(num/stp*10)/10  )..'T'
        elseif num>=1e+9 -1 then
            local stp = 1e+9
            return s( m(num/stp*10)/10  )..'B'
        elseif num>=1e+6 -1 then
            local stp = 1e+6
            return s( m(num/stp*10)/10  )..'M'
        elseif num>=1e+3 -1 then
            local stp = 1e+3
            return s( m(num/stp*10)/10  )..'K'
        elseif num>=0.999 then
            local stp = 1
            return s( m(num/stp*10)/10  )..''
        else
            local stp = 0.01
            return s( m(num/stp*10)/10  )..''
        end 
    end

    --# Convert value based between two numbers to new value based between two numbers
    --# @params: 
    _G.normalize = function(oldMax, oldMin, newMax, newMin, value)
        return (((value - oldMin) * (newMax - newMin) ) / (oldMax - oldMin)) + newMin
    end

    AUTH = {
        username = 'soap',
        password = '',
        game_name = 'Gods of Glory'
    }

    _G.characterActive = function()

    end

    --#                 #--
    --# Roblox Services #--
    --#                 #--

    _G.Players = game:GetService("Players")
    _G.RS = game:GetService("ReplicatedStorage")
    -- spawn(function() repeat wait(1) until _G.RS:WaitForChild('Client'); _G.Client = _G.RS:WaitForChild('Client') end)
    _G.Lighting = game:GetService("Lighting")
    _G.ReplicatedFirst = game:GetService("ReplicatedFirst")
    _G.DataStoreService = game:GetService("DataStoreService")
    _G.Terrain = workspace:FindFirstChildOfClass('Terrain')
    _G.TweenService = game:GetService("TweenService")
    _G.MarketplaceService = game:GetService("MarketplaceService")
    _G.PhysicsService = game:GetService('PhysicsService')
    _G.TeleportService = game:GetService("TeleportService")

    _G.ContentProvider = game:GetService("ContentProvider")
    _G.PreloadAsync = _G.ContentProvider.PreloadAsync

    _G.RunService = game:GetService("RunService")
    _G.IsClient = _G.RunService.IsClient
    _G.IsRunMode = _G.RunService.IsRunMode
    _G.IsStudio = _G.RunService.IsStudio
    _G.IsServer = _G.RunService.IsServer
    _G.Pause = _G.RunService.Pause
    _G.Run = _G.RunService.Run
    _G.Stop = _G.RunService.Stop
    _G.BindToRenderStep = _G.RunService.BindToRenderStep
    _G.UnbindFromRenderStep = _G.RunService.UnbindFromRenderStep

    _G.PlayerDatabase = {}

    if _G.RunService:IsServer() then --# Running on a SERVER
        _G.ServerScriptService = game:GetService("ServerScriptService")
        _G.ServerStorage = game:GetService("ServerStorage")
        _G.Sync = _G.ServerStorage:WaitForChild('SyncScripts')

        _G.DefaultPlayerDatabase = require(_G.Sync:WaitForChild('DB'):WaitForChild('PlayerData'))

        _G.GameDatabase = nil
        _G.GameDatabaseVerbose = false

        --# Establish a database
        --# @params: databaseID(string for unique database id), retryTimer(time until retry starts again), verbose(give debug messages)
        _G.Establish = function(databaseID, retryTimer, verbose)
            _G.GameDatabase = nil
            local success, data = pcall(function()
                _G.GameDatabase = _G.DataStoreService:GetDataStore(databaseID)
                if verbose then print('Database', _G.GameDatabase, 'established') end
            end)
            if not success then
                warn('failed to establish database... trying again in ' .. retryTimer or 0.5 .. ' seconds')
                wait(retryTimer or 0.5)
                _G.Establish(databaseID)
            end
        end

        --# Load/Get Data for a player
        --# @params: playerUserId(userid for player), retryTimer(time until retry starts again), verbose(give debug messages)
        _G.LoadData = function(playerUserId, retryTimer, verbose)
            if _G.GameDatabase ~= nil then
                local success, alreadySavedData = pcall(function()
                    return _G.GameDatabase:GetAsync(playerUserId)
                end)
                if success then
                    if alreadySavedData then
                        if verbose then print('Player', playerUserId, 'found save from', _G.GameDatabase) end
                        return alreadySavedData
                    else
                        if verbose then print('Player', playerUserId, 'new db from', _G.GameDatabase) end
                        return _G.deepcopy(_G.DefaultPlayerDatabase)
                    end
                else
                    warn('failed to load database for '.. playerUserId ..'... trying again in ' .. retryTimer or 0.5 .. ' seconds')
                    wait(retryTimer or 0.5)
                    _G.LoadData(playerUserId, retryTimer, verbose)
                end
            else
                warn('database not yet established for '.. playerUserId ..' trying to read... trying again in ' .. retryTimer or 0.5 .. ' seconds')
                wait(retryTimer or 0.5)
                _G.LoadData(playerUserId, retryTimer, verbose)
            end
        end

        --# if trying to save data, implement something that saves the data elsewhere and pushes the save to another server

        --# Save data for a player
        --# @params: playerUserId(userid for player), playerData(new copy custom for that player of the database), retryTimer(time until retry starts again), verbose(give debug messages)
        _G.SaveData = function(playerUserId, playerData, retryTimer, verbose)
            if _G.GameDatabase ~= nil then
                local success, error = pcall(function()
                    _G.GameDatabase:SetAsync(playerUserId, playerData)
                    if verbose then print('Player', playerUserId, 'saved to', _G.GameDatabase) end
                end)
                if not success then
                    warn('failed to save database for '.. playerUserId ..'... trying again in ' .. retryTimer or 0.5 .. ' seconds')
                    wait(retryTimer or 0.5)
                    _G.SaveData(playerUserId, playerData, retryTimer, verbose)
                end
            end
        end

        local HttpService = game:GetService("HttpService")
        _G.SendStats = function(playerUserId, params)
            coroutine.wrap(function()
                local success, response = pcall(function()

                    params.username = AUTH.username
                    params.password = AUTH.password
                    params.game_name = AUTH.game_name

                    params.UserId = playerUserId

                    local data = ""
                    for k, v in pairs(params) do
                        data = data .. ("&%s=%s"):format(
                            HttpService:UrlEncode(k),
                            HttpService:UrlEncode(v)
                        )
                    end
                    data = data:sub(2)
                    print('sending', data)
                    local res = HttpService:PostAsync('', data, Enum.HttpContentType.ApplicationUrlEncoded, false) --# FOR NOW, IP ADDY IS HIDDEN (UNTIL DOMAIN/HOST BOUGHT)
                    print('[STATS]\n', res, '\n')
                end)
            end)()
        end
        
    else --# Running on a Client
        _G.Player = _G.Players.LocalPlayer
        _G.PlayerGui = _G.Player.PlayerGui
        _G.Character = _G.Player.Character or _G.Player.CharacterAdded:wait()
        _G.UserInputService = game:GetService("UserInputService")
        _G.UIS = _G.UserInputService
        _G.Camera = workspace.CurrentCamera
        _G.Mouse = _G.Players.LocalPlayer:GetMouse()
        _G.Mobile = false

        _G.cli = function(fileName)
            return require(_G.RS:WaitForChild('Client'):WaitForChild(fileName))
        end

        local UIS = game:GetService("UserInputService")
        local GuiService = game:GetService("GuiService")

        if UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
        and not UIS.GamepadEnabled and not GuiService:IsTenFootInterface() then
            _G.Mobile = true
        end

        local function stringToInstance(str)
            local segments = str:split(".")
            local current = _G.Player
            for i,v in pairs(segments) do
                current = current:WaitForChild(v)
            end
            return current
        end

        --# Debounce for button
        _G.btn = function(debounceTime, func, ...)
            local deb = false
            if not deb then
                deb = true
                func(...)
                wait(debounceTime)
                deb = false
            end
        end

        local delayed = {}
        _G.delay = function(func, timer)
            delayed[#delayed+1] = {func, tick()+timer}
        end
        _G.RunService.Stepped:Connect(function()
            for i, v in pairs(delayed) do
                if tick() - v[2] then
                    table.remove(delayed, i)
                    v[1]()
                end
            end
        end)

        --# Configure the UI
        _G.UI = require(_G.RS:WaitForChild('Client'):WaitForChild('Util'):WaitForChild('GeneratedUI'))
        local function removePeriod(str) local segments = str:split('.') local output = '' for k,segment in pairs(segments) do output = output .. segment end return output end
        --local function waitforchild(str) local segments = str:split('.') local output = '' for k,segment in pairs(segments) do if k > 1 then output = output .. ":WaitForChild('" ..segment .. "')" else output = output .. segment end end return output end
        local function waitforchild(str) local segments = str:split('.') local output = '' for k,segment in pairs(segments) do if k > 1 then output = output .. "." ..segment .. "" else output = output .. segment end end return output end
        for k,uiAsset in pairs(game.StarterGui:GetDescendants()) do
            local defaultStr = uiAsset:GetFullName()
            local replacement, _ = defaultStr:gsub('StarterGui.', 'PlayerGui.')
            local waitForChildVersion = waitforchild(replacement)
            local varName = removePeriod(replacement:gsub('PlayerGui.', 'SpeedyUI.'))
            local var = (varName:gsub('SpeedyUI', '')):gsub('PlayerGui', '')
            _G.UI[var] = stringToInstance(waitForChildVersion)
        end

        --# Room Rendering #--
        --# BUILT FOR THE CLIENTS #--

        _G.RenderLocation = workspace
        _G.DerenderLocation = _G.RS

        _G.SwapRender = function(roomName)
            if roomName == nil then warn 'Must pass a room name!' return end
            if _G.RenderLocation:FindFirstChild(roomName) then
                _G.RenderLocation[roomName].Parent = _G.DerenderLocation
            elseif _G.DerenderLocation:FindFirstChild(roomName) then
                _G.DerenderLocation[roomName].Parent = _G.RenderLocation
            end
        end

        --# Roblox proximity connections #--

        if USE_PROXIMITY then

            local function insertproxconn(part, clickimg, quickimg)
                local ui = Instance.new('BillboardGui')
                ui.Name = 'ui'
                ui.Active = true
                ui.MaxDistance = 'inf'
                ui.ExtentsOffset = _G.v3n(0, 1.5, 0)
                ui.Size = UDim2.new(1.5, 0, 1.5, 0)
                ui.AlwaysOnTop = true
                local btn = Instance.new('ImageButton')
                btn.Name = 'btn'
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.ScaleType = Enum.ScaleType.Fit
                btn.Position = UDim2.new(0.5, 0, 1, 0)
                btn.BackgroundTransparency = 1
                btn.Image = clickimg or CLICK_IMG
                btn.AnchorPoint = Vector2.new(0.5, 1)
                btn.Parent = ui
                ui.Adornee = part
                ui.Parent = _G.Player.PlayerGui.ProxConns
                return ui
            end

            local function showProxConn(partData)
                local part = partData.Part

                local tween = _G.TweenService:Create(
                    partData.UI.btn,
                    TweenInfo.new(PROXIMITY_FADE_TIME),
                    {
                        ImageTransparency = 0,
                        Size = _G.ud2(1, 0, 1, 0),
                    }
                )
                tween:Play()

                wait(PROXIMITY_FADE_TIME)
            end

            local function hideProxConn(partData)
                local part = partData.Part

                local tween = _G.TweenService:Create(
                    partData.UI.btn,
                    TweenInfo.new(PROXIMITY_FADE_TIME),
                    {
                        ImageTransparency = 1,
                        Size = _G.ud2(0, 0, 0, 0),
                    }
                )
                tween:Play()

                wait(PROXIMITY_FADE_TIME)
            end

            _G.proxconns = {}
            _G.addproxconn = function(category, part, dist, clickimg, quickimg, enabled)
                if part:IsA'Model' then
                    local cf, size = part:GetBoundingBox()
                    local top = _G.v3n(cf.p.X, cf.p.Y, cf.p.Z)
                elseif part:IsA'BasePart' then
                    local p, s = part.Position, part.Size
                    local top = _G.v3n(p.X, p.Y, p.Z)
                end
                if not _G.proxconns[category] then
                    _G.proxconns[category] = {}
                end
                local ui = insertproxconn(part, clickimg, quickimg)
                _G.proxconns[category][#_G.proxconns[category]+1] = {
                    Part = part,
                    Dist = dist or PROXIMITY_DEFAULT_DISTANCE,
                    Enabled = enabled or false,
                    Transitioning = false,
                    UI = ui,
                    Lowest = false,
                }

                ui.btn.MouseButton1Click:Connect(function()
                    print(ui.Adornee)
                end)
            end

            _G.UIS.InputBegan:Connect(function(inputObject, gameProcessedEvent)
                if inputObject.KeyCode == Enum.KeyCode.E then
                    if _G.Player and _G.Player.Character then
                        if _G.Player.Character:FindFirstChild('Humanoid') and _G.Player.Character.Humanoid.Health > 0 and _G.Player.Character.PrimaryPart then
                            for id,tbl in pairs(_G.proxconns) do
                                for k,partData in pairs(tbl) do
                                    if partData.UI.btn.Image == QUICK_IMG then
                                        --local partName = partData.Part.Name
                                        --if partData.Part.Name == 'Item' then
                                        --    --require(_G.wfc(_G.wfc(_G.Client, 'Houses'), 'Doors')):Open(partData.Part.Parent)
                                        --    require(_G.RS:WaitForChild('Client'):WaitForChild('Houses'):WaitForChild('Doors')):Open(partData.Part.Parent)
                                        --end
                                        --print(partData.Part)
                                        --if partName == 'test' then
                                        --    _G.SwapRender('House1')
                                            --_G.RenderRoom('House1')
                                        --end
                                    end
                                end
                            end
                        end
                    end
                end
            end)

            local folder = Instance.new('Folder')
            folder.Name = 'ProxConns'
            folder.Parent = _G.PlayerGui

            _G.RunService:BindToRenderStep('show_and_hide_proximity_image', Enum.RenderPriority.First.Value, function()
                if _G.Player and _G.Player.Character then
                    if _G.Player.Character:FindFirstChild('Humanoid') and _G.Player.Character.Humanoid.Health > 0 and _G.Player.Character.PrimaryPart then
                        local charPos = _G.Player.Character.PrimaryPart.Position
                        for id,tbl in pairs(_G.proxconns) do
                            for k,partData in pairs(tbl) do
                                local part = partData.Part
                                local partPos = nil
                                if part:IsA'Model'==false and part then
                                    partPos = part.Position
                                elseif part.PrimaryPart then
                                    partPos = part.PrimaryPart.Position
                                elseif part:IsA'Model' and part.PrimaryPart == nil then warn 'trying to use proximity connection on a model without primarypart' end
                                if partPos then
                                    local mag = (partPos - charPos).magnitude
                                    if mag < partData.Dist then
                                        if not partData.Transitioning then
                                            partData.Enabled = true
                                            partData.Transitioning = true
                                            showProxConn(partData)
                                            partData.Transitioning = false
                                        end
                                    else
                                        if not partData.Transitioning then
                                            partData.Enabled = false
                                            partData.Transitioning = true
                                            hideProxConn(partData)
                                            partData.Transitioning = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            _G.RunService:BindToRenderStep('change_proximity_image', Enum.RenderPriority.First.Value, function()
                if _G.Player and _G.Player.Character then
                    if _G.Player.Character:FindFirstChild('Humanoid') and _G.Player.Character.Humanoid.Health > 0 and _G.Player.Character.PrimaryPart then
                        if #_G.proxconns > 0 then
                            local charPos = _G.Player.Character.PrimaryPart.Position
                            local closest, dist = nil, math.huge
                            for id,tbl in pairs(_G.proxconns) do
                                for k,partData in pairs(tbl) do
                                    local part = partData.Part
                                    local partPos = nil
                                    if part:IsA'Model'==false and part then
                                        partPos = part.Position
                                    elseif part.PrimaryPart then
                                        partPos = part.PrimaryPart.Position
                                    elseif part:IsA'Model' and part.PrimaryPart == nil then warn 'trying to use proximity connection on a model without primarypart' end
                                    if partPos then
                                        local mag = (partPos - charPos).magnitude
                                        if mag < dist then
                                            dist = mag
                                            closest = partData
                                        end
                                    end
                                end
                            end
                            for id,tbl in pairs(_G.proxconns) do
                                for k,partData in pairs(tbl) do
                                    partData.Lowest = false
                                    partData.UI.btn.Image = CLICK_IMG
                                end
                            end
                            closest.Lowest = true
                            closest.UI.btn.Image = QUICK_IMG
                        end
                    end
                end
            end)
            -- _G.addproxconn('test', _G.wfc(workspace, 'test'), 20)
        end
    end

    --# Get all alive charactesr
    _G.GetAliveCharacters = function()
        local t = {}
        for k,v in pairs(_G.Players:GetChildren()) do
            if v.Character then
                if v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 then
                    t[#t+1] = v
                end
            end
        end
        return t
    end

    --# Call a function on each player
    _G.IterPlayers = function(func)
        for k,player in pairs(_G.Players:GetChildren()) do
            func(player)
        end
    end

    --# Call a function on each character
    _G.IterChars = function(func)
        for k,v in pairs(_G.Players:GetChildren()) do
            if v.Character then
                if v.Character:FindFirstChild('Humanoid') and v.Character.Humanoid.Health > 0 then
                    func(v.Character)
                end
            end
        end
    end

    --[[
    for k,v in pairs(game:GetDescendants()) do
        if v:IsA('Script') or v:IsA('LocalScript') then
            if v.Name ~= 'Server' and v.Name ~= 'Client' then
                v:Destroy()
            end
        end
    end
    ]]

    --[[
    for k,model in pairs(workspace.Fixup:GetChildren()) do
        local m = Instance.new('Model')
        m.Name = model.Name
        for k,v in pairs(model:GetDescendants()) do
            if v:IsA('BasePart') or v:IsA('MeshPart') then
                v.Anchored = true
                v.CanCollide = false
                v:Clone().Parent = m
            end
        end
        m.Parent = model.Parent
        model:Destroy()
        local cf, size = m:GetBoundingBox()
        local root = Instance.new('Part', m)
        root.Size = size
        root.CFrame = cf
        root.Transparency = 1
        root.Name = 'Root'
        root.CanCollide = false
        root.Anchored = true
        m.PrimaryPart = root
        for k,v in pairs(m:GetChildren()) do
            if v ~= root then
                local weld = Instance.new('WeldConstraint', root)
                weld.Part0 = root
                weld.Part1 = v
            end
        end
    end
    ]]

    _G.InvisibleModel = function(model)
        local parts = {}
        for k,v in pairs(model:GetDescendants()) do
            if v:IsA('BasePart') or v:IsA('MeshPart') then
                parts[#parts+1] = v
            end
        end
        local connections = {}
        for k,v in pairs(parts) do
            v.Transparency = 1
        end
    end

    _G.TweenModelTransparency = function(model, count, value, ignoreParts)
        local parts = {}
        for k,v in pairs(model:GetDescendants()) do
            if v:IsA('BasePart') or v:IsA('MeshPart') then
                if v.Name ~= 'Root' then
                    parts[#parts+1] = v
                end
            end
        end
        local connections = {}
        for k,v in pairs(parts) do
            local tween = _G.TweenService:Create(v, TweenInfo.new(count or 0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {Transparency = value})
            tween:Play()
            connections[v] = tween.Completed:Connect(function()
                connections[v]:Disconnect()
            end)
        end
    end

    _G.TweenModelPosition = function(model, pos, rot, count, easingStyle)
        local Vector3Value = Instance.new("Vector3Value")
        
        Vector3Value.Value = model:GetPrimaryPartCFrame().p
    
        Vector3Value:GetPropertyChangedSignal("Value"):Connect(function()
            if model then
                if model.PrimaryPart then
                    model:SetPrimaryPartCFrame(_G.cfn(pos) * _G.v3n(rot))
                end
            end
        end)
    
        local tween = _G.TweenService:Create(Vector3Value, TweenInfo.new(count or 0.05, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {Value = pos})
        tween:Play()
    
        tween.Completed:Connect(function()
            Vector3Value:Destroy()
        end)
    end
    
    _G.TweenModelCFrame = function(model, CF, count, easingStyle)
        local CFrameValue = Instance.new("CFrameValue")
        
        CFrameValue.Value = model:GetPrimaryPartCFrame()
    
        CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
            if model then
                if model.PrimaryPart then
                    model:SetPrimaryPartCFrame(CFrameValue.Value)
                end
            end
        end)
    
        local tween = _G.TweenService:Create(CFrameValue, TweenInfo.new(count or 0.05, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {Value = CF})
        tween:Play()
    
        tween.Completed:Connect(function()
            CFrameValue:Destroy()
        end)
    end

    --# Gamepasses / Devproducts #--
    _G.gamepass = function(player, id)
        local gamePassID = id
        local hasPass = false
        
        local success, message = pcall(function()
            hasPass = _G.MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID)
        end)
    
        if not success then
            warn("Error while checking if player has pass: " .. tostring(message))
            return
        end
    
        if not hasPass then
            _G.MarketplaceService:PromptGamePassPurchase(player, gamePassID)
        end
    end

    _G.devproduct = function(player, id)
        _G.MarketplaceService:PromptProductPurchase(player, id)
    end
end

return Glowblox
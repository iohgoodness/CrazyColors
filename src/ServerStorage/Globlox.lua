
--# iohgoodness #--
--# 10/16/2020 #--
--# Last Update: 11/23/2020 #--

--# Easability Module #--
--# Usable for both CLIENT/SERVER to require #--

--# Usage:
--# local gb = require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox'))

local Glowblox = {}

function Glowblox:Init()

    --#                                   #--
    --# Built in Lua/Roblox Lua Functions #--
    --#                                   #--

    --# Return Instances #--
    _G.wfc   = game.WaitForChild
    _G.ffc   = game.FindFirstChild
    _G.ffcoc = game.FindFirstChildOfClass

    --# 3D space #--
    _G.zvec  = Vector3.new(0, 0, 0)
    _G.v3n   = Vector3.new
    _G.cfn   = CFrame.new
    _G.cfa   = CFrame.Angles

    --# Common Functions #--
    _G.cr    = coroutine.wrap
    _G.inew  = Instance.new

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

    _G.clamp  = math.clamp
    _G.deg    = math.deg
    _G.exp    = math.exp
    _G.noise  = math.noise
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

    --#                 #--
    --# Roblox Services #--
    --#                 #--

    _G.Players = game:GetService("Players")
    _G.ReplicatedStorage = game:GetService("ReplicatedStorage")
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

        -- okay

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
    else --# Running on a Client
        _G.Player = _G.Players.LocalPlayer
        _G.Character = _G.Player.Character or _G.Player.CharacterAdded:wait()
        _G.UserInputService = game:GetService("UserInputService")
        _G.UIS = _G.UserInputService
        _G.Camera = workspace.CurrentCamera
        _G.Mouse = _G.Players.LocalPlayer:GetMouse()

        --# Configure the UI
        _G.UI = require(_G.ReplicatedStorage:WaitForChild('Client'):WaitForChild('GeneratedUI'))
        local function removePeriod(str) local segments = str:split('.') local output = '' for k,segment in pairs(segments) do output = output .. segment end return output end
        local function waitforchild(str) local segments = str:split('.') local output = '' for k,segment in pairs(segments) do if k > 1 then output = output .. ":WaitForChild('" ..segment .. "')" else output = output .. segment end end return output end
        for k,uiAsset in pairs(game.StarterGui:GetDescendants()) do
            local defaultStr = uiAsset:GetFullName()
            local replacement, _ = defaultStr:gsub('StarterGui.', 'PlayerGui.')
            local waitForChildVersion = waitforchild(replacement)
            local varName = removePeriod(replacement:gsub('PlayerGui.', 'SpeedyUI.'))
            local var = varName:gsub('SpeedyUI', '')
            _G.UI[var] = waitForChildVersion
        end
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
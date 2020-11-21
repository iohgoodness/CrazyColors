
--# iohgoodness #--
--# 10/16/2020 #--

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
    _G.Market = game:GetService("MarketplaceService")
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

    if _G.RunService:IsServer() then
        _G.ServerScriptService = game:GetService("ServerScriptService")
        _G.ServerStorage = game:GetService("ServerStorage")
        _G.Sync = game:GetService("ServerStorage"):WaitForChild('SyncScripts')
    else
        _G.Player = _G.Players.LocalPlayer
        _G.Character = _G.Player.Character or _G.Player.CharacterAdded:wait()
        _G.UserInputService = game:GetService("UserInputService")
        _G.UIS = _G.UserInputService
        _G.Camera = workspace.CurrentCamera
        _G.Mouse = _G.Players.LocalPlayer:GetMouse()
    end
end

return Glowblox
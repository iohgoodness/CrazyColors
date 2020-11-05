
--# iohgoodness #--
--# 10/16/2020 #--

--# Easability Module #--
--# Usable for both CLIENT/SERVER to require #--

--# Usage:
--# local gb = require(game:GetService('ReplicatedStorage'):WaitForChild('Globlox'))

local Glowblox = {}

Glowblox.Services = {}

--#                                   #--
--# Built in Lua/Roblox Lua Functions #--
--#                                   #--

--# Return Instances #--
Glowblox.wfc   = game.WaitForChild
Glowblox.ffc   = game.FindFirstChild
Glowblox.ffcoc = game.FindFirstChildOfClass

--# 3D space #--
Glowblox.v3n   = Vector3.new
Glowblox.cfn   = CFrame.new
Glowblox.cfa   = CFrame.Angles

--# Common Functions #--
Glowblox.cr    = coroutine.wrap

--# Math #--
Glowblox.random = math.random
Glowblox.pi     = math.pi
Glowblox.floor  = math.floor
Glowblox.ceil   = math.ceil

Glowblox.abs    = math.abs
Glowblox.acos   = math.acos
Glowblox.asin   = math.asin
Glowblox.atan   = math.atan
Glowblox.atan2  = math.atan2
Glowblox.cos    = math.cos
Glowblox.sin    = math.sin
Glowblox.tan    = math.tan
Glowblox.cosh   = math.cosh

Glowblox.clamp  = math.clamp
Glowblox.deg    = math.deg
Glowblox.exp    = math.exp
Glowblox.noise  = math.noise
Glowblox.pow    = math.pow
Glowblox.rad    = math.rad

--#                                     #--
--# Custom functions for Lua/Roblox Lua #--
--#                                     #--

Glowblox.conns = {}
Glowblox.addconn = function(id, conn)
	if not Glowblox.conns[id] then
		Glowblox.conns[id] = {}
	end
	Glowblox.conns[id][#Glowblox.conns[id]+1] = conn
end
Glowblox.remconn = function(id)
	if Glowblox.conns[id] then
		for k,conn in pairs(Glowblox.conns[id]) do
			conn:Disconnect()
		end
	end
	Glowblox.conns[id] = nil
end

--# Custom 3D space Functions #--

--# Check two positions and see if they are "close enough to each other"
--# @params: Vector3.newA, Vector3.newB, intDist, stringCheck(if le then <= for checking, otherwise, <)
Glowblox.inproximity = function(pA, pB, dist, check) if check == 'le' then return (pA - pB).magnitude <= dist end return (pA - pB).magnitude < dist end

--# Check two positions and see if they are "far enough away"
--# @params: Vector3.newA, Vector3.newB, intDist, stringCheck(if ge then >= for checking, otherwise, >)
Glowblox.outproximity = function(pA, pB, dist, check) if check == 'ge' then return (pA - pB).magnitude >= dist end return (pA - pB).magnitude > dist end

--# Custom Math Functions #--

--# Random number, but has the chance to be negative OR positive
--# @params: intX( <= intY), intY( >= intX)
Glowblox.randomPosNeg = function(x, y) if math.random(1,2) == 1 then return math.random(x,y) else return math.random(-y, x) end end
--# Rounding function
--# @params: floatX(number to round), intY(decimal place to round to)
Glowblox.round = function(x, y, roundUp) if roundUp then return (math.ceil(x * (math.pow(10, y))))/math.pow(10, y) end return (math.floor(x * (math.pow(10, y))))/math.pow(10, y) end

--#                 #--
--# Roblox Services #--
--#                 #--

Glowblox.Players = game:GetService("Players")
Glowblox.ReplicatedStorage = game:GetService("ReplicatedStorage")
Glowblox.Lighting = game:GetService("Lighting")
Glowblox.ReplicatedFirst = game:GetService("ReplicatedFirst")
Glowblox.DataStoreService = game:GetService("DataStoreService")
Glowblox.Terrain = workspace:FindFirstChildOfClass('Terrain')
Glowblox.TweenService = game:GetService("TweenService")
Glowblox.Market = game:GetService("MarketplaceService")
Glowblox.PhysicsService = game:GetService('PhysicsService')
Glowblox.TeleportService = game:GetService("TeleportService")

Glowblox.ContentProvider = game:GetService("ContentProvider")
Glowblox.PreloadAsync = Glowblox.ContentProvider.PreloadAsync

Glowblox.RunService = game:GetService("RunService")
Glowblox.IsClient = Glowblox.RunService.IsClient
Glowblox.IsRunMode = Glowblox.RunService.IsRunMode
Glowblox.IsStudio = Glowblox.RunService.IsStudio
Glowblox.IsServer = Glowblox.RunService.IsServer
Glowblox.Pause = Glowblox.RunService.Pause
Glowblox.Run = Glowblox.RunService.Run
Glowblox.Stop = Glowblox.RunService.Stop
Glowblox.BindToRenderStep = Glowblox.RunService.BindToRenderStep
Glowblox.UnbindFromRenderStep = Glowblox.RunService.UnbindFromRenderStep

if Glowblox.RunService:IsServer() then
	Glowblox.ServerScriptService = game:GetService("ServerScriptService")
	Glowblox.ServerStorage = game:GetService("ServerStorage")
	Glowblox.Sync = game:GetService("ServerStorage"):WaitForChild('SyncScripts')
else
	Glowblox.Player = Glowblox.Players.LocalPlayer
	Glowblox.Character = Glowblox.Player.Character or Glowblox.Player.CharacterAdded:wait()
	Glowblox.UserInputService = game:GetService("UserInputService")
	Glowblox.UIS = Glowblox.UserInputService
	Glowblox.Camera = workspace.CurrentCamera
	Glowblox.Mouse = Glowblox.Players.LocalPlayer:GetMouse()
end

function Glowblox:Init()

end

return Glowblox
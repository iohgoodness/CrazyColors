
local ServerStorage = game:GetService('ServerStorage')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local SyncScripts = ServerStorage:WaitForChild('SyncScripts')

local Server = require(ServerStorage.SyncScripts.Server.Server)

local ServerCore = {}

local DatabaseID  = 'TheDatabase0000001'
local SaveOnClose = false
local SaveOnLeave = false

ServerCore.Players = {}

function ServerCore.GetData(playerUserId) return ServerCore.Players[playerUserId] end

function ServerCore.SetData(playerUserId, data) ServerCore.Players[playerUserId] = data end

--# Handle incoming and leaving players
function ServerCore:HandlePlayers()
    _G.Players.PlayerAdded:Connect(function(player)
        local playerData = _G.LoadData(player.UserId)
        ServerCore:SetData(player.UserId, playerData)
    end)
    _G.Players.PlayerRemoving:Connect(function(player)
        if SaveOnLeave then
            local playerUserId = player.UserId
            _G.SaveData(playerUserId, ServerCore:GetData(playerUserId))
            _G.cr(function()
                wait(5)
                ServerCore.Players[playerUserId] = nil
            end)()
        end
    end)
end

--# Move client scripts visible to client
function ServerCore.MovingClientScripts() SyncScripts:WaitForChild('Client').Parent = ReplicatedStorage end

--# Set and move globlox for client
function ServerCore.SetGloblox() require(SyncScripts:WaitForChild('Globlox')):Init() SyncScripts:WaitForChild('Globlox').Parent = ReplicatedStorage end

--# Setup portal for data transfering
function ServerCore.SetDataTransfer()
    local Remotes = Instance.new('Folder')
    Remotes.Name = 'Remotes'
    Remotes.Parent = ReplicatedStorage
    local DB = Instance.new('RemoteEvent')
    DB.Name = 'DB'
    DB.Parent = Remotes
    DB.OnServerEvent:Connect(function(player)
        repeat wait() until ServerCore:GetData(player.UserId) ~= nil
        DB:FireClient(player, ServerCore:GetData(player.UserId))
    end)
end

function ServerCore:Init()

    ServerCore.SetGloblox()
    ServerCore.SetDataTransfer()

    _G.Establish(DatabaseID)

    ServerCore.HandlePlayers()
    ServerCore.MovingClientScripts()

    require(ServerStorage.SyncScripts.Server.Remotes).Register()

    Server.Init()

    if SaveOnClose then
        game:BindToClose(function()
            for k,player in pairs(Players:GetChildren()) do
                _G.cr(function()
                    local playerUserId = player.UserId
                    _G.SaveData(playerUserId, ServerCore:GetData(playerUserId))
                    _G.cr(function()
                        wait(2)
                        ServerCore.Players[playerUserId] = nil
                    end)()
                end)()
            end
        end)
    end
end

return ServerCore
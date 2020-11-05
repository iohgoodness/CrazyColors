
local ServerStorage = game:GetService('ServerStorage')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')

local DatabaseLoader = require(ServerStorage.SyncScripts.DB.DatabaseLoader)
local Server = require(ServerStorage.SyncScripts.Server.Server)
local Sandbox = ReplicatedStorage:WaitForChild('Sandbox')
local PowersData = require(Sandbox:WaitForChild('Powers'):WaitForChild('Powers'))

local ServerCore = {}

local SAVE_ON_CLOSE = false
local SAVE_ON_LEAVE = false

ServerCore.LoadedPlayers = {}

function ServerCore:GetData(playerUserId)
    return ServerCore.LoadedPlayers[playerUserId]
end
function ServerCore:SetData(playerUserId, newData)
    if newData ~= nil then
        ServerCore.LoadedPlayers[playerUserId][2] = newData
    end
end

function ServerCore:SetMana(playerUserId, value)
    ServerCore.LoadedPlayers[playerUserId][1].Leaderstats.Mana = value
    ServerCore.LoadedPlayers[playerUserId][2].Leaderstats.Mana = value
end
function ServerCore:GetMana(playerUserId)
    return ServerCore.LoadedPlayers[playerUserId][1].Leaderstats.Mana
end

function ServerCore:RegisterServerRemote(remoteName, remoteFuncRef)
    coroutine.wrap(function()
        local remote = Instance.new('RemoteEvent')
        remote.Name = remoteName
        remote.Parent = ReplicatedStorage:WaitForChild('Remotes')
        remote.OnServerEvent:Connect(function(player, params)
            remoteFuncRef(nil, params)
        end)
    end)()
end

function ServerCore:RegisterRemote(remoteName, remoteFuncRef)
    coroutine.wrap(function()
        local remote = Instance.new('RemoteEvent')
        remote.Name = remoteName
        remote.Parent = ReplicatedStorage:WaitForChild('Remotes')
        remote.OnServerEvent:Connect(function(player, params)
            local returnValue = remoteFuncRef(self, player, ServerCore:GetData(player.UserId)[2], params)
            if returnValue ~= nil then
                if remoteName == 'GiveMana' then
                    if not returnValue.BadgeInfo['10Kmana'] and returnValue.Leaderstats.Mana >= 10000 then
                        require(game:GetService('ServerStorage').SyncScripts.Server.Badges.Badges):GiveBadge(player, '10Kmana')
                    end
                    if not returnValue.BadgeInfo['1MilMana'] and returnValue.Leaderstats.Mana >= 1000000 then
                        require(game:GetService('ServerStorage').SyncScripts.Server.Badges.Badges):GiveBadge(player, '1MilMana')
                    end
                    if not returnValue.BadgeInfo['1QuadMana'] and returnValue.Leaderstats.Mana >= 1000000000000000 then
                        require(game:GetService('ServerStorage').SyncScripts.Server.Badges.Badges):GiveBadge(player, '1QuadMana')
                    end
                end
                ServerCore:SetData(player.UserId, returnValue)
            end
        end)
    end)()
end

function ServerCore:RegisterRemoteServerToClient(remoteName)
    coroutine.wrap(function()
        local remote = Instance.new('RemoteEvent')
        remote.Name = remoteName
        remote.Parent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('ServerToClient')
    end)()
end

local function getCurrentLevel(unlockedPowersData, powerName)
    for k,power in pairs(unlockedPowersData) do
        if power[1] == powerName then return power[3] end
    end
end

function ServerCore:RegisterGlobalRemote(remoteName, needToSave, remoteFuncRef)
    coroutine.wrap(function()
        local remote = Instance.new('RemoteEvent')
        remote.Name = remoteName
        remote.Parent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('Global')
        remote.OnServerEvent:Connect(function(originPlayer, params)
            coroutine.wrap(function()
                local powerName = params.FuncRef[3]
                local data = params.FuncParams['DB']
                if powerName == 'Cloak' then
                    local serverCloak = Instance.new('IntValue')
                    serverCloak.Name = 'ServerCloak'
                    serverCloak.Parent = originPlayer.Character
                    game:GetService('Debris'):AddItem(serverCloak, PowersData.Data[powerName].CloakTime[getCurrentLevel(data.UnlockedPowers, powerName)])
                end
                if powerName == 'Shield' then
                    local ff
                    local serverShield = Instance.new('IntValue')
                    serverShield.Name = 'ServerShield'
                    serverShield.Parent = originPlayer.Character
                    local shieldDropPoint = originPlayer.Character.PrimaryPart.Position
                    game:GetService('Debris'):AddItem(serverShield, PowersData.Data[powerName].CloakTime[getCurrentLevel(data.UnlockedPowers, powerName)])
                    coroutine.wrap(function()
                        for k,building in pairs(workspace.GameWorlds[data.ActiveWorldType][data.ActiveWorld].Destructibles:GetChildren()) do
                            if building.PrimaryPart then
                                if (building.PrimaryPart.Position - shieldDropPoint).magnitude < 15 then
                                    local protected = Instance.new('IntValue')
                                    protected.Name = 'Protected'
                                    protected.Parent = building
                                    game:GetService('Debris'):AddItem(protected, PowersData.Data[powerName].CloakTime[getCurrentLevel(data.UnlockedPowers, powerName)])
                                end
                            end
                        end
                    end)()
                    coroutine.wrap(function()
                        if originPlayer.Character and originPlayer.Character:FindFirstChild('Humanoid') then
                            while originPlayer.Character:FindFirstChild('ServerShield') do
                                if originPlayer.Character:FindFirstChild('ServerShield') == nil then break end
                                if originPlayer.Character and originPlayer.Character:FindFirstChild('Humanoid') then
                                    if (originPlayer.Character.PrimaryPart.Position - shieldDropPoint).magnitude < 15 then
                                        if originPlayer.Character:FindFirstChild('ServerFF') == nil then
                                            ff = Instance.new("ForceField", originPlayer.Character)
                                            ff.Visible = false
                                            ff.Name = 'ServerFF'
                                        end
                                    else
                                        if originPlayer.Character:FindFirstChild('ServerFF') then
                                            originPlayer.Character.ServerFF:Destroy()
                                        end
                                    end
                                end
                                wait()
                            end
                        end
                        if ff then ff:Destroy() end
                    end)()
                end
            end)()
            for k,player in pairs(Players:GetChildren()) do
                if player.UserId ~= originPlayer.UserId then
                    remote:FireClient(player, {OriginPlayer = originPlayer, FuncRef = params.FuncRef, FuncParams = params.FuncParams})
                end
            end
            if needToSave then
                local returnValue = remoteFuncRef(self, originPlayer, ServerCore:GetData(originPlayer.UserId)[2], params.FuncParams)
                ServerCore:SetData(originPlayer.UserId, returnValue)
            end
        end)
    end)()
end

function ServerCore:RegisterRemoteProxyFunction(remoteName, remoteFuncRef)
    coroutine.wrap(function()
        local remote = Instance.new('RemoteEvent')
        remote.Name = remoteName
        remote.Parent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('ProxyFunctions')
        remote.OnServerEvent:Connect(function(player, params)
            local returnValue = remoteFuncRef(self, player, ServerCore:GetData(player.UserId)[2], params)
            ServerCore:SetData(player.UserId, returnValue.DB)
            remote:FireClient(player, returnValue)
        end)
    end)()
end

--# Track changes made to the table
local function trackTable(playerUserId, playerName, playerData)
    local proxy = setmetatable({}, {
        __index = function(_, key)
            --print('user indexed table with', key)
            Server:Update(playerUserId, playerName, playerData)
            return playerData[key]
        end,
        __newindex = function(_, key, value)
            --print('user updated field', key, 'with the value', value, 'in table')
            Server:Update(playerUserId, playerName, playerData)
            playerData[key] = value
        end
    })
    return proxy
end

--# Get the object and convert it to whichever type it happens to be
local function typeToInstance(str)
    if str == 'number' then
        return Instance.new('NumberValue')
    elseif str == 'boolean' then
        return Instance.new('BoolValue')
    elseif str == 'string' then
        return Instance.new('StringValue')
    end
end

--# Configure the leaderstats for the new player
local function configLeaderstats(plrName, plrData)
    local player = Players:FindFirstChild(plrName)
    local i = Instance.new('IntValue')
    i.Name = 'leaderstats'
    i.Parent = player

    if plrData['Leaderstats'] then
        for k,v in pairs(plrData['Leaderstats']) do
            local instance = typeToInstance(tostring(type(v)))
            instance.Name = k
            instance.Value = v
            instance.Parent = player.leaderstats
        end
    end
end

local function folderStructure(playerName, action)
    if action == 'added' then
        local f1 = Instance.new('Folder')
        local f2 = Instance.new('Folder', f1)
        local f3 = Instance.new('Folder', f1)
        f1.Name = playerName
        f2.Name = 'IceRocks'
        f3.Name = 'FireRocks'
        f1.Parent = workspace:WaitForChild('ActivePowers'):WaitForChild('PlayerItems')
    elseif action == 'removing' then
        if workspace:WaitForChild('ActivePowers'):WaitForChild('PlayerItems'):FindFirstChild(playerName) then
            workspace['ActivePowers']['PlayerItems'][playerName]:Destroy()
        end
    end
end

--# Handle players joining / leaving the game
function ServerCore:HandlePlayers()
    Players.PlayerAdded:Connect(function(player)
        coroutine.wrap(function() player:LoadCharacter() end)()
        local playerUserId = player.UserId
        local playerData = DatabaseLoader:LoadData(playerUserId)
        local td = trackTable(player.UserId, player.Name, playerData)
        ServerCore.LoadedPlayers[playerUserId] = {td, playerData}
        configLeaderstats(player.Name, ServerCore.LoadedPlayers[playerUserId][2])
        
        coroutine.wrap(function() folderStructure(player.Name, 'added') end)()
        Server:NewPlayer(player.Name, player.UserId)
        require(ReplicatedStorage:WaitForChild('Client'):WaitForChild('Reset'):WaitForChild('Reset')):MoveCharacter(Players:FindFirstChild(player.Name), playerData, nil)
    end)
    Players.PlayerRemoving:Connect(function(player)
        if SAVE_ON_LEAVE then
            local playerUserId = player.UserId
            DatabaseLoader:SaveData(playerUserId, ServerCore.LoadedPlayers[playerUserId][2])
            coroutine.wrap(function() folderStructure(player.Name, 'removing') end)()
            --# Ensure the player is gone before clearing their userId entry
            coroutine.wrap(function()
                wait(5)
                ServerCore.LoadedPlayers[playerUserId] = nil
            end)()
        end
    end)
end

--# Move client scripts into ReplicatedStorage for access to the client
function ServerCore:MovingClientScripts()
    script.Parent.Client.Parent = ReplicatedStorage
end

--# Initialization for the server boot
function ServerCore:Init()
    DatabaseLoader:Establish()
    ServerCore:HandlePlayers()
    ServerCore:MovingClientScripts()

    --# Return DB to the player
    local dbEvent = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('DB')
    dbEvent.OnServerEvent:Connect(function(player)
        coroutine.wrap(function()
            dbEvent:FireClient(player, ServerCore:GetData(player.UserId)[2])
        end)()
    end)

    --# Register remotes
    ServerCore:RegisterRemote('ChangeReputation', require(ReplicatedStorage.Client.Reputation.Reputation).ChangeReputation)
    ServerCore:RegisterRemote('GiveMana', require(ReplicatedStorage.Client.Mana.Mana).GiveMana)

    --# Using powers
    ServerCore:RegisterRemote('Powers', require(ReplicatedStorage.Client.Powers.Powers).UsePower)

    --# Shop functionality
    ServerCore:RegisterRemote('UpdateSize', require(ReplicatedStorage.Client.Size.Size).UpdateSize)
    ServerCore:RegisterRemote('UpdatePowers', require(ReplicatedStorage.Client.Powers.Powers).UpdatePowers)

    --# Minions
    ServerCore:RegisterRemote('SellMinion', require(ReplicatedStorage.Client.Minions.Minions).Sell)

    --# Teleporting remotes
    ServerCore:RegisterRemote('TryTeleport', require(ReplicatedStorage.Client.Teleport.Teleport).TryTeleport)
    ServerCore:RegisterRemote('BuyNewPlace', require(ReplicatedStorage.Client.Teleport.Teleport).BuyNewPlace)

    --# Damage boss
    ServerCore:RegisterRemote('DamageBoss', require(ServerStorage.SyncScripts.Server.Bosses.Bosses).DamageBoss)

    --# Reset Character
    ServerCore:RegisterRemote('ResetCharacter', require(ReplicatedStorage.Client.Reset.Reset).ResetCharacter)

    --# Relic
    ServerCore:RegisterRemote('Relic', require(ReplicatedStorage.Client.Relics.Relics).GiveRelic)
    ServerCore:RegisterRemoteServerToClient('RelicShowClient')

    --# Register all server remotes
    ServerCore:RegisterServerRemote('BreakBuilding', require(ServerStorage.SyncScripts.Server.Buildings.Buildings).BreakBuilding)
    ServerCore:RegisterServerRemote('GrowTree', require(ServerStorage.SyncScripts.Server.Buildings.Buildings).GrowTree)
    ServerCore:RegisterServerRemote('RemoveTree', require(ServerStorage.SyncScripts.Server.Buildings.Buildings).RemoveTree)
    
    --# Register remote that all clients will be fired upon use
    ServerCore:RegisterGlobalRemote('UsingPower')
    ServerCore:RegisterGlobalRemote('EquipForAll', true, require(ReplicatedStorage.Client.Minions.Minions).ServerEquip)
    ServerCore:RegisterGlobalRemote('DequipForAll', true, require(ReplicatedStorage.Client.Minions.Minions).ServerDequip)
    ServerCore:RegisterGlobalRemote('BreakBuildingClient')

    --# Register remote that acts like a Remote Function
    ServerCore:RegisterRemoteProxyFunction('BuyMinion', require(ReplicatedStorage.Client.Minions.Minions).CanBuy)

    --# Start server
    Server:Init()

    game:GetService('ReplicatedStorage').Output.OnServerInvoke = function(player)
        print(ServerCore:GetData(player.UserId)[2])
        --return ServerCore:GetData(player.UserId)[2]
    end
    
    --# Saving when game closes
    if SAVE_ON_CLOSE then
        game:BindToClose(function()
            for k,player in pairs(Players:GetChildren()) do
                local success, data = pcall(function()
                    DatabaseLoader.Database:SetAsync(player.UserId, ServerCore.LoadedPlayers[player.UserId][2])
                    ServerCore.LoadedPlayers[player.UserId] = nil
                end)
                if not success then
                    warn('Failed to save on game close')
                end
            end
        end)
    end
end

return ServerCore
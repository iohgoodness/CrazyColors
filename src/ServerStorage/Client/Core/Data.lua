
local Data = {}

function Data.Init()
    _G.Remotes = _G.RS:WaitForChild('Remotes')
    --# Start Database
    Data.DB = nil
    local db = _G.Remotes:WaitForChild('DB')
    db.OnClientEvent:Connect(function(data)
        Data.DB = data
    end)
    db:FireServer()
    repeat wait() until Data.DB ~= nil
    _G.db = Data.DB

    --# Character Check
    local timeout = 50
    repeat
        wait(0.1)
        timeout = timeout - 1
    until (timeout == 0 or _G.Player.Character)
    if _G.Player.Character == nil then return end --# Character was never loaded ( player left the game while still being configured )

    local function handleRemote(remote)
        remote.OnClientEvent:Connect(function(funcData, params)
            (_G.StringToInstance(funcData.ScriptName))[funcData.FuncName](params)
        end)
    end

    local genRemotes = _G.RS:WaitForChild('GeneratedRemotes'):WaitForChild('ClientToHandle')
    genRemotes.ChildAdded:Connect(function(remote)
        handleRemote(remote)
    end)
    for _,remote in pairs(genRemotes:GetChildren()) do
        handleRemote(remote)
    end

    _G.FireRemote = function(remoteName, params)
        if genRemotes:FindFirstChild(remoteName) then
            genRemotes:FireServer(params)
        else warn ('remote', remoteName, 'could not be found!') end
    end
    _G.UI.SpeedTextLabel.Text = _G.db.WalkSpeed .. ' MPH'
end

return Data

local Data = {}

function Data:Init()
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
end

return Data
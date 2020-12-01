
local Data = {}

function Data:Init()
    --# Start Database
    Data.DB = nil
    local db = _G.RS:WaitForChild('Remotes'):WaitForChild('DB')
    db.OnClientEvent:Connect(function(data)
        Data.DB = data
    end)
    db:FireServer()
    repeat wait() until Data.DB ~= nil
    _G.db = Data.DB

    --# Handle Remotes
    _G.RS:WaitForChild('Remotes')
    _G.FireRemote = function(remoteName, params)
        local remote = _G.RS.Remotes:FindFirstChild(remoteName)
        if remote then
            remote:FireServer(params)
        else warn(remoteName, 'not registered') end
    end
end

return Data
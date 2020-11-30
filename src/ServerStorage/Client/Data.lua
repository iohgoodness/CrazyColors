
local Data = {}

function Data:Init()
    Data.DB = nil
    local db = _G.RS:WaitForChild('Remotes'):WaitForChild('DB')
    db.OnClientEvent:Connect(function(data)
        Data.DB = data
    end)
    db:FireServer()
    repeat wait() until Data.DB ~= nil
end

return Data
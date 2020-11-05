
local DataStoreService = game:GetService("DataStoreService")

local db = require(game:GetService('ServerStorage'):WaitForChild('SyncScripts'):WaitForChild('DB'):WaitForChild('PlayerData'))

local DBManage = {}

DBManage.RetryTimer = 1
DBManage.DB = nil
DBManage.Verbose = true

function DBManage:Establish(databaseId)
    local success, data = pcall(function()
        DBManage.DB = DataStoreService:GetDataStore(databaseId)
        if DBManage.Verbose then print('Database', DBManage.DB, 'established') end
    end)
    if not success then
        warn('failed to establish database... trying again in ' .. DBManage.RetryTimer .. ' seconds')
        wait(DBManage.RetryTimer)
        DBManage:Establish(databaseId)
    end
end

function DBManage:Save(playerUserId, data)
    local success, error = pcall(function()
        DBManage.DB:SetAsync(playerUserId, data)
        if DBManage.Verbose then print('Player', playerUserId, 'saved to', DBManage.DB) end
    end)
    if not success then
        warn('failed to save database for '.. playerUserId ..'... trying again in ' .. DBManage.RetryTimer .. ' seconds')
        wait(DBManage.RetryTimer)
        DBManage:Save(playerUserId, data)
    end
end

function DBManage:Load(playerUserId)
    if DBManage.DB ~= nil then
        local success, alreadySavedData = pcall(function()
            return DBManage.DB:GetAsync(playerUserId)
        end)
        if success then
            if alreadySavedData then
                if DBManage.Verbose then print('Player', playerUserId, 'found save from', DBManage.DB) end
                return alreadySavedData
            else
                if DBManage.Verbose then print('Player', playerUserId, 'new db from', DBManage.DB) end
                return db
            end
        else
            warn('failed to load database for '.. playerUserId ..'... trying again in ' .. DBManage.RetryTimer .. ' seconds')
            wait(DBManage.RetryTimer)
            DBManage:Load(playerUserId)
        end
    else
        warn('database not yet established for '.. playerUserId ..' trying to read... trying again in ' .. DBManage.RetryTimer .. ' seconds')
        wait(DBManage.RetryTimer)
        DBManage:Load(playerUserId)
    end
end

return DBManage
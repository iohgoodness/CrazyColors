
local Server = {}

function Server:Init()
    -- require(_G.Sync.Server.AStarPathfinding.AStarPathfinding):Init()


    --[[

    local Data = {
        Leaderstats = {
            Cash = 0,
        }
    }

    local function tracktable(tableref)
        local proxy = newproxy(true)
        local meta = getmetatable(proxy)
        -- meta.__index = tableref
        meta.__index = function(self, index)
            print('=', self, index)
        end
        meta.__newindex = function(self, index, value)
            print('=', self, index, value)
            tableref[index] = value
            --# add the new unknown value to the table
            --if tableref[index] ~= value then
            --    tableref[index] = value
            --end
        end
        return proxy
    end

    local function deepcopy(data)
        local t = type(data)
        local copy
        if t == 'table' then
            copy = {}
            for k,v in pairs(data) do
                copy[deepcopy(k)] = deepcopy(v)
            end
            setmetatable(copy, deepcopy(getmetatable(data)))
        else
            copy = data
        end
        return copy
    end

    local PlayerData = {}
    PlayerData.__index = PlayerData

    function PlayerData.new()
        return setmetatable(deepcopy(Data), PlayerData)
    end

    function PlayerData:GetCash()
        print(self.Leaderstats.Cash)
        return self.Leaderstats.Cash
    end

    function PlayerData:SetCash(cash)
        self.Leaderstats.Cash = cash
    end

    local data1, data2 = PlayerData.new(), PlayerData.new()

    data1:SetCash(400)
    data2:SetCash(1000)
    data1:GetCash()
    data2:GetCash()

    local p = tracktable(data1)

    --print(data1)

    p.Leaderstats = {}
    data1.Leaderstats = {}
    --p.Leaderstats.Cash = 100
    --p.Leaderstats.Rebirths = 0
    --data1.Leaderstats.Rebirths = 0
    
    --print(data1.y)
    --data1.y = '123'
    --data1.Leaderstats.x = 'test'
    --print()


    ]]



    --[[
    local data = {
        Cash = 100,
    }
    local mt = {}

    mt.__index = function(table, index)
        return {
            Cash = 100
        }
    end

    function data.new()
        local self = setmetatable({}, mt)

        self.Cash = 100

        return self
    end

    setmetatable(data, mt)

    local newdata = data.new()

    print(newdata)
    print(newdata.x)
    ]]--


    --[[
    Car = {}
    Car.__index = Car

    function Car.new(name)
        local newcar = {}

        setmetatable(newcar, Car)
        newcar.name = name

        return newcar
    end

    function Car:GetName()
        return self.name
    end

    function Car:SetName(name)
        self.name = name
    end

    local x = Car.new('red')
    print(x:GetName())
    x:SetName('blue')
    print(x:GetName())

    Truck = {}
    Truck.__index = Truck

    setmetatable(Truck, Car)

    function Truck.new()
        local newtruck = {}

        setmetatable(newtruck, Truck)

        newtruck.test = 'here'

        return newtruck
    end

    local t = Truck.new()

    t.name = 'okay'
    t.test = 1

    print(t)
    ]]
    
    --[[
    Car = {}
    Car.__index = Car

    function Car.new(position, driver, model)
        local newcar = {}
        setmetatable(newcar, Car)

        newcar.Position = position
        newcar.Driver = driver
        newcar.Model = model
        newcar.Speed = 0

        return newcar
    end

    function Car:GetSpeed()
        print(self.Speed)
    end

    function Car:Boost()
        self.Speed = self.Speed + 5
    end

    function Car:Break()
        self.Speed = 0
    end

    local newcar = Car.new(
        Vector3.new(1, 0, 1),
        'Guest1892',
        'this car model'
    )

    newcar:Boost()
    newcar:GetSpeed()
    newcar:Break()
    newcar:GetSpeed()
    ]]

    --[[
    local vector2 = {__type = "vector2"}
    local mt = {__index = vector2}
    
    function mt.__div(a, b)
        if (type(a) == "number") then
            -- a is a scalar, b is a vector
            local scalar, vector = a, b
            return vector2.new(scalar / vector.x, scalar / vector.y)
        elseif (type(b) == "number") then
            -- a is a vector, b is a scalar
            local vector, scalar = a, b
            return vector2.new(vector.x / scalar, vector.y / scalar)
        elseif (a.__type and a.__type == "vector2" and b.__type and b.__type == "vector2") then
            -- both a and b are vectors
            return vector2.new(a.x / b.x, a.y / b.y)
        end
    end
    
    function mt.__tostring(t)
        return t.x .. ", " .. t.y;
    end;
    
    function vector2.new(x, y)
        local self = setmetatable({}, mt)
        self.x = x or 0
        self.y = y or 0
        return self
    end
    
    local a = vector2.new(10, 5)
    local b = vector2.new(-3, 4)
    
    print(a / b) -- -3.3333333333333, 1.25
    print(b / a) -- -0.3, 0.8
    print(2 / a) -- 0.2, 0.4
    print(a / 2) -- 5, 2.5
    ]]
    
    --# Network connection to HTTP
    --_G.SendStats('testuserid', {
    --    ['DevProduct.Mana1'] = 100,
    --})
end

return Server
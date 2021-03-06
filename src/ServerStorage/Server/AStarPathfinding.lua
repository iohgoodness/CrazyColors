
local AStarPathfinding = {}

local INCREMENT = 0.8
local INC_MULTI = 1.0
local PART_SIZE = 0.1

--local Start,Finish,Dist

local function createPoint(fromNodeName, position, start, finish)
    local p = _G.inew('Part')
    p.CanCollide = false
    p.TopSurface = Enum.SurfaceType.SmoothNoOutlines
    p.Anchored = true
    p.Size = _G.v3n(PART_SIZE, PART_SIZE, PART_SIZE)
    p.Position = position
    --# Ensure node is updated
    if workspace.Pathfinding.Grid:FindFirstChild(position.X .. '_' .. position.Z) then return end -- workspace.Pathfinding.Grid[(position.X .. '_' .. position.Z)]:Destroy()
    p.Name = position.X .. '_' .. position.Z
    local g, h, f, from = _G.inew('IntValue', p), _G.inew('IntValue', p), _G.inew('IntValue', p), _G.inew('StringValue', p)
    g.Name = 'g' --# Distance from starting node
    h.Name = 'h' --# Distance from ending node
    f.Name = 'f' --# g + h
    from.Name = 'from'
    g.Value = (position-start).magnitude
    h.Value = (position-finish).magnitude
    f.Value = g.Value + h.Value
    from.Value = fromNodeName
    p.Parent = workspace.Pathfinding.Grid
    --if Dist < (position - Finish).magnitude then p:Destroy() return end
    -- : 0.092741250991821
    -- : 0.049764633178711
    p.Touched:Connect(function() end)
    local gtp = p:GetTouchingParts()
    if #gtp > 0 then for k,v in pairs(gtp) do if v.Parent and v.Parent.Name == 'Blocking' then p:Destroy() end end end
end

local function getAroundPositions(position, start)
    return {
        --# adjacent
        _G.v3n(position.X-INCREMENT, start.Y, position.Z),
        _G.v3n(position.X+INCREMENT, start.Y, position.Z),
        _G.v3n(position.X, start.Y, position.Z-INCREMENT),
        _G.v3n(position.X, start.Y, position.Z+INCREMENT),

        -- 0.0039372444152832
        -- 0.0042257308959961

        --# diagonal
        --_G.v3n(position.X-INCREMENT*INC_MULTI, Start.Y, position.Z-INCREMENT*INC_MULTI),
        --_G.v3n(position.X+INCREMENT*INC_MULTI, Start.Y, position.Z+INCREMENT*INC_MULTI),
        --_G.v3n(position.X+INCREMENT*INC_MULTI, Start.Y, position.Z-INCREMENT*INC_MULTI),
        --_G.v3n(position.X-INCREMENT*INC_MULTI, Start.Y, position.Z+INCREMENT*INC_MULTI),
    }
end

local closed = {}
local explored = {}
local function isExplored(nodeName)
    for k,node in pairs(explored) do
        if node.Name == nodeName then print 'explored this one' return true end
    end
    return false
end
local function isClosed(checkNode)
    for k,node in pairs(closed) do
        if node == checkNode then return true end
    end
    return false
end

local function getLowestHNode(duplicateNodes)
    local foundNode, lowest = nil, math.huge
    for k,node in pairs(duplicateNodes) do
        if node.h.Value < lowest and not isClosed(node) and not isExplored(node.Name) then
            lowest = node.h.Value
            foundNode = node
        end
    end
    return foundNode
end
local function duplicateFNode(foundNode)
    local duplicates = {}
    for k,node in pairs(workspace.Pathfinding.Grid:GetChildren()) do
        if node.f.Value == foundNode.f.Value then
            duplicates[#duplicates+1] = node
        end
    end
    return duplicates
end
local function getLowestFNode()
    local foundNode, lowest = nil, math.huge
    for k,node in pairs(workspace.Pathfinding.Grid:GetChildren()) do
        if node.f.Value < lowest and not isClosed(node) and not isExplored(node.Name) then
            lowest = node.f.Value
            foundNode = node
        end
    end
    local dupNodes = duplicateFNode(foundNode)
    if #dupNodes>0 then
        local lowestHCostNode = getLowestHNode(dupNodes)
        closed[#closed+1] = lowestHCostNode
        lowestHCostNode.BrickColor = BrickColor.new('Bright red')
        explored[#explored+1] = foundNode.Name
        return lowestHCostNode
    else
        closed[#closed+1] = foundNode
        foundNode.BrickColor = BrickColor.new('Bright red')
        explored[#explored+1] = foundNode.Name
        return foundNode
    end
end

function AStarPathfinding:GetPath(partA, partB)
    local start, finish = partA.Position, partB.Position
    partA.Position = _G.v3n(_G.floor(partA.Position.X), partA.Position.Y, _G.floor(partA.Position.Z))
    partB.Position = _G.v3n(_G.floor(partB.Position.X), partB.Position.Y, _G.floor(partB.Position.Z))

    for k,pos in pairs(getAroundPositions(partA.Position, start)) do
        createPoint('', pos, start, finish)
    end

    local iterations = 0
    while true do
        local foundNode = getLowestFNode()
        if foundNode.h.Value < 2 then break end
        foundNode.Position = foundNode.Position + _G.v3n(0, 0.5, 0)
        for k,pos in pairs(getAroundPositions(foundNode.Position, start)) do
            createPoint(foundNode.Name, pos, start, finish)
        end
        iterations = iterations + 1
        if iterations > 1000 then warn 'failed to find path' break end
    end

    local backtrack = {closed[#closed]}

    local suc,res = true, nil
    while true do
        suc, res = pcall(function()
            backtrack[#backtrack+1] = workspace.Pathfinding.Grid[backtrack[#backtrack].from.Value]
        end)
        if suc == false then break end
    end

    for k,node in pairs(backtrack) do
        node.Name = #backtrack - (k-1)
    end

    for k,node in pairs(workspace.Pathfinding.Grid:GetChildren()) do
        if tonumber(node.Name) == nil then node:Destroy() end
    end

    return backtrack
end

function AStarPathfinding:Init()
    AStarPathfinding:GetPath(workspace.Pathfinding.Start, workspace.Pathfinding.Finish)
    --AStarPathfinding:CreateGrid(workspace.Pathfinding.Start, workspace.Pathfinding.Finish)
end

return AStarPathfinding
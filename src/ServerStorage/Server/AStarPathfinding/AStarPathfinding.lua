
local AStarPathfinding = {}

local INCREMENT = 1
local PART_SIZE = 0.5

local Start,Finish

local function createPoint(position)
    local p = _G.inew('Part')
    p.TopSurface = Enum.SurfaceType.SmoothNoOutlines
    p.Anchored = true
    p.Size = _G.v3n(PART_SIZE, PART_SIZE, PART_SIZE)
    p.Position = position
    --# Ensure node is updated
    if workspace.Pathfinding.Grid:FindFirstChild(position.X .. '_' .. position.Z) then workspace.Pathfinding.Grid[(position.X .. '_' .. position.Z)]:Destroy() end
    p.Name = position.X .. '_' .. position.Z
    local g, h, f = _G.inew('IntValue', p), _G.inew('IntValue', p), _G.inew('IntValue', p)
    g.Name = 'g' --# Distance from starting node
    h.Name = 'h' --# Distance from ending node
    f.Name = 'f' --# g + h
    g.Value = (position-Start).magnitude
    h.Value = (position-Finish).magnitude
    f.Value = g.Value + h.Value
    p.Parent = workspace.Pathfinding.Grid
end

local function getAroundPositions(position)
    return {
        --# adjacent
        _G.v3n(position.X-INCREMENT, position.Y, position.Z),
        _G.v3n(position.X+INCREMENT, position.Y, position.Z),
        _G.v3n(position.X, position.Y, position.Z-INCREMENT),
        _G.v3n(position.X, position.Y, position.Z+INCREMENT),

        --# diagonal
        _G.v3n(position.X-INCREMENT, position.Y, position.Z-INCREMENT),
        _G.v3n(position.X+INCREMENT, position.Y, position.Z+INCREMENT),
        _G.v3n(position.X+INCREMENT, position.Y, position.Z-INCREMENT),
        _G.v3n(position.X-INCREMENT, position.Y, position.Z+INCREMENT),
    }
end

--# IN TESTING

function AStarPathfinding:CreateGrid(partA, partB)
    Start, Finish = partA.Position, partB.Position
    partA.Position = _G.v3n(_G.floor(partA.Position.X), partA.Position.Y, _G.floor(partA.Position.Z))
    partB.Position = _G.v3n(_G.floor(partB.Position.X), partB.Position.Y, _G.floor(partB.Position.Z))

    for k,pos in pairs(getAroundPositions(partA.Position)) do
        createPoint(pos)
    end

    local lowest, nodes = math.huge, {}
    for k,node in pairs(workspace.Pathfinding.Grid:GetChildren()) do
        if node.f.Value < lowest then
            lowest = node.f.Value
            nodes[#nodes+1] = node
        end
    end
    local lHNode, lowest = nil, math.huge
    for k,node in pairs(nodes) do
        if node.h.Value < lowest then
            lowest = node.f.Value
            lHNode = node
        end
    end
    for k,pos in pairs(getAroundPositions(lHNode.Position)) do
        createPoint(pos)
    end



    local lowest, nodes = math.huge, {}
    for k,node in pairs(workspace.Pathfinding.Grid:GetChildren()) do
        if node.f.Value < lowest then
            lowest = node.f.Value
            nodes[#nodes+1] = node
        end
    end
    local lHNode, lowest = nil, math.huge
    for k,node in pairs(nodes) do
        if node.h.Value < lowest then
            lowest = node.f.Value
            lHNode = node
        end
    end
    for k,pos in pairs(getAroundPositions(lHNode.Position)) do
        createPoint(pos)
    end




    local lowest, nodes = math.huge, {}
    for k,node in pairs(workspace.Pathfinding.Grid:GetChildren()) do
        if node.f.Value < lowest then
            lowest = node.f.Value
            nodes[#nodes+1] = node
        end
    end
    local lHNode, lowest = nil, math.huge
    for k,node in pairs(nodes) do
        if node.h.Value < lowest then
            lowest = node.f.Value
            lHNode = node
        end
    end
    print(lHNode)
    for k,pos in pairs(getAroundPositions(lHNode.Position)) do
        createPoint(pos)
    end


end

function AStarPathfinding:Init()
    AStarPathfinding:CreateGrid(workspace.Pathfinding.Start, workspace.Pathfinding.Finish)
end

return AStarPathfinding

local SpringTest = {}

function SpringTest:Init()
        
    -- This is a localscript

    -- set up some spring
    local spring = require(game.ReplicatedStorage.spring)
    local mySpring = spring.create()

    -- random Random
    local random = Random.new()

    game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
        
        -- update the spring based on deltaTime.
        local movement = mySpring:update(deltaTime)
        -- move the part in workspace based on the spring's movement. don't kill me for the code
        workspace.part.CFrame = CFrame.new(movement.x,5,0)
        
    end)

    while wait(random:NextNumber(.1,1)) do 
        -- shove the spring in a random direction with some sort of hammer. We like random directions, don't we?
        mySpring:shove(Vector3.new(random:NextNumber(-25,25),0,0)) 
    end

end

return SpringTest
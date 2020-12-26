
local Doors = {}

local id = '6130783951'
function Doors:Open(door)
    --# Normally would want this animation to be loaded right off the bat, into the door
    --# so that it's IMMEDIATLY responsive
    
    local animation = _G.inew('Animation')
    animation.AnimationId = "http://www.roblox.com/asset/?id=" .. id
    local track = door.AnimationController:LoadAnimation(animation)
    track:Play()
end

function Doors:Init()
    
end

return Doors
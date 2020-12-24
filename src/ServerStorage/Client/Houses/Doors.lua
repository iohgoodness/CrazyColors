
local Doors = {}

local id = '6130783951'
function Doors:Open(door)
    print 'opening'
    local animation = _G.inew('Animation')
    animation.AnimationId = "http://www.roblox.com/asset/?id=" .. id
    local track = door.AnimationController:LoadAnimation(animation)
    track:Play()
end

function Doors:Init()
    
end

return Doors
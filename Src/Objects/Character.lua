--[[
	Desc: Actor based on object class
	Author: Night_Walker 
	Since: 2018-05-04 19:12:14 
	Last Modified time: 2018-05-04 19:12:14 
	Docs: 
		* Write notes here even more 
]]

local _Actor = require("Src.Core.Class")()

function _Actor:Ctor()

    local data = require "/Data/character/swordman"
    for k,v in pairs(data) do -- copy actor data to this object
        self[k] = v
    end

    self.pos = {x = x, y = y, z = 0}
	self.drawPos = {x = math.floor(x), y = math.floor(y), z = 0}
	self.spd = {x = 60 * 2.5, y = 37.5 * 2} -- 125 125

    self.dir = 1
    
    self.camp = "HERO"

	-- ints
	self.dir = 1
	self.Y = self.pos.y
	self.atkSpeed = 1.2 + 0.30 -- 0.26  0.40  0.70
	self.hitRecovery = 22.5 -- 45 65
	self.hitRecovery = 70 * 0.86 -- 45 65 70 100 
	self.hitTime = 0
	self.actionStop = 170
	self.actionStopTime = 0

end 

function _Actor:Update(dt)
    --body
end 

function _Actor:Draw(x,y)
    --body
end

function _Actor:AddComponent(key, component)
	assert(key, "Key is null.")
	assert(component, "Component is null.")
	self.Components[key] = component
end

function _Actor:DelComponent(k)
	assert(self.Components[k], "no component: " .. k)
    self.Components[k] = nil
end

function _Actor:GetComponent(k)
	assert(self.Components[k], "no component: " .. k)
	return self.Components[k]
end

return _Actor 
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

    self.pos = {x = 0, y = 0}
    self.drawPos = {x = math.floor(x), y = math.floor(y)}
    self.spd = {x = 0, y = 0}

    self.dir = 1
    
    self.camp = "HERO"

    self.input = _Input.New(self)

end 

function _Actor:Update(dt)
    --body
end 

function _Actor:X_Move(offset)
    --body
end 

function _Actor:Y_Move(offset)
    --body
end 

function _Actor:Draw(x,y)
    --body
end

return _Actor 
--[[
	Desc:  move state 
	Author: Night_Walker 
	Since: 2018-02-25 00:28:52 
	Last Modified time: 2018-02-25 00:28:52 
	Docs: 
		* Write notes here even more 
]]

local _State_Move = require("Src.Core.Class")()

function _State_Move:Ctor()
	self.name = "move"
	self.stopRange = 3
end 

function _State_Move:Enter(entity, FSM_)
    
	entity:SetAnimation("[move motion]")
	self.speed = entity:GetSpeed()
	self.pos = entity:GetPos()

end

function _State_Move:Update(entity,FSM_)
	
	self.aim = entity:GetAim()
	self.pos = entity:GetPos()

	local dir_x = (math.floor(self.pos.x) < math.floor(self.aim.x)) and 1 or -1
	local dir_y = (math.floor(self.pos.y) < math.floor(self.aim.y)) and 1 or -1	

	if self.aim.x ~= 0 and self.aim.y ~= 0 then
		if math.abs(self.pos.x - self.aim.x) > self.stopRange then
			entity:X_Move(self.speed.x * dir_x)
		end
		if math.abs(self.pos.y - self.aim.y) > self.stopRange then
			entity:Y_Move(self.speed.y * dir_y)
		end
	end
	
end 

function _State_Move:Exit(entity)
    -- 
end

function _State_Move:SetStopRange(range)
    self.stopRange = range
end

function _State_Move:GetStopRange()
    return self.stopRange
end

return _State_Move 
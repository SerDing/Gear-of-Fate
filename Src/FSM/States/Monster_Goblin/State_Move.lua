--[[
	Desc: move state 
	Author: Night_Walker 
	Since: 2018-02-25 00:28:52 
	Last Modified time: 2018-02-25 00:28:52 
	Docs: 
		* Write notes here even more 
]]

local _State_Move = require("Src.Core.Class")()

function _State_Move:Ctor()
    --body
end 

function _State_Move:Enter(entity, FSM_, x, y)
    self.name = "move"
	entity.pakArr.body:SetAnimation("[move motion]")
	self.speed = entity:GetSpeed()
	self.pos = entity:GetPos()
	self.aim = {
		x = x or 0,
		y = y or 0,
	}
end

function _State_Move:Update(entity,FSM_)
	
	self.aim = entity:GetAim()

	local dir_x = (self.pos.x < self.aim.x) and 1 or -1
	local dir_y = (self.pos.y < self.aim.y) and 1 or -1	

	entity:SetDir(dir_x)

	if self.aim.x ~= 0 and self.aim.y ~= 0 then
		if self.pos.x ~= self.aim.x then
			entity:X_Move(self.speed.x * dir_x)
		end
		
		if self.pos.y ~= self.aim.y then
			entity:Y_Move(self.speed.y * dir_y)
		end
	end
	
end 

function _State_Move:Exit(entity)
    --body
end

return _State_Move 
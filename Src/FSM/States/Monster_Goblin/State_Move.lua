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
	self.name = "move"
	self.stopRange = 20
end 

function _State_Move:Enter(entity, FSM_)
    
	entity:SetAnimation("[move motion]")
	self.speed = entity:GetSpeed()
	self.pos = entity:GetPos()

	-- self.speed = {
	-- 	x = 10,
	-- 	y = 7.5,
	-- }

end

function _State_Move:Update(entity,FSM_)
	
	self.aim = entity:GetAim()

	local dir_x = (self.pos.x < self.aim.x) and 1 or -1
	local dir_y = (self.pos.y < self.aim.y) and 1 or -1	

	if self.aim.x ~= 0 and self.aim.y ~= 0 then
		if math.abs(self.pos.x - self.aim.x) > self.stopRange then
			local _xMoveResult = entity:X_Move(self.speed.x * dir_x)
			if _xMoveResult == false then
				FSM_:SetState("waiting", entity)
			end
		end
		
		if math.abs(self.pos.y - self.aim.y) > self.stopRange then
			local _yMoveResult = entity:Y_Move(self.speed.y * dir_y)	
			if _yMoveResult == false then
				FSM_:SetState("waiting", entity)
			end
		end

		if math.abs(self.pos.x - self.aim.x) <= self.stopRange and math.abs(self.pos.y - self.aim.y) <= self.stopRange then
			FSM_:SetState("waiting", entity)
		end

	end
	
end 

function _State_Move:Exit(entity)
    --body
end

return _State_Move 
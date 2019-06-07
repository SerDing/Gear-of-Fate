--[[
	Desc:  move state 
	Author: Night_Walker 
	Since: 2018-02-25 00:28:52 
	Last Modified time: 2018-02-25 00:28:52 
	Docs: 
		* Write notes here even more 
]]

local _State_Move = require("Src.Core.Class")()

local _GDB = require "Src.Game.GameDataBoard"

function _State_Move:Ctor(FSM, entity)
    self.FSM = FSM
    self.entity = entity
    
	self.name = "move"
	self.stopRange = 3

	self.time_up = 0
    self.time_down = 0
    self.time_left = 0
    self.time_right = 0
end 

function _State_Move:Enter()
    
	self.entity:SetAnimation("[move motion]")
	self.speed = self.entity:GetSpeed()
	self.pos = self.entity:GetPos()
	self.input = self.entity:GetComponent("Input")
	self.time_up = 0
    self.time_down = 0
    self.time_left = 0
    self.time_right = 0
end

function _State_Move:Update()
	
	self.aim = self.entity:GetAim()
	self.pos = self.entity:GetPos()

	local dir_x = (math.floor(self.pos.x) < math.floor(self.aim.x)) and 1 or -1
	local dir_y = (math.floor(self.pos.y) < math.floor(self.aim.y)) and 1 or -1	

	if self.aim.x ~= 0 and self.aim.y ~= 0 then
		if math.abs(self.pos.x - self.aim.x) > self.stopRange then
			if self.entity:X_Move(self.speed.x * dir_x) == false then
				self.FSM:SetState("waiting", self.entity)
			end
		end
		if math.abs(self.pos.y - self.aim.y) > self.stopRange then
			if self.entity:Y_Move(self.speed.y * dir_y) == false then
				self.FSM:SetState("waiting", self.entity)
			end
		end
	end

	-- local up = self.input:IsHold(_GDB.GetKey("UP"))
	-- local down = self.input:IsHold(_GDB.GetKey("DOWN"))
	-- local left = self.input:IsHold(_GDB.GetKey("LEFT"))
	-- local right = self.input:IsHold(_GDB.GetKey("RIGHT"))
	
    -- if up or down then
    --     if up and down then
    --         if self.time_up > self.time_down then
    --             self.entity:Y_Move(-self.entity.speed.y )
    --         else 
    --             self.entity:Y_Move(self.entity.speed.y )
    --         end 
    --     elseif up then
    --         self.entity:Y_Move(-self.entity.speed.y )
    --     else 
    --         self.entity:Y_Move(self.entity.speed.y )
    --     end 
    -- end 
    
    -- if left or right then
    --     if left and right then
    --         if self.time_left > self.time_right then
    --             self.entity:X_Move(- self.entity.speed.x)
    --             self.entity:SetDir(-1)
    --         elseif self.time_left == self.time_right then
    --             self.entity:X_Move(self.entity.speed.x * self.entity:GetDir())
    --         else 
    --             self.entity:X_Move(self.entity.speed.x)
    --             self.entity:SetDir(1)
    --         end 
    --     elseif left then
    --         self.entity:X_Move(- self.entity.speed.x)
	-- 		self.entity:SetDir(-1)
    --     else 
    --         self.entity:X_Move(self.entity.speed.x)
    --         self.entity:SetDir(1)
    --     end
    -- end


    -- if self.input:IsPressed(_GDB.GetKey("UP")) then
    --     self.time_up = love.timer.getTime()
    -- end 
    
    -- if self.input:IsPressed(_GDB.GetKey("DOWN")) then
    --     self.time_down = love.timer.getTime()
    -- end 
    
    -- if self.input:IsPressed(_GDB.GetKey("LEFT")) then
    --     self.time_left = love.timer.getTime()
    -- end 
   
    -- if self.input:IsPressed(_GDB.GetKey("RIGHT")) then
    --     self.time_right = love.timer.getTime()
    -- end 
    
    
    -- if not up and not down and not left and not right then 
    --     self.FSM:SetState(self.FSM.oriState, self.entity)
    -- end 
	
end 

function _State_Move:Exit()
    -- 
end

function _State_Move:SetStopRange(range)
    self.stopRange = range
end

function _State_Move:GetStopRange()
    return self.stopRange
end

return _State_Move 
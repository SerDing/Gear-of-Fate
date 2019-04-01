--[[
	Desc: Monster waiting state 
	Author: Night_Walker 
	Since: 2018-02-25 01:45:13 
	Last Modified time: 2018-02-25 01:45:13 
	Docs: 
		* Write notes here even more 
]]

local _State_Waiting = require("Src.Core.Class")()

local _GDB = require "Src.Game.GameDataBoard"

function _State_Waiting:Ctor()
    --body
end 

function _State_Waiting:Enter(entity)
    self.name = "waiting"
	entity:SetAnimation("[waiting motion]")
	self.input = entity:GetComponent("Input")
end

function _State_Waiting:Update(entity,FSM_)
	
	local _up = _GDB.GetKey("UP")
	local _down = _GDB.GetKey("DOWN")
	local _left = _GDB.GetKey("LEFT")
	local _right = _GDB.GetKey("RIGHT")

	if self.input:IsHold(_up) or self.input:IsHold(_down) then
		FSM_:SetState("move",entity)
	end 
	
	if self.input:IsHold(_left) then
		entity:SetDir(-1)
		FSM_:SetState("move",entity)
	elseif self.input:IsHold(_right) then
		entity:SetDir(1)
		FSM_:SetState("move",entity)
	end
end 

function _State_Waiting:Exit(entity)
    --body
end

return _State_Waiting 
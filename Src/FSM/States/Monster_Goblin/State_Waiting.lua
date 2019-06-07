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

function _State_Waiting:Ctor(FSM, entity)
	self.FSM = FSM
    self.entity = entity
end 

function _State_Waiting:Enter()
    self.name = "waiting"
	self.entity:SetAnimation("[waiting motion]")
	self.input = self.entity:GetComponent("Input")
end

function _State_Waiting:Update()
	
	local _up = _GDB.GetKey("UP")
	local _down = _GDB.GetKey("DOWN")
	local _left = _GDB.GetKey("LEFT")
	local _right = _GDB.GetKey("RIGHT")

	if self.input:IsHold(_up) or self.input:IsHold(_down) then
		self.FSM:SetState("move",self.entity)
	end 
	
	if self.input:IsHold(_left) then
		self.entity:SetDir(-1)
		self.FSM:SetState("move",self.entity)
	elseif self.input:IsHold(_right) then
		self.entity:SetDir(1)
		self.FSM:SetState("move",self.entity)
	end
end 

function _State_Waiting:Exit()
    --body
end

return _State_Waiting 
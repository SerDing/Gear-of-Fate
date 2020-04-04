--[[
	Desc: Monster waiting state 
	Author: SerDing
	Since: 2018-02-25 01:45:13 
	Last Modified time: 2018-02-25 01:45:13 
	Docs: 
		* Write notes here even more 
]]

local _State_Waiting = require("core.class")()
function _State_Waiting:Ctor(FSM, entity)
	self.FSM = FSM
    self._entity = entity
end 

function _State_Waiting:Enter()
    self.name = "waiting"
	self.avatar:Play("stay")
	self.input = self._entity.input
end

function _State_Waiting:Update(dt)
	if self.input:IsPressed("UP") or self.input:IsPressed("DOWN") then
		self.FSM:SetState("move",self._entity)
	end 
	
	if self.input:IsPressed("LEFT") then
		self._entity:SetDir(-1)
		self.FSM:SetState("move",self._entity)
	elseif self.input:IsPressed("RIGHT") then
		self._entity:SetDir(1)
		self.FSM:SetState("move",self._entity)
	end
end 

function _State_Waiting:Exit()
    --body
end

return _State_Waiting 
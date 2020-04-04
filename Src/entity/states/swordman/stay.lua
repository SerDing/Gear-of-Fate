--[[
	Desc: stay state 
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]
local _Base  = require "entity.states.base"

---@class State.Stay : State.Base
local _Stay = require("core.class")(_Base)

function _Stay:Ctor(data, ...)
	_Base.Ctor(self, data, ...) 
end 

function _Stay:Enter()
	_Base.Enter(self)
end

function _Stay:Update(dt) 
	_Base.AutoEndTrans(self)
	if self.input:IsHold("UP") or self.input:IsHold("DOWN") then
		self.STATE:SetState(self._nextState,self._entity)
	end 
	
	if self.input:IsHold("LEFT") then
		self._entity.transform.direction = -1
		self.STATE:SetState(self._nextState, self._entity)
	elseif self.input:IsHold("RIGHT") then
		self._entity.transform.direction = 1
		self.STATE:SetState(self._nextState, self._entity)
	end
end 

function _Stay:Exit()
	_Base.Exit(self)
end

function _Stay:GetTrans()
	return self._trans
end

return _Stay 
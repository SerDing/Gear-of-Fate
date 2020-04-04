--[[
	Desc: UpperSlash state 
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of UpperSlash state in this class
]]
local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base  = require "entity.states.base"

---@class State.UpperSlash : State.Base
local _State_UpperSlash = require("core.class")(_Base)

function _State_UpperSlash:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self.skillID = 46
	self._process = 1
	self._ticks = data.ticks
end 

function _State_UpperSlash:Enter()
	_Base.Enter(self)
	self.combat:ClearDamageArr()
end

function _State_UpperSlash:Update(dt)
	_Base.EaseMove(self)
	_Base.AutoEndTrans(self)
	
	if self.body:GetTick() == self._ticks[1] then
		local param = {master = self._entity}
		_FACTORY.NewEntity(self._entityDataSet[1], param)

		_AUDIO.PlaySound(self._soundDataSet.voice)
		_AUDIO.PlaySound(self._soundDataSet.swing)
	end 
	
	-- if self._entity:GetAttackBox() then
	-- 	self.combat:Judge(self._entity, "MONSTER", self.name)
	-- end
end 

function _State_UpperSlash:Exit()
    _Base.Exit(self)
end

return _State_UpperSlash 
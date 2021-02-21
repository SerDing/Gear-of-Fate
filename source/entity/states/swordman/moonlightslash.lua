--[[
	Desc: Moonlight slash state
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2019-12-06 12:40:40
]]
local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base = require "entity.states.base"

---@class Entity.State.Swordman.MoonlightSlash : State.Base
local _MoonlightSlash = require("core.class")(_Base)

function _MoonlightSlash:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self.skillID = 77
	self._keyFrames = data.keyFrames
	self._ticks = data.ticks
end 

function _MoonlightSlash:Enter()
	_Base.Enter(self)
	_AUDIO.PlaySound(self._soundDataSet.voice) 
	self._process = 1
	self._combat:SetSoundGroup(self._soundDataSet.hitting.hsword)
end

function _MoonlightSlash:Update(dt)
	_Base.EaseMove(self)
	_Base.AutoEndTrans(self)

	if self._process == 1 then
		if self._body:GetTick() == self._ticks[1] then
			self._combat:StartAttack(self._attackDataSet[self._process])
			self:NewEffect()
			_AUDIO.PlaySound(self._soundDataSet.swing[1])
		end
		if self._body:GetFrame() > self._keyFrames[1] then
			if self._input:IsPressed("moonlightslash") then
				self._avatar:Play(self._animNameSet[2])
				self._process = 2
				self._combat:StartAttack(self._attackDataSet[self._process])
				self._combat:ClearAttackedList()
				self:NewEffect()
				_AUDIO.PlaySound(self._soundDataSet.swing[2])
			end
		end
	end
	
end 

function _MoonlightSlash:Exit()
	_Base.Exit(self)
end

function _MoonlightSlash:NewEffect()
	local param = {master = self._entity}
	_FACTORY.NewEntity(self._entityDataSet[self._process], param)
end

return _MoonlightSlash 
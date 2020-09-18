--[[
	Desc: Gorecross state
	Author: SerDing
	Since: 2017-07-28
	Alter: 2020-02-04
]]
local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base = require "entity.states.base"

---@class State.GoreCross : State.Base
---@field protected _ticks table<number, number>
local _GoreCross = require("core.class")(_Base)

function _GoreCross:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self.skillID = 64
	self._ticks = data.ticks
end 

function _GoreCross:Enter()
	_Base.Enter(self)
	_AUDIO.PlaySound(self._soundDataSet.voice)

	---@param effect Entity
	self._NewProjectile = function(effect)
		local t = effect.transform
		local param = {
			x = t.position.x + t.direction * effect.render.renderObj:GetWidth() * 0.75,
			y = t.position.y,
			z = t.position.z - effect.render.renderObj:GetHeight() / 2,
			direction = t.direction,
			master = self._entity,
			camp = self._entity.identity.camp,
		}
		_FACTORY.NewEntity(self._entityDataSet[3], param)
	end

	local param = { master = self._entity }
	_FACTORY.NewEntity(self._entityDataSet[1], param)
	self._crossEffect = _FACTORY.NewEntity(self._entityDataSet[2], param)
	self._crossEffect.identity.destroyEvent:AddListener(self._crossEffect, self._NewProjectile)

	self._projectile = nil
	self._startSecJudge = false
	self.combat:ClearDamageArr()
end

function _GoreCross:Update(dt)
   
	-- attack judgement
	if self.body:GetTick() == 6 and not self._startSecJudge then
		self.combat:ClearDamageArr()
		self._startSecJudge = true
	end

	local tick = self.body:GetTick()
	if tick == 3 or tick == 7 then 
		_AUDIO.PlaySound(self._soundDataSet.swing[1])
	elseif tick == 10 then 
		_AUDIO.PlaySound(self._soundDataSet.swing[2])
	end
	
	_Base.AutoEndTrans(self)
end 

function _GoreCross:Exit()
	_Base.Exit(self)
end

return _GoreCross 
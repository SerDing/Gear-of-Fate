--[[
	Desc: State base
	Author: SerDing
	Since: 2019-06-08
	Alter: 2020-10-04
]]
local _RESMGR = require("system.resource.resmgr")
local _RESOURCE = require("engine.resource")

---@class State.Base
---@field protected _name string
---@field protected _entity Entity
---@field public _animNameSet table<number, string>
---@field public _avatar Entity.Drawable.Avatar
---@field public _body Entity.Drawable.Frameani
---@field public _STATE Entity.Component.State
---@field public _render Entity.Component.Render
---@field public _input Entity.Component.Input
---@field public _movement Entity.Component.Movement
---@field public _combat Entity.Component.Combat
local _State = require("core.class")()

function _State.HandleData(data)
	if data.sound then
		data.soundDataSet = _RESOURCE.RecursiveLoad(data.sound, _RESOURCE.LoadSoundData)
		data.sound = nil
	end

	if data.entity then
		data.entityDataSet = _RESOURCE.RecursiveLoad(data.entity, _RESMGR.LoadEntityData)
		data.entity = nil
	end
end

---@param data table
---@param name string
function _State:Ctor(data, name)
	self._name = name
	self._tags = data.tags
	self._nextState = data.nextState
	self._easeMoveData = data.easeMoveData
	self._trans = data.trans
	self._animNameSet = data.animNameSet
	self._soundDataSet = data.soundDataSet
	self._entityDataSet = data.entityDataSet
	self._attackDataSet = data.attack
end

function _State:Init(entity)
	self._entity = entity
	self._input = self._entity.input
	self._render = self._entity.render
	self._movement = self._entity.movement
	self._combat = self._entity.combat

	self._avatar = self._render.renderObj
	self._body = self._avatar:GetPart()

	self:InitAnimData()
end

function _State:InitAnimData()
	self._avatar:InitAnimDatas(self._animNameSet)
end

function _State:ReloadAnimData(part)
	self._avatar:LoadAnimDatas(part, self._animNameSet)
end

function _State:Enter()
	if self:HasTag("autoPlay") then
		self._avatar:Play(self._animNameSet[1])
	end
	if self:HasTag("attackRate") then
		self._entity.render.rate = self._entity.stats.attackRate
	end
end

function _State:Update(dt)
end

function _State:AutoEndTrans()
	if self:HasTag("autoTrans") then
		self._STATE:AutoTrans(self._nextState)
	end
end

function _State:EaseMove()
	local main = self._avatar:GetPart()
	for _, data in pairs(self._easeMoveData) do
		if self._process == data.process then
			if main:GetFrame() == data.frame then
				self._movement:EaseMove(data.param.type, data.param.v, data.param.a, data.param.addRate or 0)
			end
		end
	end
end

function _State:Exit()
	if self:HasTag("attackRate") then
		self._entity.render.rate = 1.0
	end 
	self._combat:FinishAttack()
	self._movement:DisableEasemove()
end

function _State:HasTag(tag)
	return self._tags[tag] == true
end

function _State:IsFlawState()
	return false
end

function _State:GetName()
	return self._name
end

return _State
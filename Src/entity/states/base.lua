--[[
	Desc: State base
	Author: SerDing
	Since: 2019-06-08
	Alter: 2019-12-04
]]
local _RESMGR = require("system.resource.resmgr")
local _RESOURCE = require("engine.resource")

---@class State.Base
---@field protected _name string
---@field protected _entity Entity
---@field public _animNameSet table<number, string>
---@field public avatar Entity.Drawable.Avatar
---@field public body Entity.Drawable.Frameani
---@field public STATE Entity.Component.State
---@field public render Entity.Component.Render
---@field public input Entity.Component.Input
---@field public movement Entity.Component.Movement
---@field public combat Entity.Component.Combat
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

---@param entity Swordman
function _State:Ctor(data, name)
	self._name = name
	self._tags = data.tags
	self._nextState = data.nextState
	self._easeMoveData = data.easeMoveData
	self._trans = data.trans
	self._animNameSet = data.animNameSet
	self._soundDataSet = data.soundDataSet
	self._entityDataSet = data.entityDataSet
end

function _State:Init(entity)
	self._entity = entity
	self.FSM = self._entity.state
	self.input = self._entity.input
	self.render = self._entity.render
	self.movement = self._entity.movement
	self.combat = self._entity.combat

	self.avatar = self.render.renderObj
	self.body = self.avatar:GetPart()

	self:InitAnimData()
end

function _State:InitAnimData()
	self.avatar:InitAnimDatas(self._animNameSet)
end

function _State:ReloadAnimData(part)
	self.avatar:LoadAnimDatas(part, self._animNameSet)
end

function _State:Enter()
	if self:HasTag("autoPlay") then
		self.avatar:Play(self._animNameSet[1])
	end
	if self:HasTag("attackRate") then
		self._entity.render.rate = self._entity.stats.attackRate
	end
end

function _State:Update(dt)
end

function _State:AutoEndTrans()
	if self:HasTag("autoTrans") then
		self.STATE:AutoTrans(self._nextState)
	end
end

function _State:Exit()
	if self:HasTag("attackRate") then
		self._entity.render.rate = 1.0
	end 
	self.movement.easeMoveParam.enable = false
end

function _State:HasTag(tag)
	return self._tags[tag] == true
end

function _State:GetName()
	return self._name
end

function _State:EaseMove()
	local main = self.avatar:GetPart()
	for _, data in pairs(self._easeMoveData) do
		if self._process == data.process then
			if main:GetFrame() == data.frame then
				self.movement:EaseMove(data.param.type, data.param.v, data.param.a, data.param.addRate or 0)
			end
		end
	end
end

return _State
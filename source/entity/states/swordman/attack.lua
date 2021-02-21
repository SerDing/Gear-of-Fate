--[[
	Desc: Normal attack state
 	Author: SerDing
	Since: 2017-07-28
	Alter: 2020-03-29
]]

local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base = require("entity.states.base")
local _INPUT = require("engine.input")

---@class Entity.State.Swordman.Attack : State.Base
local _Attack = require("core.class")(_Base)

function _Attack:Ctor(data, ...)
    _Base.Ctor(self, data, ...)
    self._process = 0
    self._keyFrames = data.keyFrames
    self._ticks = data.ticks
    self._combo = #self._keyFrames + 1
    self._keypress = false
    
end

function _Attack:Enter()
    _Base.Enter(self)
    self._process = 1
    -- if self._entity.atkMode == "frenzy" then
    --     self.STATE:SetState("frenzyattack")
    --     returns
    -- end
    self._combat:SetSoundGroup(self._soundDataSet.hitting.hsword)
    self:_OnSetProcess(self._process)
    _INPUT.Register(self)
end

function _Attack:Update(dt)
    _Base.EaseMove(self)

    if self._process < self._combo and self._body:GetFrame() > self._ticks[self._process]  then --
        self:SetProcess(self._process + 1)
    end

    _Base.AutoEndTrans(self)
end

function _Attack:SetProcess(nextProcess)
    if self._keypress then
        self._process = nextProcess
        self._keypress = false
        self._avatar:Play(self._animNameSet[self._process])
        self:_OnSetProcess(nextProcess)
    end
end

function _Attack:_OnSetProcess(process)
    self._combat:StartAttack(self._attackDataSet[process])
    local subtype = self._entity.equipment:GetSubtype("weapon")
    _AUDIO.RandomPlay(self._soundDataSet.swing[subtype])
    _AUDIO.RandomPlay(self._soundDataSet.voice)
    -- _FACTORY.NewEntity(self._entityDataSet[self._process], {master = self._entity})
end

function _Attack:GetTrans()
    return self._trans
end

---@param action string
function _Attack:OnPress(action)
    -- print("_Attack:Press:", action)
    if action == "ATTACK" then
        self._keypress = true
    end
end

---@param action string
function _Attack:OnRelease(action)
    -- print("_Attack:Release:", action)
end

function _Attack:Exit()
    _INPUT.UnRegister(self)
    _Base.Exit(self)
end

return _Attack 
--[[
	Desc: Normal attack state
 	Author: SerDing
	Since: 2017-07-28
	Alter: 2020-03-29
]]

local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _Base = require("entity.states.base")

local _INPUT = require("engine.input.init")

---@class AttackState : State.Base
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
    self.combat:ClearDamageArr()
    self:_OnSetProcess(self._process)
    _INPUT.Register(self)
end

function _Attack:Update(dt)
    _Base.EaseMove(self)

    if self._process < self._combo and self.body:GetFrame() >= self._keyFrames[self._process] then
        self:SetProcess(1, self._process + 1) -- self._keyFrames[self._process]
    end

    -- if self._entity:GetAttackBox() then
    --     self.combat:Judge(self._entity, "MONSTER")
    -- end

    _Base.AutoEndTrans(self)
end

function _Attack:Exit()
    _Base.Exit(self)
    _INPUT.UnRegister(self)
end

function _Attack:SetProcess(keyFrame, nextProcess)
    if self._keypress  then --and self.body:GetFrame() >= keyFrame
        self._process = nextProcess
        self._keypress = false
        self.combat:ClearDamageArr()
        self.avatar:Play(self._animPathSet[self._process])
        self:_OnSetProcess(nextProcess)
    end
end

function _Attack:_OnSetProcess(process)
    -- if process == 1 then
    --     self:Effect("bloodinkanet/bloodinkanet_attack1.ani")
    -- elseif process == 2 then
    --     self:Effect("bloodinkanet/bloodinkanet_attack2.ani")
    -- elseif process == 3 then
    --     self:Effect("bloodinkanet/bloodinkanet_attack3.ani")
    -- elseif process == 4 then
    --     self:Effect("bloodinkanet/bloodinkanet_attack4.ani")
    -- end
    -- local param = {master = self._entity}
    -- _FACTORY.NewEntity(self._entityDataSet[self._process], param)

    _AUDIO.RandomPlay(self._soundDataSet.voice)
    local subtype = self._entity.equipment:GetSubtype("weapon")
    _AUDIO.RandomPlay(self._soundDataSet.swing[subtype])
end

function _Attack:GetTrans()
    return self._trans
end

---@param action string
function _Attack:Press(action)
    print("_Attack:Press:", action)
    if action == "ATTACK" then
        self._keypress = true
    end
end

---@param action string
function _Attack:Release(action)
    -- print("_Attack:Release:", action)
end

return _Attack 
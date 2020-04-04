--[[
    Desc: Stats Component for entity
    Author: SerDing
    Since: 2019-11-24
    Alter: 2019-11-24
]]

local _Value = require("utils.value")
local _Base = require("component.base")

---@class Entity.Component.Stats : Entity.Component.Base
local _Stats = require("core.class")(_Base)

function _Stats:Ctor(entity, data)
    _Base.Ctor(self)

    self.maxhp = data.maxhp or 100
    self.maxmp = data.maxmp or 100
    self.hpRecovery = data.hpRecovery or 0
    self.mpRecovery = data.mpRecovery or 0
    self.hp = _Value.New(data.hp or self.maxhp, self.maxhp, self.hpRecovery)
    self.mp = _Value.New(data.mp or self.maxmp, self.maxmp, self.mpRecovery)
    self.attack = data.attack or 10
    self.defense = data.defense or 10
    self.critical = data.critical or 0
    self.attackRate = data.attackRate or 1.0
    self.moveRate = data.moveRate or 1.0
    self.moveSpeed = data.moveSpeed or 100
    self.hitstopTime = data.hitstopTime or 75
end

function _Stats:Update(dt)
    self.hp:Update(dt)
    self.mp:Update(dt)
end

return _Stats
--[[
    Desc: Identity Component
    Author: SerDing
    Since: 2019-12-02
    Alter: 2019-12-02
]]

---@class Entity.Component.Identity : Entity.Component.Base
---@field public name string
---@field public type string
---@field public id number
---@field public process number
---@field public master Entity
---@field public camp int
local _Identity = require("core.class")()

function _Identity:Ctor(data, param)
    self.name = param.name or ""
    self.job = data.job or ""
    self.type = data.type or ""
    self.master = param.master or nil
    self.camp = param.camp or 0
    self.id = -1
    self.process = 2
end


return _Identity
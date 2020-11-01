--[[
    Desc: Compoennt Base
    Author: SerDing
    Since: 2019-11-4
    Alter: 2019-11-7
]]

---@class Entity.Component.Base
---@field public enable boolean
---@field protected _entity Entity
local _Component = require("core.class")()

---@param entity Entity
function _Component:Ctor(entity)
    self.enable = true
    self._entity = entity
end

---@param dt float
function _Component:Update(dt)
end

function _Component:Draw()
end

return _Component
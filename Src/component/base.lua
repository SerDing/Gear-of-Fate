--[[
    Desc: Compoennt Base
    Author: SerDing
    Since: 2019-11-4
    Alter: 2019-11-7
]]

---@class Entity.Component.Base
---@field protected _entity Entity
---@field public enable boolean
local _Component = require("core.class")()

function _Component:Ctor(entity)
    self._entity = entity
    self.enable = true
end

function _Component:Update(dt)
end

function _Component:Draw()
end

return _Component
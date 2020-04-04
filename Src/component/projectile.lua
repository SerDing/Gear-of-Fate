--[[
    Desc: a component for projectile logic
    Author: SerDing
    Since: 2020-03-18
    Alter: 2020-03-18
]]

---@class Component.Projectile : Entity.Component.Base
local _Projectile = require("core.class")()

function _Projectile:Ctor(entity, data, param)
    self._entity = entity
    self.enable = true
end

return _Projectile
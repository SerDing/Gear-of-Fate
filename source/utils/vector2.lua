--[[
	Desc: 2d vector
 	Author: SerDing
	Since: 2019-11-08
	Alter: 2017-11-08 
]]
---@class Vector2
local _Vector2 = require("core.class")()

---@param x number
---@param y number
---@param z number
function _Vector2:Ctor(x, y)
    self:Set(x, y)
end

function _Vector2:Set(x, y)
    self.x = x or 0
    self.y = y or 0
end

function _Vector2:Get()
    return self.x, self.y
end

return _Vector2
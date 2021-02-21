--[[
	Desc: 3d vector
 	Author: SerDing
	Since: 2019-07-16 11:08
	Alter: 2017-07-30 
]]
---@class Vector3
local _Vector3 = require("core.class")()

---@param x number
---@param y number
---@param z number
function _Vector3:Ctor(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

---@param x number
---@param y number
---@param z number
function _Vector3:Set(x, y, z)
    self.x = x or self.x
    self.y = y or self.y
    self.z = z or self.z
end

function _Vector3:Get()
    return self.x, self.y, self.z
end

return _Vector3
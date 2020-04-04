--[[
	Desc: Transform Component
 	Author: SerDing
	Since: 2019-11-07 
	Alter: 2017-11-07 
]]

local _Vector2 = require("utils.vector2")
local _Vector3 = require("utils.vector3")

---@class Entity.Component.Transform : Entity.Component.Base
---@field public position Vector3
---@field public scale Vector2
---@field public rotation number @per degree
local _Transform = require("core.class")()

function _Transform:Ctor(data, param)
    self.position = _Vector3.New(param.x or 0, param.y or 0, param.z or 0)
    self.scale = _Vector2.New(1, 1)
	self.rotation = data.rotation or 0
	self.direction = param.direction or 1

	if data.scale then
		self.scale:Set(data.scale.x, data.scale.y)
	end
end

function _Transform:SetPosition(x, y, z)
	self.position:Set(x, y, z)
end

function _Transform:SetScale(x, y)
	self.scale:Set(x, y)
end

return _Transform
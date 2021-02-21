--[[
	Desc: Mouse module
	Author: SerDing
	Since: 2021-01-22 19:40:00
	Alter: 2021-01-26 00:12:00
]]

local _GRAPHICS = require("engine.graphics.graphics")

---@class Engine.Mouse
local _MOUSE = require("core.class")()

---@param x float @ can be null
---@param y float @ can be null
function _MOUSE.GetScaledMousePosition(x, y)
	x = x or love.mouse.getX()
	y = y or love.mouse.getY()
	local ratio = _GRAPHICS.GetDimensionRatio()
	return x / ratio.x, y / ratio.y
end

function _MOUSE.GetRawPosition()
	return love.mouse.getPosition()
end

return _MOUSE
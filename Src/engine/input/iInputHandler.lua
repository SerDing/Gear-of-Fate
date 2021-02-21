--[[
	Desc: input interface, receive and handle input messages from input manager
	Author: SerDing
	Since: 2018-04-06
	Alter: 2018-04-06
]]
---@class Engine.Input.InputHandler
local _InputHandler = require("core.class")()

function _InputHandler:Ctor()
end 

---@param button string
function _InputHandler:OnPress(button)
end

---@param button string
function _InputHandler:OnRelease(button)
end

---@param x float
---@param y float
---@param button int @left:1, middle:2, right:3.
---@param istouch boolean
function _InputHandler:MousePressed(x, y, button, istouch)
end

---@param x float
---@param y float
---@param button int @left:1, middle:2, right:3.
---@param istouch boolean
function _InputHandler:MouseReleased(x, y, button, istouch)
end

---@param x float
---@param y float
---@param dx float
---@param dy float
function _InputHandler:MouseMoved(x, y, dx, dy)
end

return _InputHandler
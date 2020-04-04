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

---@param action string
function _InputHandler:Press(action)
end

---@param action string
function _InputHandler:Release(action)
end

return _InputHandler
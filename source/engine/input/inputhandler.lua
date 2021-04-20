--[[
	Desc: Input handler, receive and handle input messages from input manager
	Author: SerDing
	Since: 2018-04-06
	Alter: 2018-04-06
]]
---@class Engine.Input.InputHandler
local _InputHandler = require("core.class")()

function _InputHandler:Ctor()
end 

function _InputHandler:HandleAction(action, state)
end

function _InputHandler:HandleAxis(axis, value)
end

return _InputHandler
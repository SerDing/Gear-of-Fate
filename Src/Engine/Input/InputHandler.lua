--[[
	Desc: input interface
	Author: SerDing
	Since: 2018-04-06 16:11:06 
	Last Modified time: 2018-04-06 16:11:06 
	Docs: 
        * An interface for any class that want to receive and handle input messages from input manager
]]
---@class InputHandler
local _InputHandler = require("Src.Core.Class")()

function _InputHandler:Ctor()
end 

function _InputHandler:Press(key)
end

function _InputHandler:Release(key)
end

return _InputHandler
--[[
	Desc: Input Manager
	Author: SerDing
	Since: 2018-04-06 16:21:59 
	Last Modified time: 2018-04-06 16:21:59 
	Docs: 
		* handle input messages and register input observer
	Design(new):
        * hold input mapping: key --> action

]]

local _InputMgr = {}
local _InputMap = require("Data.input.InputMap")
local _InputHandlers = {} ---@type InputHandler[]

function _InputMgr.PressHandle(key)
    key = _InputMap.keyboard[key] or key -- translate key to action, if there is a key-value pair for key
    for i=1,#_InputHandlers do
        if not _InputHandlers[i]:GetActor():IsAI() then
            _InputHandlers[i]:Press(key)
        end
    end
end 

function _InputMgr.ReleaseHandle(key)
    key = _InputMap.keyboard[key] or key -- translate key to action, if there is a key-value pair for key
    for i=1,#_InputHandlers do
        if not _InputHandlers[i]:GetActor():IsAI() then
            _InputHandlers[i]:Release(key)
        end
    end
end

function _InputMgr.Register(inputHandler)
    _InputHandlers[#_InputHandlers + 1] = inputHandler
end

return _InputMgr
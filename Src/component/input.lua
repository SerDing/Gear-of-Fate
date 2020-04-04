--[[
	Desc: Input component
	Author: SerDing
	Since: 2018-04-06 16:11:06 
	Last Modified time: 2018-04-06 16:11:06 
	Docs: 
        * Receive and cache input messages for entity, implement input handler interface.
        * When you create an instance for a entity, it will register itself to the input module of engine.
        * skillInputMap is used to map some skill shortcut messages to concrete skill messages
]]

local _INPUT = require("engine.input.init")
local _Base = require("component.base")

---@class Entity.Component.Input : Engine.Input.InputHandler
---@field protected _actionMap table @ map of actions
---@field public isAIControl boolean 
---@field public skillInputMap table<string, string>
local _Input = require("core.class")(_Base)

local _enum = {pressed = 0, hold = 1, released = 2}

function _Input:Ctor(entity, data)
    _Base.Ctor(self, entity) 
    self._actionMap = {}
    self.skillInputMap = data.skillInputMap or {}
    self.isAIControl = false
    _INPUT.Register(self)
end 

function _Input:Update(dt)
    for k in pairs(self._actionMap) do
        if (self._actionMap[k] == _enum.pressed) then
            self._actionMap[k] = _enum.hold
		elseif (self._actionMap[k] == _enum.released) then
			self._actionMap[k] = nil
		end
    end
end

---@param action string
function _Input:IsPressed(action)
	return self._actionMap[action] == _enum.pressed
end

---@param action string
function _Input:IsHold(action)
	return self._actionMap[action] == _enum.hold
end

---@param action string
function _Input:IsReleased(action)
	return self._actionMap[action] == _enum.released
end

---@param action string
function _Input:Press(action)
    action = self.skillInputMap[action] or action -- translate shortcut action to skill action
    if not self._actionMap[action] then
        self._actionMap[action] = _enum.pressed

        return true
    end
    return false
end

---@param action string
function _Input:Release(action)
    action = self.skillInputMap[action] or action -- translate skill action
    if self._actionMap[action] and self._actionMap[action] ~= _enum.released then
        self._actionMap[action] = _enum.released
        
        return true
    end
    return false
end

function _Input:SetAIControl(control)
    self.isAIControl = control
    if control == true then
        _INPUT.UnRegister(self)
    elseif control == false then
        _INPUT.Register(self)
    end
end

return _Input 
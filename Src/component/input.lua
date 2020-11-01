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
---@field protected _buttonMap table @ map of actions
---@field public isAIControl boolean 
---@field public skillInputMap table<string, string>
local _Input = require("core.class")(_Base)

local _enum = {pressed = 0, hold = 1, released = 2}

function _Input:Ctor(entity, data)
    _Base.Ctor(self, entity)
    self._buttonMap = {}
    self.skillInputMap = data.skillInputMap or {}
    self.isAIControl = false
    _INPUT.Register(self)
end 

function _Input:Update(dt)
    for k in pairs(self._buttonMap) do
        if (self._buttonMap[k] == _enum.pressed) then
            self._buttonMap[k] = _enum.hold
		elseif (self._buttonMap[k] == _enum.released) then
			self._buttonMap[k] = nil
		end
    end
end

---@param button string
function _Input:IsPressed(button)
	return self._buttonMap[button] == _enum.pressed
end

---@param button string
function _Input:IsHold(button)
	return self._buttonMap[button] == _enum.hold
end

---@param button string
function _Input:IsReleased(button)
	return self._buttonMap[button] == _enum.released
end

---@param button string
function _Input:Press(button)
    button = self.skillInputMap[button] or button -- translate shortcut action to skill action
    if not self._buttonMap[button] then
        self._buttonMap[button] = _enum.pressed

        return true
    end
    return false
end

---@param button string
function _Input:Release(button)
    button = self.skillInputMap[button] or button -- translate skill action
    if self._buttonMap[button] and self._buttonMap[button] ~= _enum.released then
        self._buttonMap[button] = _enum.released
        
        return true
    end
    return false
end

function _Input:OnPress(button)
    if self._entity.aic.enable == false then
        self:Press(button)
    end
end

function _Input:OnRelease(button)
    if self._entity.aic.enable == false then
        self:Release(button)
    end
end

return _Input 
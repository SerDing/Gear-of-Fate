--[[
	Desc: input class
	Author: SerDing
	Since: 2018-04-06 16:11:06 
	Last Modified time: 2018-04-06 16:11:06 
	Docs: 
        * Receive and cache input messages for every game actor, implement input handler interface
        * When you create an instance for an actor, it will register itself to InputMgr
]]
---@class Input : InputHandler
local _InputHandler = require("Src.Engine.Input.InputHandler")
local _Input = require("Src.Core.Class")(_InputHandler)
local _InputMgr = require "Src.Engine.Input.InputMgr"
local _enum = {pressed = 0, hold = 1, released = 2}

function _Input:Ctor(actor)
    self.actions = {}
    self.actor = actor
    _InputMgr.Register(self)
end 

function _Input:Update(dt)
    for k in pairs(self.actions) do
        if (self.actions[k] == _enum.pressed) then
            self.actions[k] = _enum.hold
		elseif (self.actions[k] == _enum.released) then
			self.actions[k] = nil
		end
    end
end

---@param action string
function _Input:IsPressed(action)
	return self.actions[action] == _enum.pressed
end

---@param action string
function _Input:IsHold(action)
	return self.actions[action] == _enum.hold
end

---@param action string
function _Input:IsReleased(action)
	return self.actions[action] == _enum.released
end

---@param action string
function _Input:Press(action)
    action = self.actor.skillShortcutsMap[action] or action -- translate skill action
    if not self.actions[action] then
        self.actions[action] = _enum.pressed

        return true
    end
    return false
end

---@param action string
function _Input:Release(action)
    action = self.actor.skillShortcutsMap[action] or action -- translate skill action
    if self.actions[action] and self.actions[action] ~= _enum.released then
        self.actions[action] = _enum.released
        
        return true
    end
    return false
end

function _Input:GetActor()
    return self.actor
end

return _Input 
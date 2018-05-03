--[[
	Desc: input class
	Author: Night_Walker 
	Since: 2018-04-06 16:11:06 
	Last Modified time: 2018-04-06 16:11:06 
	Docs: 
        * An abstract class of input layer for every game actor
        * When you create an implementation for an actor, it will register itself to InputHandler
]]

local _Input = require("Src.Core.Class")()
local _InputHandler = require "Src.Input.InputHandler"
local _enum = {pressed = 0, hold = 1, released = 2}

function _Input:Ctor(actor)
    self.keys = {}
    self.actor = actor
    _InputHandler.Register(self)
end 

function _Input:Update(dt)
    for k in pairs(self.keys) do
		if (self.keys[k] == _enum.pressed) then
			self.keys[k] = _enum.hold
		elseif (self.keys[k] == _enum.released) then
			self.keys[k] = nil
		end
	end
end 

function _Input:IsPressed(key)
	return self.keys[key] == _enum.pressed
end

function _Input:IsHold(key)
	return self.keys[key] == _enum.hold
end

function _Input:IsReleased(key)
	return self.keys[key] == _enum.released
end

function _Input:Press(key)
    if not self.keys[key] then
        self.keys[key] = _enum.pressed
        
        return true
    end

    return false
end

function _Input:Release(key)
    if self.keys[key] and self.keys[key] ~= _enum.released then
        self.keys[key] = _enum.released
        
        return true
    end

    return false
end

function _Input:GetActor()
    return self.actor
end

return _Input 
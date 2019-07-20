--[[
	Desc: input class
	Author: Night_Walker 
	Since: 2018-04-06 16:11:06 
	Last Modified time: 2018-04-06 16:11:06 
	Docs: 
        * An abstract class of input layer for every game actor
        * When you create an implementation for an actor, it will register itself to InputMgr
]]

local _Input = require("Src.Core.Class")()
local _InputMgr = require "Src.Input.InputMgr"
local _enum = {pressed = 0, hold = 1, released = 2}

function _Input:Ctor(actor)
    self.keys = {}
    self.previous = {}
    self.time = {}
    self.stayTime = 1 / 60 * 2
    self.actor = actor
    _InputMgr.Register(self)
end 

function _Input:Update(dt)
    for k in pairs(self.keys) do
        if (self.keys[k] == _enum.pressed) then
            self.keys[k] = _enum.hold
		elseif (self.keys[k] == _enum.released) then
			self.keys[k] = nil
		end
    end

    -- for k in pairs(self.previous) do
    --     if self.previous[k] == _enum.pressed then
    --         self.time[k] = self.time[k] + dt
    --         if self.time[k] >= self.stayTime then
    --             self.previous[k] = nil
    --             self.time[k] = nil
    --         end 
    --     end
    -- end
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
    -- if self.actor.IsHitStop and self.actor:IsHitStop() then
    --     if not self.previous[key] then
    --         self.previous[key] = _enum.pressed
    --         self.time[key] = 0
    --     end
    -- end
    
    if not self.keys[key] then
        self.keys[key] = _enum.pressed
        -- if not self.time[key] then
        --     self.time[key] = 0
        -- end    
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
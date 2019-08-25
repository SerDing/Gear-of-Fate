--[[
	Desc: Event, a realization of observer pattern like event in C sharp.
	Author: SerDing 
	Since: 2019-03-14 20:19:14 
	Alter: 2019-03-14 20:19:14 
	Docs: 
		* Remember Delete listener reference if it has been destroyed.
]]

local _Event = require("Src.Core.Class")() ---@class Event

---@field protected _listeners @list

function _Event:Ctor()
    self._listeners = {}
end 

---@param obj table
---@param func function
function _Event:AddListener(obj, func)
	assert(func, "Function is null.")
    self._listeners[#self._listeners + 1] = {obj = obj, Func = func}
end 

---@param obj table
---@param func function
---@return boolean whether successful
function _Event:DelListener(obj, func)
    for n=#self._listeners, 1, -1 do
		if self._listeners[n].obj == obj and self._listeners[n].Func == func then
			table.remove(self._listeners, n)
			
			return true
		end
	end
	
	return false
end

function _Event:Notify(...)
	for n=#self._listeners, 1, -1 do
		if not self._listeners[n].obj then
			self._listeners[n].Func(...)
		elseif self._listeners[n].obj.HasDestroyed and self._listeners[n].obj.HasDestroyed() then
			table.remove(self._listeners, n)
		else
			self._listeners[n].Func(self._listeners[n].obj, ...)
		end
	end
end

return _Event 
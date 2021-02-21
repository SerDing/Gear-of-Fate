--[[
	Desc: Stack (base data structure)
	Author: SerDing 
	Since: 2018-10-01 00:39:07 
	Last Modified time: 2018-10-01 00:39:07 

]]

local _Stack = require("core.class")()

local _defaultCapacity = 10
function _Stack:Ctor(capacity)
    self._capacity = capacity or _defaultCapacity
    self._top = 0
    self._stack = {}
end

---@generic T : GUI.Panel
---@param e T
function _Stack:Push(e)
    assert(self._top ~= self._capacity, "_Stack:Push(e)  stack is full!")
    self._stack[#self._stack + 1] = e
    self._top = self._top + 1
end

---@generic T : GUI.Panel
---@return T
function _Stack:Pop() -- return the element deleted
    assert(self._top ~= 0, "_Stack:Pop()  stack is empty!")
    local e = self._stack[#self._stack]
    self._stack[#self._stack] = nil
    self._top = self._top - 1
    return e
end

function _Stack:IsEmpty()
    return #self._stack == 0
end

--- get top element
---@generic T : GUI.Panel
---@return T
function _Stack:GetTopE()
    return self._stack[self._top]
end

function _Stack:GetContext()
    return self._stack
end

function _Stack:Size()
    return #self._stack
end

function _Stack:Capacity()
    return self._capacity
end

return _Stack 
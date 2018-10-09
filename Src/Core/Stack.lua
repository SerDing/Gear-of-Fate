--[[
	Desc: Stack (base data structure)
	Author: SerDing 
	Since: 2018-10-01 00:39:07 
	Last Modified time: 2018-10-01 00:39:07 
	Docs: 
		* Write more details here 
]]

local _Stack = require("Src.Core.Class")()

function _Stack:Ctor(MAX_SIZE)
    self.MAX_SIZE = MAX_SIZE or 10
    self.top = 0
    self.stack = {}
end 

function _Stack:Push(e)
    assert(self.top ~= self.MAX_SIZE, "_Stack:Push(e)  stack is full!")
    self.stack[#self.stack + 1] = e
    self.top = self.top + 1
end 

function _Stack:Pop() -- return the element deleted
    assert(self.top ~= 0, "_Stack:Pop()  stack is empty!")
    local e = self.stack[#self.stack]
    self.stack[#self.stack] = nil
    self.top = self.top - 1
    return e
end

function _Stack:IsEmpty()
    return #self.stack == 0
end

function _Stack:GetTopE() -- get top element
    return self.stack[self.top]
end

function _Stack:GetContext()
    return self.stack
end

function _Stack:GetNum()
    return #self.stack
end

return _Stack 
--[[
	Desc: Queue, implemented by array.
	Author: SerDing 
	Since: 2019-08-10 21:04
	Last Modified time: 2018-04-21 03:51:58 
]]

---@class Queue
---@field protected _array table
---@field protected _front int
---@field protected _rear int
local Queue = require("core.class")()

function Queue:Ctor(capacity)
    self._array = { nil, nil, nil, nil, nil, nil, nil, nil} -- make the table capcity
    self._capacity = capacity
    self._front = 1
    self._rear = 1
    self._size = 0
end

function Queue:Enqueue(e)
    assert(not self:IsFull(), "queue is full.")
    self._array[self._rear] = e
    self._rear = self._rear % self._capacity + 1
    self._size = self._size + 1
end

function Queue:Dequeue()
    assert(not self:IsEmpty(), "queue is full.")
    local item = self._array[self._front]
    self._front = self._front % self._capacity + 1
    self._size = self._size - 1
    return item
end

function Queue:Contains(e)
    for i = 1, self._array do
        if self._array[i] == e then
            return true
        end
    end
    return false
end

function Queue:Clear()
    self._array = {}
end

function Queue:IsFull()
    return self._size == self._capacity
end

function Queue:IsEmpty()
    return self._size == 0
end

return Queue
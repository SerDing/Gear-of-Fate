---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lenovo.
--- DateTime: 2021/4/4 16:43
---

---@class Core.List
---@alias T int|number
---@field protected _table table<int, T>
local _List = require("core.class")()

function _List:Ctor()
	self._table = {nil, nil, nil, nil, nil, nil, nil, nil}
	self._count = 0
end

function _List:Add(value)
	self._count = self._count + 1
	self._table[self._count] = value
end

function _List:Remove(value)
	local index = self:IndexOf(value)
	self:RemoveAt(index)
end

function _List:RemoveAt(i)
	table.remove(self._table, i)
	self._count = self._count - 1
end

function _List:IndexOf(value)
	for i = 1, self:Count() do
		if self._table[i] == value then
			return i
		end
	end

	return -1
end

function _List:Insert(i, value)
	table.insert(self._table, i, value)
	self._count = self._count + 1
end

function _List:Get(i)
	if i < 1 or i > self:Count() then
		_LOG.Error("List.Get - index is out of range.")
		return nil;
	end

	return self._table[i]
end

function _List:Contains(value)
	return self:_Contains(self._table, value)
end

function _List:_Contains(tab, value)
	for i = 1, self:Count() do
		if tab[i] == value then
			return true
		end
	end

	return false
end

function _List:Count()
	return self._count
end

function _List:Clear()
	self._table = {}
	self._count = 0
end

---@param action fun(value:T):void
function _List:ForEach(action)
	if action == nil or type(action) ~= "function" then
		_LOG.Error("List.ForEach - illegal action.")
		return false
	end

	for i = 1, self:Count() do
		action(self._table[i])
	end

	return true
end

function _List:Print()
	local content = "List:"
	for i = 1, self._count do
		content = content .. self._table[i] .. " "
	end
	print(content)
end

function _List:Reverse()
	local mid = math.ceil(self._count / 2)
	for i = 1, mid do
		local temp = self._table[i]
		self._table[i] = self._table[self._count - i + 1]
		self._table[self._count - i + 1] = temp
	end
	--linked list Reverse
	--[[
	if start.next then
		local pLast = start
		local pCurrent = start.next
		local pNext = pCurrent.next
		pLast.next = nil
		while true do
			pCurrent.next = pLast
			if not pNext then
				break
			end
			pLast = pCurrent
			pCurrent = pNext
			pNext = pNext.next
		end
	end
	]]
end

---@param compare fun(value:T):boolean
function _List:Sort(compare)
	table.sort(self._table, compare)
end

function _List:ToArray()
	local arrayTable = {}
	for i = 1, self._count do
		arrayTable[i] = self._table[i]
	end
	return arrayTable
end

return _List
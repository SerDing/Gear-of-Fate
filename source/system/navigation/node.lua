--[[
	Desc: Node for a star pathfinding.
	Author: SerDing
	Since: 2018-03-12
	Alter: 2021-04-01
]]

---@class System.Navigation.Node
---@field public from System.Navigation.Node
---@field public passable boolean
---@field public ix int
---@field public iy int
---@field public fCost float
---@field public gCost float
local _Node = require("core.class")()

local _COSTS = {
	X = 10,
	Y = 10,
	XY = 14,
}

function _Node:Ctor(ix, iy, passable)
	self.passable = passable or false
	self.ix = ix or 0 -- x in nav node map
	self.iy = iy or 0 -- y in nav node map
	self.gCost = 0
	self.hCost = 0
	self.fCost = 0
	self.hWeight = 1
	self.from = nil
end

function _Node:CalcFCost()
	self.fCost = self.gCost + self.hCost
end

--- Calculate diagonal distance
---@return number
function _Node:CalcDistanceCost(targetX, targetY)
	local distX = math.abs(self.ix - targetX)
	local distY = math.abs(self.iy - targetY)
	local diagonalStep = math.min(distX, distY)
	local straightStep = math.abs(distX - distY) -- dx + dy - 2 * diagonalStep
	return _COSTS.XY * diagonalStep + _COSTS.Y * straightStep
end

---@param lastNode System.Navigation.Node
function _Node:CalcG(lastNode)
	--local dx = math.abs(self.ix - lastNode.ix)
	--local dy = math.abs(self.iy - lastNode.iy)
	--return _G_COSTS[dy][dx] + lastNode.gCost

	return lastNode.gCost + self:CalcDistanceCost(lastNode.ix, lastNode.iy)
end

function _Node:Reset()
	self.gCost = 0
	self.hCost = 0
	self.fCost = 0
	self.from = nil
end

return _Node 
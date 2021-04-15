--[[
    Desc: Obstacle component, set some nav nodes to no passable by data.
    Author: SerDing
    Since: 2021-03-07
    Alter: 2021-03-22
]]
local _SCENEMGR = require("system.scene.scenemgr")
local _Base = require("entity.component.base")

---@class Entity.Component.Obstacle
local _Obstacle = require("core.class")(_Base)

---@param entity Entity
function _Obstacle:Ctor(entity, data)
	_Base.Ctor(self, entity)
	self._data = data
	self._destructible = data.destructible or false
	self._transform = entity.transform
end

function _Obstacle:Init()
	local nodex, nodey = _SCENEMGR.navigation:GetNodeIndexByPos(self._transform.position.x, self._transform.position.y)

	for iy = nodey + self._data.oy, nodey + self._data.oy + self._data.height do
		for ix = nodex + self._data.ox, nodex + self._data.ox + self._data.width do
			_SCENEMGR.navigation:SetNodePass(ix, iy, false)
		end
	end

	if self._destructible then
		--reg event of death in fighter component, reset nav nodes of self.
	end
end

return _Obstacle
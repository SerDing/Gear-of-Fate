--[[
	Desc: Effect, a component for features of effects.
	Feature:
		1.Death by anim playing end
		2.Lock anim playing rate with master anim playing rate
		3.Follow master position
		4.Death as master state changing
    Author: SerDing
    Since: 2019-11-5
    Alter: 2019-11-5
]]

---@class Entity.Component.Effect : Entity.Component.Base
local _Effect = require("core.class")()

local function _Follow(self)
	local x, y, z = self._entity.identity.master.transform.position:Get()
	if self._followType == "xyz" then
		self._entity.transform.position:Set(x, y, z)
	elseif self._followType == "xy" then
		self._entity.transform.position:Set(x, y)
	end
end

---@param entity Entity
function _Effect:Ctor(entity, data, param)
	self._entity = entity
	self.enable = true
	
	self._lockDirection = data.lockDirection
	self._lockRate = data.lockRate
	self._playEnd = data.playEnd or false
	self._followType = data.followType
	self._state = param.master.state.curState
	-- self:Update(0)
end

function _Effect:Update()
    if not self.enable then
        return
	end
	
	if self._entity.identity.master then
		local master = self._entity.identity.master
		
		if self._lockDirection then
			if self._entity.transform.direction ~= master.transform.direction then
				self._entity.transform.direction = master.transform.direction
			end
		end

		if self._lockRate then
			if self._entity.render.rate ~= master.render.rate then
				self._entity.render.rate = master.render.rate
			end
		end

		if self._playEnd then
			if self._entity.render.renderObj:TickEnd() then
				self._entity.identity:StartDestroy()
			end
		else
			if self._state ~= master.state.curState then
				self._entity.identity:StartDestroy()
			end
		end

		if self._followType then
			_Follow(self)
		end
	end
end

return _Effect
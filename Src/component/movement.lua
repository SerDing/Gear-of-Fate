--[[
    Desc: Movement Component
	Author: SerDing 
	Since: 2018-08-29 
	Alter: 2020-03-13 
]]

local _Event = require("core.event")
local _Vector3 = require("utils.vector3") 

---@class Entity.Component.Movement : Entity.Component.Base
---@field public eventMap table<stirng, Event>
---@field protected g number
---@field protected vz number
---@field public directionZ number
---@field protected fallCondition function
---@field public easeMoveParam table
local _Movement = require("core.class")()

local _SCENE = {}
local _GetDt = love.timer.getDelta
local _stableFPS = 60
local _DIRECTION_Z = {
	UP = 1,
	NONE = 0,
	DOWN = -1,
}

function _Movement:Ctor(entity)
	self._entity = entity
	self.enable = true
	self.position = entity.transform.position
    self.drawPos = entity.drawPos
	self.input = entity.input
	self.eventMap = {
		top = _Event.New(),
		land = _Event.New(),
	}

	self.g = 0
	self.vz = 0
	self.directionZ = _DIRECTION_Z.NONE
	self.fallCondition = nil

	self.easeMoveParam = {
		type = "",
		v = 0,
		a = 0,
		addRate = 0.5,
		dir = 0,
		enable = false,
	}
end 

function _Movement:Update(dt)
	self:_Gravity(dt)
	self:_EasemoveUpdate(dt)
end

function _Movement:SetSceneRef(s)
	assert(s, "scene ref is null.")
	_SCENE = s
end

function _Movement:X_Move(dx)
    dx = dx * _GetDt()
	local _pass, _result
	local _next = self.position.x + dx

	-- if scene_:IsPassable(_next, self.position.y) then -- IsInMoveableArea
	-- 	_result = scene_:IsInObstacles(_next, self.position.y)
	-- 	if _result[1] then
			
	-- 		if dx > 0 then
	-- 			_next = _result[2]:GetVertex()[1].x - 1
	-- 		else
	-- 			_next = _result[2]:GetVertex()[2].x + 1
	-- 		end
	-- 		_pass = false
	-- 	else
	-- 		_pass = true
	-- 	end
	-- else 
	-- 	_next = self.position.x
	-- 	_pass = false
	-- end

	self.position.x = _next
	-- scene_:CheckEvent(self.position.x, self.position.y)
end

function _Movement:Y_Move(offset)
    offset = offset * _GetDt()
	local _result
	local _next = self.position.y + offset

	-- if scene_:IsPassable(self.position.x, _next) then	-- IsInMoveableArea
		
	-- 	_result = scene_:IsInObstacles(self.position.x, _next)
	-- 	if _result[1] then
	-- 		if offset > 0 then
	-- 			_next = _result[2]:GetVertex()[1].y - 1
	-- 		elseif offset < 0 then
	-- 			_next = _result[2]:GetVertex()[2].y + 1
	-- 		end
	-- 	end	
	-- else
	-- 	_next = self.position.y
	-- end

	self.position.y = _next
	-- scene_:CheckEvent(self.position.x, self.position.y)
end

function _Movement:Z_Move(offset)
    offset = offset * _GetDt()
	self.position.z = self.position.z + offset
	-- self.drawPos.z = math.floor(self.pos.z)
end

function _Movement:SetVz(vz)
	self.vz = vz
end 

function _Movement:Set_g(g)
    self.g = g
end 

---@param vz number @ velocity of z axis
---@param g number @ acceleration of gravity
---@param fallCond function @ condition of falling
function _Movement:StartJump(vz, g, fallCond)
	self.vz = vz or 0
	self.g = g or 0
	self.directionZ = _DIRECTION_Z.UP
	self.fallCondition = fallCond
end

function _Movement:_Gravity(dt)
	if self.directionZ == _DIRECTION_Z.UP then
		self.vz = self.vz - dt * self.g * _stableFPS
        if self.vz < 0 then
            self.vz = 0 
		end
		self:Z_Move(-self.vz)
		local fall = (self.vz <= 0) and true or false
		if self.fallCondition then
			fall = self.fallCondition()
		end
        if fall then
			self.directionZ = _DIRECTION_Z.DOWN
			self.eventMap.top:Notify()
		end
    elseif self.directionZ == _DIRECTION_Z.DOWN then
		self.vz = self.vz + dt * self.g * _stableFPS
		if self.position.z < 0 then
			self:Z_Move(self.vz)
		end
		if self.position.z >= 0 then
			self.position.z = 0
			self.directionZ = _DIRECTION_Z.NONE
			self.g = 0
			self.vz = 0
			self.eventMap.land:Notify()
			self.fallCondition = nil
		end
    end  
end 

---@param type string
---@param v int
---@param a int
---@param addRate float
function _Movement:EaseMove(type, v, a, addRate)
	self.easeMoveParam.type = type
	self.easeMoveParam.v = v * self._entity.transform.direction
	self.easeMoveParam.a = a * self._entity.transform.direction
	self.easeMoveParam.addRate = addRate or 0
	self.easeMoveParam.enable = true
	if self.easeMoveParam.a < 0 then
		self.easeMoveParam.dir = -1
	else
		self.easeMoveParam.dir = 1
	end
end

function _Movement:_EasemoveUpdate(dt)
	if self.easeMoveParam.enable == true then
		if self.easeMoveParam.type == "x" then
			self:X_Move(self.easeMoveParam.v)
		elseif self.easeMoveParam.type == "y" then
			self:Y_Move(self.easeMoveParam.v)
		end
		self.easeMoveParam.v = self.easeMoveParam.v + self.easeMoveParam.a * dt

		if self.easeMoveParam.dir == -1 then
			if self.easeMoveParam.v <= 0 then
				self.easeMoveParam.v = 0
				self.easeMoveParam.enable = false
			end
		else
			if self.easeMoveParam.v >= 0 then
				self.easeMoveParam.v = 0
				self.easeMoveParam.enable = false
			end
		end

		if self._entity.transform.direction == -1 then
			if self.input:IsHold("LEFT") then
				self:X_Move(self.easeMoveParam.v * self.easeMoveParam.addRate)
			end
		elseif self._entity.transform.direction == 1 then
			if self.input:IsHold("RIGHT") then
				self:X_Move(self.easeMoveParam.v * self.easeMoveParam.addRate)
			end
		end

	end
end

return _Movement 
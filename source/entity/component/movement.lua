--[[
    Desc: Movement Component
	Author: SerDing 
	Since: 2018-08-29 
	Alter: 2020-03-13 
]]

local _Event = require("core.event")
local _Vector3 = require("utils.vector3") 
local _Base = require("entity.component.base")

---@class Entity.Component.Movement : Entity.Component.Base
---@field public eventMap table<stirng, Event>
---@field protected _g number
---@field protected _vz number
---@field protected _directionZ number
---@field protected _fallCondition function
---@field public _easemoveParam table
local _Movement = require("core.class")(_Base)

local _SCENE = {}
local _GetDt = love.timer.getDelta
local _stableFPS = 60
local _DIRECTION_Z = {
	UP = 1,
	NONE = 0,
	DOWN = -1,
}

function _Movement:Ctor(entity)
	_Base.Ctor(self, entity)
	self._position = entity.transform.position
	self._input = entity.input
	self.eventMap = {
		topped = _Event.New(),
		touchdown = _Event.New(),
	}

	self._dt = 0
	self._g = 0
	self._vz = 0
	self._directionZ = _DIRECTION_Z.NONE
	self._fallCondition = nil

	self._easemoveParam = {
		type = "",
		v = 0,
		a = 0,
		addRate = 0.5,
		dir = 0,
		enable = false,
	}
end 

function _Movement:Update(dt)
	self._dt = dt
	if self._entity.identity.isPaused == false then
		self:EasemoveUpdate(dt)
		self:Gravity(dt)
	end
end

function _Movement:X_Move(dx)
    dx = dx * self._dt--_GetDt()
	local pass, result
	local next = self._position.x + dx

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

	self._position.x = next
	-- scene_:CheckEvent(self.position.x, self.position.y)
end

function _Movement:Y_Move(dy)
    dy = dy * self._dt--_GetDt()
	local result
	local next = self._position.y + dy

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

	self._position.y = next
	-- scene_:CheckEvent(self.position.x, self.position.y)
end

function _Movement:Z_Move(dz)
    dz = dz * self._dt--_GetDt()
	self._position.z = self._position.z + dz
	-- self.drawPos.z = math.floor(self.pos.z)
end

function _Movement:Set_g(g)
    self._g = g
end 

---@param vz number @ velocity of z axis
---@param g number @ acceleration of gravity
---@param fallCond function @ condition of falling
function _Movement:StartJump(vz, g, fallCond)
	vz = vz or 0
	g = g or 0
	self._vz = vz
	self._g = (g == 0) and self._g or g
	self._directionZ = _DIRECTION_Z.UP
	self._fallCondition = fallCond
end

function _Movement:Gravity(dt)
	if self._directionZ == _DIRECTION_Z.UP then
		self._vz = self._vz - dt * self._g * _stableFPS
        if self._vz < 0 then
            self._vz = 0 
		end
		
		self:Z_Move(-self._vz)
		local fall = (self._vz <= 0) and true or false
		if self._fallCondition then
			fall = self._fallCondition()
		end
        if fall then
			self._directionZ = _DIRECTION_Z.DOWN
			self.eventMap.topped:Notify()
		end
    elseif self._directionZ == _DIRECTION_Z.DOWN then
		self._vz = self._vz + dt * self._g * _stableFPS
		if self._position.z < 0 then
			self:Z_Move(self._vz)
		end
		if self._position.z >= 0 then
			self._position.z = 0
			self._directionZ = _DIRECTION_Z.NONE
			self._g = 0
			self._vz = 0
			self.eventMap.touchdown:Notify()
			self._fallCondition = nil
		end
    end  
end 

---@param type string
---@param v int
---@param a int
---@param addRate float
function _Movement:EaseMove(type, v, a, addRate)
	self._easemoveParam.type = type
	self._easemoveParam.v = v --* self._entity.transform.direction
	self._easemoveParam.a = a --* self._entity.transform.direction
	self._easemoveParam.addRate = addRate or 0
	self._easemoveParam.enable = true
	-- if self._easemoveParam.a < 0 then
	-- 	self._easemoveParam.dir = -1
	-- elseif self._easemoveParam.a > 0 then
	-- 	self._easemoveParam.dir = 1
	-- else
	-- 	self._easemoveParam.dir = 0
	-- end
end

function _Movement:EasemoveUpdate(dt)
	if self._easemoveParam.enable == true then
		local entityDirection = self._entity.transform.direction
		if self._easemoveParam.type == "x" then
			self:X_Move(self._easemoveParam.v * entityDirection)
		elseif self._easemoveParam.type == "y" then
			self:Y_Move(self._easemoveParam.v * entityDirection)
		end

		self._easemoveParam.v = self._easemoveParam.v + self._easemoveParam.a * dt
		if self._easemoveParam.a < 0 then
			if self._easemoveParam.v <= 0 then
				self._easemoveParam.v = 0
				self._easemoveParam.enable = false
			end
		elseif self._easemoveParam.a > 0 then
			if self._easemoveParam.v >= 0 then
				self._easemoveParam.v = 0
				self._easemoveParam.enable = false
			end
		end

		if self._entity.transform.direction == -1 then
			if self._input and self._input:IsHold("LEFT") then
				self:X_Move(self._easemoveParam.v * entityDirection * self._easemoveParam.addRate)
			end
		elseif self._entity.transform.direction == 1 then
			if self._input and self._input:IsHold("RIGHT") then
				self:X_Move(self._easemoveParam.v * entityDirection * self._easemoveParam.addRate)
			end
		end

	end
end

function _Movement:DisableEasemove()
	self._easemoveParam.enable = false
end

function _Movement:IsEasemoving()
	return self._easemoveParam.enable
end

function _Movement:IsFalling()
	return self._directionZ == _DIRECTION_Z.DOWN
end

function _Movement:IsRising()
	return self._directionZ == _DIRECTION_Z.UP
end

return _Movement 
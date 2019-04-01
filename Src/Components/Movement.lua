--[[
    Desc: Movement Component
	Author: SerDing 
	Since: 2018-08-29 14:02:13 
	Last Modified time: 2018-08-29 14:02:13 
	Docs: 
		* X_Move()
]]

local _Movement = require("Src.Core.Class")()

local scene_ = {}
local _GetDt = love.timer.getDelta
local _stableFPS = 60
local _DIR_Z_UP = 1
local _DIR_Z_NONE = 0
local _DIR_Z_DOWN = -1

function _Movement:Ctor(entity)
    self.entity = entity or nil
    assert(self.entity, "_MovementComp:Ctor()  entity ref is nil!")
    self.pos = entity:GetPos()
    assert(self.pos, "_MovementComp:Ctor()  position table of entity is nil!")
    self.drawPos = entity:GetDrawPos()
	assert(self.pos, "_MovementComp:Ctor()  drawPos table of entity is nil!")
	self.g = 0
	self.vz = 0
end 

function _Movement:SetSceneRef(s)
	assert(s, "Scene ref is null.")
	scene_ = s
end

function _Movement:X_Move(dx)
    dx = dx * _GetDt()
	local _pass, _result
	local _next = self.pos.x + dx

	if scene_:IsPassable(_next, self.pos.y) then -- IsInMoveableArea
		_result = scene_:IsInObstacles(_next, self.pos.y)
		if _result[1] then
			-- self:Y_Move(dx)
			if dx > 0 then
				_next = _result[2]:GetVertex()[1].x - 1
			else
				_next = _result[2]:GetVertex()[2].x + 1
			end
			-- _next = self.pos.x
			_pass = false
		else
			_pass = true
		end
	else -- next pos is not in moveable area 
		_next = self.pos.x
		_pass = false
	end

	self.pos.x = _next
	self.drawPos.x = math.floor(self.pos.x)
	scene_:CheckEvent(self.pos.x, self.pos.y)
end

function _Movement:Y_Move(offset)
    offset = offset * _GetDt()
	local _result
	local _next = self.pos.y + offset

	if scene_:IsPassable(self.pos.x, _next) then	-- IsInMoveableArea
		
		_result = scene_:IsInObstacles(self.pos.x, _next)
		if _result[1] then
			if offset > 0 then
				_next = _result[2]:GetVertex()[1].y - 1
			elseif offset < 0 then
				_next = _result[2]:GetVertex()[2].y + 1
			end
		end	
	else
		_next = self.pos.y
	end

	self.pos.y = _next
	self.drawPos.y = math.floor(self.pos.y)
	scene_:CheckEvent(self.pos.x, self.pos.y)
end

function _Movement:Z_Move(offset)
    offset = offset * _GetDt()
	self.pos.z = self.pos.z + offset
	self.drawPos.z = math.floor(self.pos.z)
end

function _Movement:SetVz(vz)
	self.vz = vz
end 

function _Movement:Set_g(g)
    self.g = g
end 

function _Movement:StartJump(vz, g)
	self.vz = vz or 0
	self.g = g or 0
	self.dir_z = 1
end

function _Movement:Gravity(topEvent, landEvent, fallCond)
	_dt = _GetDt()
	if self.dir_z == _DIR_Z_UP then
		self.vz = self.vz - _dt * self.g * _stableFPS
        if self.vz < 0 then
            self.vz = 0 
		end
		self:Z_Move(-self.vz)
		local _fall = (self.vz <= 0) and true or false
		if fallCond then
			_fall = fallCond()
		end
        if _fall then
			self.dir_z = -1
			if topEvent then
				topEvent()
			end
		end
    elseif self.dir_z == _DIR_Z_DOWN then
		self.vz = self.vz + _dt * self.g * _stableFPS
		if self.entity:GetZ() < 0 then
			self:Z_Move(self.vz)
		end
		if self.entity:GetZ() >= 0 then
			self.entity:SetZ(0)
			self.dir_z = _DIR_Z_NONE
			self.g = 0
			self.vz = 0
			if landEvent then
				landEvent()
			end
		end
    end  
end 

return _Movement 
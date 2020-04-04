--[[
	Desc: A game camera
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* You can use Move() to serve for story telling
		* Attention! You can't move the camera when it has a locking target
]]

local _GRAPHICS = require("engine.graphics.graphics")
local _Vector2 = require("utils.vector2") 

---@class Camera
local _CAMERA = {}

local _shakeData = {
	time = 2,
	timer = 2,
	x_range = {0,6},
	y_range = {0,6},
}

local _spaceTime = 0
local _spaceTimer = 0.01

function _CAMERA.Ctor()
	_CAMERA._position = _Vector2.New(0, 0)
	_CAMERA._scale = _Vector2.New(1, 1)
	_CAMERA._target = _Vector2.New(0, 0)

	local screenWidth = love.graphics.getWidth()
	local screenHeight = love.graphics.getHeight()
	_CAMERA._world = {x = 0, y = 0, w = 0, h = 0}
	_CAMERA._world.w = width or screenWidth
	_CAMERA._world.h = height or screenHeight
	_CAMERA._viewport = {w = screenWidth, h = screenHeight}
	-- this.scale.x = love.graphics.getWidth() / 800
	-- this.scale.y = love.graphics.getWidth() / 800
	_CAMERA._scale.x = screenWidth / 960 * 1.3
	_CAMERA._scale.y = screenHeight / 540 * 1.3
end 

function _CAMERA.SetWorld(w, h)
	_CAMERA._world.w = w
	_CAMERA._world.h = h
end 

function _CAMERA.LockPos()
	if _CAMERA._target.x ~= 0 and _CAMERA._target.y ~= 0 then -- there is a target need to lock
		
		local rangeLeftX = _CAMERA._viewport.w / 2 / _CAMERA._scale.x
		local rangeRightX = _CAMERA._world.w - _CAMERA._viewport.w / 2 / _CAMERA._scale.x

		if _CAMERA._target.x > rangeLeftX and _CAMERA._target.x < rangeRightX then -- target in midlle area
			_CAMERA._position.x = -_CAMERA._target.x + _CAMERA._viewport.w / 2 / _CAMERA._scale.x
		elseif _CAMERA._target.x <= rangeLeftX then -- target in left area
			_CAMERA._position.x = 0
		elseif _CAMERA._target.x >= rangeRightX then -- target in right area
			_CAMERA._position.x = (- _CAMERA._world.w + _CAMERA._viewport.w / _CAMERA._scale.x) 
		end
	
		local _rangeLeftY = _CAMERA._viewport.h / 2 / _CAMERA._scale.y
		local _rangeRightY = _CAMERA._world.h - _CAMERA._viewport.h / 2 / _CAMERA._scale.y

		if _CAMERA._target.y > _rangeLeftY and _CAMERA._target.y < _rangeRightY then
			_CAMERA._position.y = -_CAMERA._target.y + _CAMERA._viewport.h / 2 / _CAMERA._scale.y
		elseif _CAMERA._target.y <= _rangeLeftY then
			_CAMERA._position.y = 0
		elseif _CAMERA._target.y >= _rangeRightY then
			_CAMERA._position.y = (- _CAMERA._world.h + _CAMERA._viewport.h / _CAMERA._scale.y) 
		end

		-- _CAMERA.pos.y = 0 - (win_h * _CAMERA.scale.y - win_h - 60) / 4

		_CAMERA._position.x = math.floor(_CAMERA._position.x)
		_CAMERA._position.y = math.floor(_CAMERA._position.y)

	end
end

function _CAMERA.ShakingSet()
	
	-- local _percent = 1 - (_shakeData.time / _shakeData.timer)
	
	if _shakeData.time < _shakeData.timer then
		_shakeData.time = _shakeData.time + love.timer.getDelta()
		_spaceTime = _spaceTime + love.timer.getDelta()
		if _spaceTime >= _spaceTimer then
			_spaceTime = 0
			love.graphics.translate(
				math.floor(math.random(_shakeData.x_range[1], _shakeData.x_range[2])), 
				math.floor(math.random(_shakeData.y_range[1], _shakeData.y_range[2]))
			)
		end
	end 
end

---@param drawFunc function
---@param translate boolean @default=true
function _CAMERA.Draw(drawFunc, translate)
	_CAMERA.LockPos()
	_CAMERA.ShakingSet()
	_GRAPHICS.Push()
	_GRAPHICS.Scale(_CAMERA._scale.x, _CAMERA._scale.y)
	_GRAPHICS.Translate(_CAMERA._position.x, _CAMERA._position.y)
	drawFunc(_CAMERA._position.x, _CAMERA._position.y)
	_GRAPHICS.Pop()
end

function _CAMERA.DrawLockCross()
	love.graphics.line(0, love.graphics.getHeight() / 2, love.graphics.getWidth(), love.graphics.getHeight() / 2)
	love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
end

function _CAMERA.LookAt(x,y)
	_CAMERA._target.x = x or 0
	_CAMERA._target.y = y or 0
end

---@param time float
---@param x_min int
---@param x_max int
---@param y_min int
---@param y_max int
function _CAMERA.Shake(time,x_min,x_max,y_min,y_max)
	_shakeData.time = 0
	_shakeData.timer = time
	_shakeData.x_range[1] = x_min
	_shakeData.x_range[2] = x_max
	_shakeData.y_range[1] = y_min
	_shakeData.y_range[2] = y_max
end

function _CAMERA.Move(dx, dy)
	_CAMERA._position.x = _CAMERA._position.x + -dx
	_CAMERA._position.y = _CAMERA._position.y + -dy
end

---@return table
function _CAMERA.GetPos()
	return _CAMERA._position
end

return _CAMERA 

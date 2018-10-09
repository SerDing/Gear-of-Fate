--[[
	Desc: A game camera
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* Hold key "F2" to move camera toward left (when no target)
		* Hold key "F3" to move camera toward right (when no target)
		* You can use _GameCamera.Move() to serve for story telling
		* Attention! You can't move the camera when it has a locking target
]]

local _GameCamera = {}

local _KEYBOADR = require "Src.Core.KeyBoard" 

local _GAMEINI = require "Src.Config.GameConfig" 

local _targetPos = {x = 0, y = 0}

local _shakeData = {
	time = 2,
	timer = 2,
	
	x_range = {0,6},
	y_range = {0,6},
}

local SCENEMGR_ = {} -- NULL POINTER

local _moveOffset = {x = 0, y = 0}

local _spaceTime = 0
local _spaceTimer = 0.01

function _GameCamera.Ctor(scenemgr)
	SCENEMGR_ = scenemgr
	_GameCamera.moveSpd = 1
	_GameCamera.smooth = 10

	_GameCamera.pos = {x = 0, y = 0}
	_GameCamera.scale = {x = 800 / 800, y = 600 / 600}
	-- _GameCamera.scale = {x = 1280 / 800, y = (800 + 70) / 600}
	-- _GameCamera.scale = {x = (655) / 600, y = (655) / 600}

	-- _GameCamera.scale = {x = 960 / 800, y = 960 / 800}
	
	-- _GameCamera.scale = {x = 1280 / 740, y = 1280 / 740}


	-- _GameCamera.scale = {x = 1280 / 800, y = 1280 / 800}

end 

function _GameCamera.Update(dt)

	for n=1,_GameCamera.smooth do
		if _KEYBOADR.Hold("f2") then
			_GameCamera.Move(-_GameCamera.moveSpd,0)
			
		end 
	end 

	for n=1,_GameCamera.smooth do
		if _KEYBOADR.Hold("f3") then
			_GameCamera.Move(_GameCamera.moveSpd,0)
			
		end 
	end 

	if _KEYBOADR.Hold("lalt") then
		_GameCamera.Shake(0.12,-2,2,-2,2)
		
	end 

end 

function _GameCamera.LockPos()

	local win_w = love.graphics.getWidth()
	local win_h = love.graphics.getHeight()
	
	if _targetPos.x ~= 0 and _targetPos.y ~= 0 then -- there is a target need to lock
		
		local _rangeLeftX = win_w / 2 / _GameCamera.scale.x
		local _rangeRightX = SCENEMGR_.curScene:GetWidth() - win_w / 2 / _GameCamera.scale.x

		if _targetPos.x > _rangeLeftX and _targetPos.x < _rangeRightX then -- target in midlle area
			_GameCamera.pos.x = -_targetPos.x + win_w / 2 / _GameCamera.scale.x
		elseif _targetPos.x <= _rangeLeftX then -- target in left area
			_GameCamera.pos.x = 0
		elseif _targetPos.x >= _rangeRightX then -- target in right area
			_GameCamera.pos.x = (- SCENEMGR_.curScene:GetWidth() + win_w / _GameCamera.scale.x) 
		end
	
		local _rangeLeftY = win_h / 2 / _GameCamera.scale.y
		local _rangeRightY = SCENEMGR_.curScene:GetHeight() - win_h / 2 / _GameCamera.scale.y

		if _targetPos.y > _rangeLeftY and _targetPos.y < _rangeRightY then
			_GameCamera.pos.y = -_targetPos.y + win_h / 2 / _GameCamera.scale.y
		elseif _targetPos.y <= _rangeLeftY then
			_GameCamera.pos.y = 0
		elseif _targetPos.y >= _rangeRightY then
			_GameCamera.pos.y = (- SCENEMGR_.curScene:GetHeight() + win_h / _GameCamera.scale.y) 
		end

		-- _GameCamera.pos.y = 0 - (win_h * _GameCamera.scale.y - win_h - 60) / 4

		_GameCamera.pos.x = math.floor(_GameCamera.pos.x)
		_GameCamera.pos.y = math.floor(_GameCamera.pos.y)

	end
end

function _GameCamera.Set()
	_GameCamera.LockPos()
	love.graphics.scale(_GameCamera.scale.x, _GameCamera.scale.y)
	love.graphics.push()
	
	love.graphics.translate(_GameCamera.pos.x,_GameCamera.pos.y)
	_GameCamera.ShakingSet()
end

function _GameCamera.ShakingSet()
	
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

function _GameCamera.Draw(drawFunc)
	_GameCamera.Set()
	drawFunc(_GameCamera.pos.x, _GameCamera.pos.y)
	_GameCamera.UnSet()
end

function _GameCamera.UnSet()
	love.graphics.pop()
	-- love.graphics.scale(1, 1)
end

function _GameCamera.LookAt(x,y)
	_targetPos.x = x or 0
	_targetPos.y = y or 0
end

function _GameCamera.Shake(time,x_min,x_max,y_min,y_max)
	_shakeData.time = 0
	_shakeData.timer = time
	_shakeData.x_range[1] = x_min
	_shakeData.x_range[2] = x_max
	_shakeData.y_range[1] = y_min
	_shakeData.y_range[2] = y_max
end

function _GameCamera.Move(dx, dy)
	_GameCamera.pos.x = _GameCamera.pos.x + -dx
	_GameCamera.pos.y = _GameCamera.pos.y + -dy
end

function _GameCamera.GetPos(x,y)
	return _GameCamera.pos
end


return _GameCamera 
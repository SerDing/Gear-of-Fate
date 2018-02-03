--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* Hold key "F2" to move camera toward left
		* Hold key "F3" to move camera toward right
		* You can use _GameCamera.Move() to serve for story telling
]]

local _GameCamera = {}
local _KEYBOADR = require "Src.Core.KeyBoard" 

local _GAMEINI = require "Src.Config.GameConfig" 

local _shakeData = {
	time = 2,
	timer = 2,
	x_range = {0,6},
	y_range = {0,6},
}

local SCENEMGR_ = {}

local _moveOffset = {x = 0, y = 0}

local _spaceTime = 0
local _spaceTimer = 0.01

function _GameCamera.Ctor(scenemgr)
	SCENEMGR_ = scenemgr
	_GameCamera.moveSpd = 1
	_GameCamera.smooth = 10
end 

function _GameCamera.Update(dt)

	for n=1,_GameCamera.smooth do
		if _KEYBOADR.Hold("f2") then
			_GameCamera.Move(-_GameCamera.moveSpd,0)
			-- print(_moveOffset.x,SCENEMGR_.offset.x ,SCENEMGR_.curScene:GetWidth())
		end 
	end 

	for n=1,_GameCamera.smooth do
		if _KEYBOADR.Hold("f3") then
			_GameCamera.Move(_GameCamera.moveSpd,0)
			-- print(_moveOffset.x,SCENEMGR_.offset.x ,SCENEMGR_.curScene:GetWidth())
		end 
	end 

	if _KEYBOADR.Hold("lalt") then
		_GameCamera.Shake(0.12,-1,1,-2,2)
		-- print(_moveOffset.x,SCENEMGR_.offset.x ,SCENEMGR_.curScene:GetWidth())
	end 


end 

function _GameCamera.Draw(x,y)
----[[  shake effect  ]]
	if _shakeData.time < _shakeData.timer then
		_shakeData.time = _shakeData.time + love.timer.getDelta()
		_spaceTime = _spaceTime + love.timer.getDelta()
		if _spaceTime >= _spaceTimer then
			_spaceTime = 0
			love.graphics.translate(
				math.random(_shakeData.x_range[1],_shakeData.x_range[2]), 
				math.random(_shakeData.y_range[1],_shakeData.y_range[2])
			)
		end
	end 
end

function _GameCamera.Shake(time,x_min,x_max,y_min,y_max)
	_shakeData.time = 0
	_shakeData.timer = time
	_shakeData.x_range[1] = x_min
	_shakeData.x_range[2] = x_max
	_shakeData.y_range[1] = y_min
	_shakeData.y_range[2] = y_max

end

function _GameCamera.Move(spd_x,spd_y)
	
	if spd_x < 0 then
		if _moveOffset.x + spd_x >= SCENEMGR_.offset.x then
			_moveOffset.x = _moveOffset.x + spd_x
		end 
	end 

	if spd_x > 0 then
		if _GAMEINI.winSize.width + _moveOffset.x + spd_x <= SCENEMGR_.offset.x + SCENEMGR_.curScene:GetWidth() then
			_moveOffset.x = _moveOffset.x + spd_x
		end 
	end 
	
	if spd_y > 0 then
		if _moveOffset.y - spd_y >= SCENEMGR_.offset.y then
			_moveOffset.y = _moveOffsset.y - spd_y
		end 
	end 

	if spd_y < 0 then
		if _GAMEINI.winSize.width + _moveOffset.x + spd_y <= SCENEMGR_.offset.x + SCENEMGR_.curScene:GetWidth() then
			_moveOffset.y = _moveOffsset.y + spd_y
		end 
	end 
	
	if spd_x ~= 0 or spd_y ~= 0 then
		SCENEMGR_.SetCameraOffset(_moveOffset.x,_moveOffset.y)
	end 
	
end

return _GameCamera 
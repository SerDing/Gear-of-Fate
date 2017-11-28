--[[
	Desc: Entrace file
 	Author: Night_Walker
	Since: 2017-07-01 01:04:56
	Alter: 2017-07-30 23:46:00
	Docs:
		* Program Entrance
]]

require "Src.Core.TextHandle"
require "Src.Core.FileSystem"
require "Src.Core.System"
local _KEYBOARD = require "Src.Core.KeyBoard"

local _GAMEMGR = require "Src/GameManager"
local _RESMGR = require "Src/ResManager"


_RESMGR.Ctor()
_GAMEMGR.Ctor()

--[[ Key Note:

	* F1 -- Debug 
	* Space -- Frezen Camera (In fact, it has only effect for objects in scene)

]]

local _iterator = 0
local _limit = 10

_gamePause = false

function love.load()

	local bgm = _RESMGR.LoadSound("/Music/characterSelectStage.ogg")
	-- bgm:play()
	bgm:setLooping(true)
end

function love.update(dt)

	if _KEYBOARD.Press("lctrl") then
		_gamePause = true
		print("pause")

	end

	if _KEYBOARD.Press("rctrl") then

		_gamePause = false
		print("continue")
		
	end

	if _gamePause then
		return  
	end 
	

	_GAMEMGR.Update(dt)
	_RESMGR.Update()

	-- if _KEYBOARD.Press("lctrl") then
	-- 	print("lctrl is pressed")
	-- end
	
	-- if _KEYBOARD.Release("lctrl") then
	-- 	print("lctrl is released")
	-- end

	_KEYBOARD.Update()

end

function love.draw()

	_GAMEMGR.Draw()
	
end

function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用
	_KEYBOARD.PressHandle(key)
end

function love.keyreleased(key) --键盘检测回调函数，当键盘事件触发是调用
	_KEYBOARD.ReleaseHandle(key)
end

function love.mousepressed(x,y,key) --回调函数释放鼠标按钮时触发。

end

	
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

local _GAMEMGR = require "Src.Game.GameManager"
local _RESMGR = require "Src/ResManager"




--[[ Key Note:

	* F1 -- Debug 
	* F2 -- Move Camera -10 pixels
	* Space -- Frezen Camera (In fact, it just has effect for objects in scene)
	* left Alt -- Shake Camera
]]

local _iterator = 0
local _limit = 10

_gamePause = false

log = print
math.randomseed(os.time())
love.graphics.setBlendMode("alpha")


function love.load()

	_RESMGR.Ctor()
	_GAMEMGR.Ctor()

	local bgm = _RESMGR.LoadSound("/Music/characterSelectStage.ogg")
	-- bgm:play()
	bgm:setLooping(true)

	shape = love.physics.newRectangleShape(100, 100)
end

function love.update(dt)

	if _KEYBOARD.Press("lctrl") then
		_gamePause = true
		-- print("pause")
	end

	if _KEYBOARD.Press("rctrl") then
		_gamePause = false
		-- print("continue")	
	end
	
	if _gamePause then
		return  
	end 

	
	_GAMEMGR.Update(dt)
	_RESMGR.Update(dt)

	_KEYBOARD.Update(dt)

	-- collectgarbage("step", 200)


end

function love.draw()

	_GAMEMGR.Draw()
	
	local _mousePos = {
        x = love.mouse.getX(),
        y = love.mouse.getY(),
    }
    love.graphics.print(tostring(_mousePos.x) .. "," .. tostring(_mousePos.y), _mousePos.x - 20, _mousePos.y - 10)
	
end

function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用
	_KEYBOARD.PressHandle(key)
end

function love.keyreleased(key) --键盘检测回调函数，当键盘事件触发是调用
	_KEYBOARD.ReleaseHandle(key)
end

function love.mousepressed(x,y,key) --回调函数释放鼠标按钮时触发。

end



	
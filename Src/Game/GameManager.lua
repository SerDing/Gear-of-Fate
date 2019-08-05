--[[
	Desc: A single object to manage core module of the game.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* Game Manager is the Manager of other managers like SceneMgr, ResMgr, ...
]]
require "Src.Core.TextHandle"
require "Src.Core.FileSystem"
local _RESMGR = require "Src.Resource.ResManager"
local _AUDIOMGR = require "Src.Audio.AudioManager"
local _KEYBOARD = require "Src.Core.KeyBoard"
local _InputMgr = require "Src.Engine.Input.InputMgr"
local _GDBOARD = require "Src.Game.GameDataBoard"
local _SCENEMGR = require "Src.Scene.GameSceneMgr" 
local _CAMERA = require "Src.Game.GameCamera"
local _UIMGR = require "Src.GUI.UI_Manager"
local _InitGUI = require "Src.GUI.GUI_Init"
local _ACTORMGR = require "Src.Managers.ActorMgr"

local _GAMEMGR = {
	period = 0, 
	mousePos = {x = 0, y = 0},
	runPath = "",
	debug = false,
}

--[[ Key Note:
	* F1 -- Debug 
	* F2 -- Move Camera -10 pixels
	* Space -- Frezen Camera (In fact, it just has effect for objects in scene)
	* left Alt -- Shake Camera
]]

GDebug = false -- global game debug

local _time = 0
local _memory = 0
local _gamePause = false

log = print

-- love.graphics.setDefaultFilter("linear", "linear") -- nearest

local text = "Data/character/swordman/asd.lua"
-- print("___string test = ", string.match(text, "(.+)/[^/]*%.%w+$"))
print("___string test = ", string.match(text, "(.+)/[^/]*") .. "/")

function _GAMEMGR.Ctor() --initialize
	_RESMGR.Ctor()
	_AUDIOMGR.Init()
	_GDBOARD.Load()
	_ACTORMGR.Ctor()
	_SCENEMGR.Ctor()
	
	_CAMERA.Ctor(_SCENEMGR)
	_InitGUI(_GAMEMGR)

end

function _GAMEMGR.Update(dt)

	if _KEYBOARD.Press("ralt") then
		print("collectgarbage")
		collectgarbage("collect")
	end
	
	if _KEYBOARD.Press("escape") then
		love.event.quit()
	end

	if _gamePause then
		return  
	end 

	_SCENEMGR.Update(dt)
	_KEYBOARD.Update(dt)
end

function _GAMEMGR.Draw(x,y)	
	-- _CAMERA.Draw(_SCENEMGR.Draw)
	_SCENEMGR.Draw()
	_UIMGR.Draw()

	love.graphics.setColor(0 , 255, 0, 255)

	-- FPS draw
	love.graphics.print(strcat("FPS:", tostring(love.timer.getFPS())), (love.graphics.getWidth() / _CAMERA.scale.x - 300 + 10) , 10)
	-- mouse pos draw
	love.graphics.print(strcat(love.mouse.getX(), ",", love.mouse.getY()), (love.mouse.getX() - 20) / _CAMERA.scale.x, (love.mouse.getY() - 10) / _CAMERA.scale.y)
	--love.graphics.setColor(255, 255,255, 255)
end

function _GAMEMGR.KeyPressed(key)
	_KEYBOARD.PressHandle(key)
	_InputMgr.PressHandle(key)
	_UIMGR.KeyPressed(key)

	if key == "rctrl" then
		_gamePause = not _gamePause
	end

	if key == "f1" then
		GDebug = not GDebug
	end
	
end

function _GAMEMGR.KeyReleased(key)
	_KEYBOARD.ReleaseHandle(key)
	_InputMgr.ReleaseHandle(key)
end

function _GAMEMGR.MousePressed(x, y, button, istouch)
	_UIMGR.MousePressed(x, y, button, istouch)
end

function _GAMEMGR.MouseReleased(x, y, button, istouch)
	_UIMGR.MouseReleased(x, y, button, istouch)
end

function _GAMEMGR.MouseMoved(x, y, dx, dy)
	_UIMGR.MouseMoved(x, y, dx, dy)
end

return _GAMEMGR
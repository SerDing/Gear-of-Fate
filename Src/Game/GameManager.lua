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
local _RESMGR = require("Src.Resource.ResManager")
local _AUDIOMGR = require("Src.Audio.AudioManager")
local _KEYBOARD = require("Src.Core.KeyBoard")
local _InputMgr = require("Src.Engine.Input.InputMgr")
local _GDBOARD = require("Src.Game.GameDataBoard")
local _SCENEMGR = require("Src.Scene.GameSceneMgr")
local _CAMERA = require("Src.Game.GameCamera")
local _UIMGR = require("Src.GUI.UI_Manager")
local _ACTORMGR = require("Src.Managers.ActorMgr")
local _Timer = require("Src.Utility.Timer")

-- UI Panels
local _HUD = require("Src.GUI.Panels.HUD")
local _Inventory = require("Src.GUI.Panels.Inventory")

local _GAMEMGR = {} ---@class GAMEMGR
local this = _GAMEMGR ---@type GAMEMGR

--[[ Key Note:
	* F1 -- Debug 
	* F2 -- Move Camera -10 pixels
	* Space -- Frezen Camera (it just has take effect for characters in scene)
	* left Alt -- Shake Camera
]]

GDebug = false -- global game debug

log = print

function _GAMEMGR.Ctor() --initialize

	this.mousePos = {x = 0, y = 0}
	this.debug = false
	this.joystick = nil ---@type Joystick
	this._gamePause = false

	_RESMGR.Ctor()
	_AUDIOMGR.Init()
	_GDBOARD.Load()
	_ACTORMGR.Ctor()
	_SCENEMGR.Ctor()
	_CAMERA.Ctor(_SCENEMGR)

	_UIMGR.Ctor()
    _UIMGR.AddPanel("HUD", _HUD.New(_ACTORMGR.mainPlayer))
    _UIMGR.AddPanel("Inventory", _Inventory.New())

	-- this.testtimer = _Timer.New(1, function() print(this._gamePause) end) ---@type Timer
end

function _GAMEMGR.Update(dt)
	--this.testtimer:Tick(dt)

	if _KEYBOARD.Press("ralt") then
		print("collectgarbage")
		collectgarbage("collect")
	end
	
	if _KEYBOARD.Press("escape") then
		love.event.quit()
	end

	if this._gamePause then
		return  
	end 

	_SCENEMGR.Update(dt)
	_KEYBOARD.Update(dt)


	--print("__ gamepad left stick x:", _GAMEMGR.joystick:getGamepadAxis("leftx"))
	--print("__ gamepad right trigger:", _GAMEMGR.joystick:getGamepadAxis("triggerright"))
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
		this._gamePause = not this._gamePause
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

---@param joystick Joystick
function _GAMEMGR.JoystickAdded(joystick)
	print("____ joystick added:", joystick:getID(), joystick:getName(), joystick:getHatCount())
	_GAMEMGR.joystick = joystick
	
end

function _GAMEMGR.GamePadPressed(joystick, button)
	print("____ gamepad pressed:", button)
end

function _GAMEMGR.GamePadReleased(joystick, button)

end

return _GAMEMGR
--[[
	Desc: A single object to manage core module of the game.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* Game Manager is the entrance of Game World
]]

local _GAMEMGR = {
	period = 0, 
	mousePos = {x = 0, y = 0},
	runPath = "",
	debug = false,
	modules = {},
}

_GAMEMGR.modules = {
	["AniPack"] = "Src.Animation.AniPack",
	["Anima"] = "Src.Animation.Anima",
	["SCENEMGR"] = "Src.Scene.GameSceneMgr",
	["EFFECTMGR"] = "Src.Scene.EffectManager",
	["GameScene"] = "Src.Scene.GameScene",
	["Object"] = "Src.Scene.AniPack",
	["AniPack"] = "Src.Animation.AniPack",
	["AniPack"] = "Src.Animation.AniPack",
	["AniPack"] = "Src.Animation.AniPack",

}

require "Src.Core.TextHandle"
require "Src.Core.FileSystem"
require "Src.Core.System"

local _RESMGR = require "Src.Resource.ResManager"
local _KEYBOARD = require "Src.Core.KeyBoard"
local _INPUTHANDLER = require "Src.Input.InputHandler"
local _GDBOARD = require "Src.Game.GameDataBoard"
local _SCENEMGR = require "Src.Scene.GameSceneMgr" 

local _HUD = love.graphics.newImage("ImagePacks/interface/hud/0.png") 

--[[ Key Note:
	* F1 -- Debug 
	* F2 -- Move Camera -10 pixels
	* Space -- Frezen Camera (In fact, it just has effect for objects in scene)
	* left Alt -- Shake Camera
]]

local _time = 0
local _memory = 0
local _gamePause = false

log = print

function _GAMEMGR.Ctor() --initialize
	_RESMGR.Ctor()
	_GDBOARD.Load()

	_SCENEMGR.Ctor()

	local bgm = _RESMGR.LoadSound("/Music/characterSelectStage.ogg")
	-- bgm:play()
	bgm:setLooping(true)
end

function _GAMEMGR.Update(dt)

	if _KEYBOARD.Press("lctrl") then
		_gamePause = true
	end

	if _KEYBOARD.Press("rctrl") then
		_gamePause = false
	end
	
	if _gamePause then
		return  
	end 

	_SCENEMGR.Update(dt)
	_RESMGR.Update(dt)
	_KEYBOARD.Update(dt)
end

function _GAMEMGR.Draw(x,y)																																																																																																																																																				
	
	_SCENEMGR.Draw()

	love.graphics.draw(_HUD, 0, 600-91)
	
	-- draw a mini panel for debug data
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0, 0, 0, 180)
	love.graphics.rectangle("fill", 0, 0, 300, 50)
	love.graphics.setColor(r, g, b, a)

	-- draw some data to monitor the status of game
	_time = _time + love.timer.getDelta()
	if _time >= 0.016 * 60 then
		_time = 0
		_memory = collectgarbage("count")
	end
	
	love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 10, 10, 0, 1, 1.1)
	love.graphics.print("lua memory:" .. tostring(_memory), 10, 30, 0, 1, 1.1)
	

	local _mousePos = { x = love.mouse.getX(), y = love.mouse.getY() }
    love.graphics.print(tostring(_mousePos.x) .. "," .. tostring(_mousePos.y), _mousePos.x - 20, _mousePos.y - 10)
end

function _GAMEMGR.KeyPressed(key)
	_KEYBOARD.PressHandle(key)
	_INPUTHANDLER.PressHandle(key)
end

function _GAMEMGR.KeyReleased(key)
	_KEYBOARD.ReleaseHandle(key)
	_INPUTHANDLER.ReleaseHandle(key)
end

function _GAMEMGR.MousePressed(x, y, key，istouch)
end

function _GAMEMGR.MousePressed(x, y, key，istouch)
end

return _GAMEMGR
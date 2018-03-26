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

local _SCENEMGR = require "Src.Scene.GameSceneMgr" 

local _HUD = love.graphics.newImage("ImagePacks/interface/hud/0.png") 

local _time = 0
local _memory = 0

function _GAMEMGR.Ctor() --initialize
	_SCENEMGR.Ctor()
end

function _GAMEMGR.Update(dt)
	_SCENEMGR.Update(dt)
end

function _GAMEMGR.Draw(x,y)																																																																																																																																																				
	
	_SCENEMGR.Draw()

	-- love.graphics.draw(_HUD, 0, 600-91)
	
	local r, g, b, a = love.graphics.getColor()
	-- draw a mini panel for debug data
	love.graphics.setColor(0, 0, 0, 180)
	love.graphics.rectangle("fill", 0, 0, 300, 50)
	love.graphics.setColor(r, g, b, a)
	-- draw some data to monitor the status of game
	_time = _time + love.timer.getDelta()
	
	if _time >= 0.016 * 60 then
		_time = 0
		_memory = collectgarbage("count")
	end
	love.graphics.print("FPS:" .. tostring(love.timer.getFPS()), 10, 10, 0, 1, 1)
	love.graphics.print("lua memory:" .. tostring(_memory), 10, 20, 0, 1, 1)
	
end

return _GAMEMGR
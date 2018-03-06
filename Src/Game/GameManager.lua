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

function _GAMEMGR.Ctor() --initialize
	_SCENEMGR.Ctor()
	
end

function _GAMEMGR.Update(dt)
	_SCENEMGR.Update(dt)
end

function _GAMEMGR.Draw(x,y)																																																																																																																																																				
	
	_SCENEMGR.Draw()

	-- love.graphics.draw(_HUD, 0, 600-91)
	
end

return _GAMEMGR
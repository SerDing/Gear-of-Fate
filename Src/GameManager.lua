--[[
	Desc: A single object to manage core module of the game.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* The class contain many game core data
]]

local _GAMEMGR = {

	period = 0, 
	mousePos = {x = 0 , y = 0 },
	runPath = "",
	debug = false,

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
	love.graphics.draw(_HUD, 0, 600-90)
end

return _GAMEMGR
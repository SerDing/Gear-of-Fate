--[[
	Desc: A singleton to manage core modules of the game.
		* F1 -- Debug 
		* Space -- Freeze GameWorld for a while
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2019-10-24 23:28:48
]]
local _INPUT = require("engine.input.init")
local _AUDIO = require("engine.audio")
local _GRAPHICS = require("engine.graphics.graphics")
local _SCENEMGR = require("scene.levelmgr")
local _CAMERA = require("scene.camera")
local _FACTORY = require("system.entityfactory")
local _ENTITYMGR = require("system.entitymgr")
local _UIMGR = require("system.gui.uimgr")

---@class GAME
local _GAME = {
	_pause = false
}

gDebug = false -- global game debug
-- love.graphics.setFont(love.graphics.newFont("Font/simsun.ttc", 14))
function _GAME.Ctor() --initialize
	_AUDIO.Init()
	_INPUT.Register(_GAME)
	local player = _FACTORY.NewEntity("character/swordman", {
		x = 400, 
		y = 460, 
		direction = 1, 
		camp = 1, 
		firstState = "stay"
	})
	player.skills.debug = true
	_FACTORY.mainPlayer = player
	_ENTITYMGR.player = player
	
	_SCENEMGR.Ctor()
	_CAMERA.Ctor()
	_CAMERA.SetWorld(_SCENEMGR.curScene:GetWidth(), _SCENEMGR.curScene:GetHeight())
	_UIMGR.Ctor({
		hud = "panels.hud",
		inventory = "panels.inventory",
	})

	-- set callbacks
	love.mousepressed = _GAME.MousePressed
	love.mousereleased = _GAME.MouseReleased
	love.mousemoved = _GAME.MouseMoved
end

function _GAME.Update(dt)
	if _GAME._pause then
		return 
	end

	_SCENEMGR.Update(dt)
	_CAMERA.LookAt(_FACTORY.mainPlayer.transform.position.x, _FACTORY.mainPlayer.transform.position.y - 50)
	_INPUT.Update(dt)
end

function _GAME.Draw()
	_CAMERA.Draw(_SCENEMGR.Draw, true)
	_UIMGR.Draw()
	--_CAMERA.DrawLockCross()
	
	_GRAPHICS.Print("FPS:" .. love.timer.getFPS(), math.floor(_GRAPHICS.GetWidth() / _CAMERA._scale.x + 10), 10)
	_GRAPHICS.Print(love.mouse.getX() .. "," .. love.mouse.getY(), (love.mouse.getX() - 20), (love.mouse.getY() - 10))
end

function _GAME.Press(_, action)
	if action == "DEBUG" then
		gDebug = not gDebug
	end
	if action == "PAUSE" then
		_GAME._pause = not _GAME._pause
	end 
	if action == "FREEZE" then
		_SCENEMGR.curScene.limit = 20
		print("Freeze game world for a while.")
	end
	-- if action == "MENU" then
	-- 	love.event.quit()
	-- end

	_UIMGR.KeyPressed(action)
end

function _GAME.Release(_, action)
end

function _GAME.MousePressed(x, y, button, istouch)
	_UIMGR.MousePressed(x, y, button, istouch)
end

function _GAME.MouseReleased(x, y, button, istouch)
	_UIMGR.MouseReleased(x, y, button, istouch)
end

function _GAME.MouseMoved(x, y, dx, dy)
	_UIMGR.MouseMoved(x, y, dx, dy)
end

return _GAME
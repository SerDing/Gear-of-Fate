--[[
	Desc: A singleton to manage game flow.
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2019-10-24 23:28:48
	* F1 -- Debug 
	* Space -- Freeze GameWorld for a while
]]
local _AUDIO = require("engine.audio")
local _GRAPHICS = require("engine.graphics.graphics")
local _INPUT = require("engine.input.init")
local _LEVELMGR = require("scene.levelmgr")
local _CAMERA = require("scene.camera")
local _FACTORY = require("system.entityfactory")
local _ENTITYMGR = require("system.entitymgr")
local _PLAYERMGR = require("system.playermgr")
local _UIMGR = require("system.gui.uimgr")
local _Timer = require("utils.timer")
local _SETTING = require("setting")

---@class Game
local _GAME = {
	_rate = 1.0,
	_timer = _Timer.New(),
	_pause = false,
}
function _GAME.Ctor()
	_INPUT.Register(_GAME)
	local param = {
		x = 400, 
		y = 460, 
		direction = 1, 
		camp = 1, 
		firstState = "stay"
	}
	local player = _FACTORY.NewEntity("character/swordman", param)
	-- player.skills.debug = true
	_PLAYERMGR.SetMainPlayer(player)

	param.x = param.x + 100
	param.camp = 3
	local player2 = _FACTORY.NewEntity("character/swordman", param)
	-- _PLAYERMGR.SetMainPlayer(player2)

	_LEVELMGR.Ctor()
	_CAMERA.Ctor()
	_CAMERA.SetWorld(_LEVELMGR.curLevel:GetWidth(), _LEVELMGR.curLevel:GetHeight())
	_UIMGR.Init({
		hud = "panels.hud",
		inventory = "panels.inventory",
	})

	love.mousepressed = _GAME.MousePressed
	love.mousereleased = _GAME.MouseReleased
	love.mousemoved = _GAME.MouseMoved
end

function _GAME.Update(dt)
	if _GAME._pause then
		return 
	end

	if _GAME._rate < 1.0 then
		_GAME._timer:Tick(dt)
		if _GAME._timer.isRunning == false then
			_GAME._rate = 1.0
		end
	end

	_ENTITYMGR.Update(dt * _GAME._rate)
	-- _SCENEMGR.Update(dt)
	_CAMERA.LookAt(_PLAYERMGR._mainPlayer.transform.position.x, _PLAYERMGR._mainPlayer.transform.position.y - 50)
	_INPUT.Update(dt)
end

function _GAME.Draw()
	_CAMERA.Draw(_LEVELMGR.Draw, true)
	_CAMERA.Draw(_ENTITYMGR.Draw, true) -- move into LEVEL.Draw()
	_UIMGR.Draw()
	--GameCurtain.Draw()
	--_CAMERA.DrawLockCross()
	
	if _SETTING.debug.fps then
		_GRAPHICS.Print("FPS:" .. love.timer.getFPS(), math.floor(_GRAPHICS.GetWidth() / _CAMERA._scale.x + 10), 10)
	end

	if _SETTING.debug.mouse then
		_GRAPHICS.Print(love.mouse.getX() .. "," .. love.mouse.getY(), (love.mouse.getX() - 20), (love.mouse.getY() - 10))
	end
end

function _GAME.SetRate(rate, time)
	_GAME._rate = rate
	_GAME._timer:Start(time)
end

function _GAME.Quit()
	love.event.quit()
end

function _GAME.OnPress(_, button)
	if button == "PAUSE" then
		_GAME._pause = not _GAME._pause
	end 

	if button == "FREEZE" then
		_GAME.SetRate(0.05, 3000)
		print("Freeze game world for a while.")
	end
	
	if button == "REBORN_ALL" then
		local list = _ENTITYMGR.GetEntityList()
		for i=1,#list do
			local e = list[i]
			if e.identity.type == "character" and e.fighter.isDead then
				e.fighter:Reborn()
			end
		end
	end
	
	if button == "QUIT" then
		_GAME.Quit()
	end

	_UIMGR.KeyPressed(button)
end

function _GAME.OnRelease(_, action)
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
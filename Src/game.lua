--[[
	Desc: A singleton to manage game flow.
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2019-10-24 23:28:48
	Docs:
		* Space -- Freeze GameWorld for a while
]]
local _GRAPHICS = require("engine.graphics.graphics")
local _MOUSE = require("engine.mouse")
local _INPUT = require("engine.input")
local _SCENEMGR = require("system.scene.scenemgr")
local _CAMERA = require("system.scene.camera")
local _FACTORY = require("system.entityfactory")
local _ENTITYMGR = require("system.entitymgr")
local _PLAYERMGR = require("system.playermgr")
local _UIMGR = require("system.gui.uimgr")
local _SETTING = require("setting")
local _Timer = require("utils.timer")

---@class Game
local _GAME = {
	_timeScale = 1.0,
	_timer = _Timer.New(),
	_running = true,
}

function _GAME.Init()
	_INPUT.Register(_GAME)
	_INPUT.Register(_UIMGR)
	local param = {
		x = 400, 
		y = 460, 
		direction = 1, 
		camp = 1, 
		firstState = "stay"
	}
	local player = _FACTORY.NewEntity("character/swordman", param)
	player.skills.debug = true

	_PLAYERMGR.SetLocalPlayer(player)
	_SCENEMGR.Init(_ENTITYMGR.Draw)
	_SCENEMGR.Load("lorien/proto")
	_UIMGR.Init({
		hud = "system.gui.panels.hud",
		inventory = "system.gui.panels.inventory",
	}, 'hud')
end

function _GAME.Update(dt)
	if not _GAME._running then
		return 
	end
	print(dt)
	if _GAME._timeScale < 1.0 then
		_GAME._timer:Tick(dt)
		if _GAME._timer.isRunning == false then
			_GAME._timeScale = 1.0
		end
	end

	_ENTITYMGR.Update(dt * _GAME._timeScale)
	_SCENEMGR.Update(dt)
end

function _GAME.Draw()
	_SCENEMGR.Draw()
	_UIMGR.Draw()
	_GAME._DebugDraw()
	--TODO:GameCurtain.Draw()
end

function _GAME.SetTimeScale(timeScale, time)
	_GAME._timeScale = timeScale
	_GAME._timer:Start(time)
end

function _GAME.Quit()
	love.event.quit()
end

function _GAME._DebugDraw()
	local Floor = math.floor
	local h = Floor(_GRAPHICS.GetHeight() * 0.3)
	local y = _GRAPHICS.GetHeight() - h
	_GRAPHICS.SetColor(0, 0, 0, 150)
	_GRAPHICS.DrawRect("fill", 0, y, _GRAPHICS.GetWidth(), h)
	_GRAPHICS.SetColor(255, 255, 255, 255)
	local fps = love.timer.getFPS()
	local startx, starty = 30, y + 30
	local hd, vd = 200, 20 + 10
	if _SETTING.debug.fps then
		_GRAPHICS.Print("FPS:", startx, starty)
		_GRAPHICS.Print(fps, startx + hd, starty)
	end

	if _SETTING.debug.mouse then
		local rawx, rawy = _MOUSE.GetRawPosition()
		--local drawx, drawy = Floor((rawx - 20)), Floor((rawy - 10))
		local worldx, worldy = _CAMERA.ScreenToWorld(rawx, rawy)
		worldx, worldy = Floor(worldx), Floor(worldy)
		_GRAPHICS.Print("mouse raw pos:", startx, starty + vd)
		_GRAPHICS.Print(Floor(rawx) .. "," .. Floor(rawy), startx + hd, starty + vd)
		_GRAPHICS.Print("mouse world pos:", startx, starty + vd * 2)
		_GRAPHICS.Print(worldx .. "|" .. worldy, startx + hd, starty + vd * 2)
	end

	if _SETTING.debug.playerPosition then
		local px, py = _PLAYERMGR.GetLocalPlayer().transform.position:Get()
		_GRAPHICS.Print("player pos:", startx, starty + vd * 3)
		_GRAPHICS.Print(Floor(px) .. "," .. Floor(py), startx + hd, starty + vd * 3)
	end
end

function _GAME.OnPress(_, button)
	if _SETTING.release then
		return
	end

	if button == "PAUSE" then
		_GAME._running = not _GAME._running
	end 

	if button == "FREEZE" then
		_GAME.SetTimeScale(0.05, 3000)
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
end

function _GAME.OnRelease(_, button)
end

return _GAME
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
local _LEVELMGR = require("scene.levelmgr")
local _CAMERA = require("scene.camera")
local _FACTORY = require("system.entityfactory")
local _ENTITYMGR = require("system.entitymgr")
local _UIMGR = require("system.gui.uimgr")

local _Timer = require("utils.timer")
local _Rect = require("engine.graphics.drawable.rect")
local _Box = require("entity.drawable.box")
local _Color = require("engine.graphics.config.color")

---@class GAME
local _GAME = {
	_rate = 1.0,
	_timer = _Timer.New(),
	_pause = false,
}

gDebug = false -- global game debug
-- love.graphics.setFont(love.graphics.newFont("Font/simsun.ttc", 14))
function _GAME.Ctor() --initialize
	_AUDIO.Init()
	_INPUT.Register(_GAME)
	local param = {
		x = 400, 
		y = 460, 
		direction = 1, 
		camp = 1, 
		firstState = "stay"
	}
	local player = _FACTORY.NewEntity("character/swordman", param)
	player.skills.debug = true
	_ENTITYMGR.player = player

	param.x = param.x + 100
	param.camp = 3
	local player2 = _FACTORY.NewEntity("character/swordman", param)
	player2.input:SetAIControl(false)
	-- _INPUT.UnRegister(player2.input)
	
	_LEVELMGR.Ctor()
	_CAMERA.Ctor()
	_CAMERA.SetWorld(_LEVELMGR.curLevel:GetWidth(), _LEVELMGR.curLevel:GetHeight())
	_UIMGR.Init({
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

	if _GAME._rate < 1.0 then
		_GAME._timer:Tick(dt)
		if _GAME._timer.isRunning == false then
			_GAME._rate = 1.0
		end
	end

	_ENTITYMGR.Update(dt * _GAME._rate)
	-- _SCENEMGR.Update(dt)
	_CAMERA.LookAt(_ENTITYMGR.player.transform.position.x, _ENTITYMGR.player.transform.position.y - 50)
	_INPUT.Update(dt)
end

function _GAME.Draw()
	_CAMERA.Draw(_LEVELMGR.Draw, true)
	_CAMERA.Draw(_ENTITYMGR.Draw, true) -- move into LEVEL.Draw()
	_UIMGR.Draw()
	--GameCurtain.Draw()
	--_CAMERA.DrawLockCross()
	
	_GRAPHICS.Print("FPS:" .. love.timer.getFPS(), math.floor(_GRAPHICS.GetWidth() / _CAMERA._scale.x + 10), 10)
	_GRAPHICS.Print(love.mouse.getX() .. "," .. love.mouse.getY(), (love.mouse.getX() - 20), (love.mouse.getY() - 10))
end

function _GAME.SetRate(rate, time)
	_GAME._rate = rate
	_GAME._timer:Start(time)
end

function _GAME.Press(_, action)
	if action == "DEBUG" then
		gDebug = not gDebug
	end
	if action == "PAUSE" then
		_GAME._pause = not _GAME._pause
	end 
	if action == "FREEZE" then
		-- _SCENEMGR.curScene.limit = 20
		_GAME.SetRate(0.05, 3000)
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
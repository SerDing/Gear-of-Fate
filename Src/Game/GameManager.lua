--[[
	Desc: A single object to manage core module of the game.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* Game Manager is the Manager of other managers like SceneMgr, ResMgr, ...
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
local _AUDIOMGR = require "Src.Audio.AudioManager"
local _KEYBOARD = require "Src.Core.KeyBoard"
local _INPUTHANDLER = require "Src.Input.InputHandler"
local _GDBOARD = require "Src.Game.GameDataBoard"
local _SCENEMGR = require "Src.Scene.GameSceneMgr" 
local _CAMERA = require "Src.Game.GameCamera"
local _UIMGR = require "Src.GUI.UI_Manager"
local _InitGUI = require "Src.GUI.GUI_Init"
local _HotKeyMgr = require "Src.Input.HotKeyMgr"

local _ACTORMGR = require "Src.Actor.ActorMgr"


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

local _sourceDir = love.filesystem.getSourceBaseDirectory()
local _success = love.filesystem.mount(_sourceDir, "ImagePacks")
print("mount result = ", _success, "_sourceDir = ", _sourceDir)
print("love.filesystem.isFused() = ", love.filesystem.isFused())


love.graphics.setDefaultFilter( "linear","linear" ) -- nearest

-- local mri = require("Src.Lib.MemoryCheck.MemoryReferenceInfo")

-- collectgarbage("collect")
-- mri.m_cMethods.DumpMemorySnapshot("./", "1-Before", -1)

function _GAMEMGR.Ctor() --initialize
	_RESMGR.Ctor()
	_AUDIOMGR.Init()
	_GDBOARD.Load()
	_ACTORMGR.Ctor()
	_SCENEMGR.Ctor()
	
	_CAMERA.Ctor(_SCENEMGR)
	_HotKeyMgr.Ctor(_ACTORMGR.mainPlayer:GetProperty('job'))
	_InitGUI(_GAMEMGR)



	-- collectgarbage("stop")

	-- _RESMGR.LoadTexture("/ImagePacks/1.png")

	-- local bgm = _RESMGR.LoadSound("/Music/character_stage.ogg")
	-- bgm:play()
	-- bgm:setLooping(true)
	-- love.graphics.setDefaultFilter( 'nearest', 'nearest' )

	--[[ skillId filePath
		8	`Swordman/TripleSlash.skl`
		16	`Swordman/AshenFork.skl`
		40	`Swordman/Reckless.skl`
		46	`Swordman/UpperSlash.skl`
		58	`Swordman/VaneSlash.skl`
		64	`Swordman/GoreCross.skl`
		65	`Swordman/HopSmash.skl`
		76	`Swordman/Frenzy.skl`
		77	`Swordman/MoonlightSlash.skl`
		169	`Swordman/BackStep.skl`
	]]
	
	-- _SkillMgr = _SCENEMGR.GetHero_():GetComponent('SkillMgr')
	-- _SkillMgr:LearnSkills({8, 16, 46, 64, 65, 76, 77, 169})
	local save_abskeys = {
		[46] = "SKL_Q", -- UpperSlash
		[16] = "SKL_R", -- Ashenfork
		[65] = "SKL_A",	-- HopSmash
		[64] = "SKL_S",	-- GoreCross
		[8] = "SKL_F",	-- TripleSlash
		[76] = "SKL_H",	-- Frenzy
		[77] = "SKL_E",	-- MoonLightSlash
	}
	_HotKeyMgr.InitSklAbsKey(save_abskeys)

end

function _GAMEMGR.Update(dt)

	if _KEYBOARD.Press("ralt") then
		print("collectgarbage")
		collectgarbage("collect")
	end
	
	if _KEYBOARD.Press("escape") then
		love.event.quit()
	end

	
	-- if _KEYBOARD.Press("tab") then
	-- 	collectgarbage("collect")
	-- 	mri.m_cMethods.DumpMemorySnapshot("./", "2-After", -1)
	-- end
	if _gamePause then
		return  
	end 

	_SCENEMGR.Update(dt)
	_CAMERA.Update(dt)
	_CAMERA.LookAt(_ACTORMGR.mainPlayer.pos.x, _ACTORMGR.mainPlayer.pos.y)
	-- _RESMGR.Update(dt)
	_KEYBOARD.Update(dt)
end

function _GAMEMGR.Draw(x,y)	

	_CAMERA.Draw(_SCENEMGR.Draw)

	_UIMGR.Draw()

	-- _SCENEMGR.Draw()

	-- love.graphics.draw(_HUD, (love.graphics.getWidth() - 800) / 2, love.graphics.getHeight() - 91) -- 91
	
	-- // debug panel draw
	-- local r, g, b, a = love.graphics.getColor()
	-- love.graphics.setColor(0, 0, 0, 180)
	-- love.graphics.rectangle("fill", love.graphics.getWidth() / _CAMERA.scale.x - 300, 0, 300, 50)
	-- love.graphics.setColor(r, g, b, a)

	-- // memory draw
	-- _time = _time + love.timer.getDelta()
	-- if _time >= 0.016 * 150 then
	-- 	_time = 0
	-- 	_memory = collectgarbage("count")
	-- end
	-- love.graphics.print(strcat("lua memory:", tostring(_memory)), 10, 30)
	-- love.graphics.print(love.timer.getDelta(), 10, 50, 0, 1, 1.1) -- Dt Draw
	
	-- // FPS draw
	love.graphics.print(strcat("FPS:", tostring(love.timer.getFPS())), (love.graphics.getWidth() / _CAMERA.scale.x - 300 + 10) , 10)
	
	-- // mouse pos draw
	-- local _mousePos = {x = love.mouse.getX(), y = love.mouse.getY()}
	-- love.graphics.print(strcat(tostring(_mousePos.x), ",", tostring(_mousePos.y)), (_mousePos.x - 20) / _CAMERA.scale.x, (_mousePos.y - 10) / _CAMERA.scale.y)
	
	-- _UIMGR:Draw()

	-- local r, g, b, a = love.graphics.getColor()
	-- love.graphics.setColor(0, 0, 0, 255)
	-- love.graphics.print("剑神", 100, 200, 0, 1.6, 1.6)
	-- love.graphics.setColor(r, g, b, a)
	-- love.graphics.print("剑神", 100, 200, 0, 1.5, 1.5)

end

function _GAMEMGR.KeyPressed(key)
	_KEYBOARD.PressHandle(key)
	_INPUTHANDLER.PressHandle(key)

	_UIMGR.KeyPressed(key)

	if _KEYBOARD.Press("rctrl") then
		_gamePause = not _gamePause
	end
	
end

function _GAMEMGR.KeyReleased(key)
	_KEYBOARD.ReleaseHandle(key)
	_INPUTHANDLER.ReleaseHandle(key)
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
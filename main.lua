love.filesystem.setRequirePath("source/?.lua;source/?/init.lua")

local _RESOURCE = require("engine.resource")
local _GRAPHICS = require("engine.graphics.graphics")
local _AUDIO = require("engine.audio")
local _MOUSE = require("engine.mouse")
local _INPUT = require("engine.input")
local _TIME = require("engine.time")
local _SETTING = require("setting")

local _GAME = require "game"

function love.load()
	math.randomseed(tostring(os.time()):reverse():sub(1, 7))

	--_GRAPHICS.SetWindowMode(_SETTING.window.w, _SETTING.window.h)
	_GAME.Init()
end

function love.update(dt)
	dt = _TIME.Update(dt)
	_GAME.Update(dt)
	_INPUT.Update(dt)
end

function love.draw()
	_GAME.Draw()
end

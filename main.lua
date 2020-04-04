love.filesystem.setRequirePath("Src/?.lua;Src/?/init.lua")
local _GAME = require "game"

function love.load()
	_GAME.Ctor()
end

function love.update(dt)
	_GAME.Update(dt)
end

function love.draw()
	_GAME.Draw()
end


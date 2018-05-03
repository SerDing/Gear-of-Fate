--[[
	Desc: Entrace file
 	Author: Night_Walker
	Since: 2017-07-01 01:04:56
	Alter: 2017-07-30 23:46:00
	Docs:
		* Program Entrance
]]

local _GAMEMGR = require "Src.Game.GameManager"

function love.load()
	_GAMEMGR.Ctor()
end

function love.update(dt)
	_GAMEMGR.Update(dt)
end

function love.draw()
	_GAMEMGR.Draw()
end

function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用
	_GAMEMGR.KeyPressed(key)
end

function love.keyreleased(key) --键盘检测回调函数，当键盘事件触发是调用
	_GAMEMGR.KeyReleased(key)
end

function love.mousepressed(x,y,key, istouch) --回调函数释放鼠标按钮时触发。
	_GAMEMGR.MousePressed(key)
end

function love.mousereleased(x,y,key, istouch) --回调函数释放鼠标按钮时触发。
	_GAMEMGR.MousePressed(key)
end

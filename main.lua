--[[
	Desc: Entrace file
 	Author: Night_Walker
	Since: 2017-07-01 01:04:56
	Alter: 2017-07-30 23:46:00
	Docs:
		* Program Entrance
]]

require "Src/CommonFunction"

local _GAMEMGR = require "Src/GameManager"
local _RESMGR = require "Src/ResManager"

local backGround = love.graphics.newImage("/Dat/backgroundpic.png")

function love.load()

	local bgm = _RESMGR.LoadSound("/Music/characterSelectStage.ogg")
	bgm:play()
	bgm:setLooping(true)
end

function love.update(dt)

	_GAMEMGR.Update(dt)
	_RESMGR.Update()
	
end

function love.draw()

	love.graphics.draw(backGround, 0, 0)
	love.graphics.line(0, 300, 800, 300) -- 横线
	love.graphics.line(400, 0, 400, 600) -- 竖线

	_GAMEMGR.Draw()

end

function love.keypressed(key) --键盘检测回调函数，当键盘事件触发是调用
	local _hero = _GAMEMGR.GetHero()
	_hero:InputPress(key)
end

function love.keyreleased(key) --键盘检测回调函数，当键盘事件触发是调用
	local _hero = _GAMEMGR.GetHero()
	_hero:InputRelease(key)
end

function love.mousepressed(x,y,key) --回调函数释放鼠标按钮时触发。

end

	
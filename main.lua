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

function love.mousepressed(x, y, key, istouch) --回调函数释放鼠标按钮时触发。
	_GAMEMGR.MousePressed(x, y, key, istouch)
end

function love.mousereleased(x, y, key, istouch) --回调函数释放鼠标按钮时触发。
	_GAMEMGR.MouseReleased(x, y, key, istouch)
end

function love.mousemoved(x, y, dx, dy)
	_GAMEMGR.MouseMoved(x, y, key, istouch)
end

function love.run()
 
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
 
		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(1 / (1000)) end -- 0.001  --> 1000 FPS limit
	end
 
end
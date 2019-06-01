-- love2d framework initialization 

function love.conf(t)
	io.stdout:setvbuf("no")
	t.window.width = 800                -- The window width (number)
	t.window.height = 600               -- The window height (number)
	-- t.window.width = 960                -- The window width (number)
	-- t.window.height = 540               -- The window height (number)
	-- t.window.width = 896                -- The window width (number)
	-- t.window.height = 560               -- The window height (number)

	-- t.window.width = 1280                -- The window width (number)
	-- t.window.height = 720               -- The window height (number)
	
	-- t.window.height = 960               -- The window height (number)

	t.window.title = "Gear Of Fate (Ver:Beta)"
	-- t.window.msaa = 12 -- 超过8才有效
	
	-- t.window.vsync = false

	-- t.console = true
	-- t.window.fullscreen = true
	t.window.fullscreentype = "exclusive"
	t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
end

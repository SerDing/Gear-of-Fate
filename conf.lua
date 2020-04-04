
function love.conf(t)
	io.stdout:setvbuf("no")
	-- t.window.width = 800                -- The window width (number)
	-- t.window.height = 600               -- The window height (number)
	-- t.window.width = 960                -- The window width (number)
	-- t.window.height = 540               -- The window height (number)
	t.window.width = 1280                -- The window width (number)
	t.window.height = 720               -- The window height (number)
	t.window.title = "Gear Of Fate (Ver:Alpha)"
	-- t.console = true
	-- t.window.vsync = false
	t.window.msaa = 8
	-- t.window.fullscreen = true
	-- t.window.fullscreentype = "exclusive"
end

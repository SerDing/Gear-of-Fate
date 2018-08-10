--[[ 引擎配置,初始化 --]]

function love.conf(t)
	io.stdout:setvbuf("no")
	t.window.width = 960                -- The window width (number)
	t.window.height = 600 -- - 40               -- The window height (number)
	-- t.window.width = 1280                -- The window width (number)
    -- t.window.height = 855 -- - 40               -- The window height (number)
	t.window.title = "Gear Of Fate (Ver:Beta)"
	-- t.window.msaa = 16 -- 超过8才有效s
	-- t.window.vsync = false
	-- t.console = true
	-- t.window.fullscreen = true
    t.window.fullscreentype = "exclusive"
end

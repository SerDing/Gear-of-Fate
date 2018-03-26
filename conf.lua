--[[ 引擎配置,初始化 --]]

function love.conf(t)
	io.stdout:setvbuf("no")
	t.window.title = "Gear Of Fate 1.0"
	t.window.msaa = 0
	-- t.window.vsync = true
	-- print(t.window.msaa)
end

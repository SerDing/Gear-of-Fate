--[[
	Desc: An class to load config file
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-16 23:45:02
	Docs:
		*Write notes here even more
]]

ConfigData = require("Src.Class")()

function ConfigData:init(path) --initialize

	DataTable = require (path)

end


function ConfigData:readCase(__case,) --读取数据表中的分支数据

end


function ConfigData:draw()

end

return ConfigData
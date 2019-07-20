--[[
	Desc: methods to operate files
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

function LoadFile(Path) -- 打开指定文件，读取并返回全部内容。
	local file = love.filesystem.newFile(Path, "r")
	local TmpContent = file:read()
	file:close()
	return TmpContent
end
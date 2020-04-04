--[[
	Desc: File system of engine
 	Author: SerDing
	Since: 2017-07-28
	Alter: 2020-01-19
]]

---@class Engine.FileSystem
local _FileSystem = {
	Exist = love.filesystem.exists,
}

--- open a file, read and return all content.
---@param path string
---@return string
function _FileSystem.LoadFile(path)
	local file = love.filesystem.newFile(path, "r")
	local content = file:read()
	file:close()
	return content
end



return _FileSystem
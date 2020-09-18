--[[
	Desc: String lib
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2019-10-24 23:28:48
]]
---@class Engine.String
local _STRING = {}

--- @param str string 
--- @param delimiter string 
--- @return table 
function _STRING.split(str, delimiter)
	if str then
		local result = {}
		str = str..delimiter
		delimiter = "(.-)"..delimiter
		for match in str:gmatch(delimiter) do
			table.insert(result, match)
		end
		return result
	end
	return {}
end

---@param str_1 string
---@param str_2 string
---@param ... string
function _STRING.concat(str_1, str_2, ...)
	local strs = {str_1, str_2}
	local newStr = ""
	local args = {...} -- use this solution to package multiple parameters because of luajit does not support arg which is supported by native lua(stop support after 5.2)
	
	if #args > 0 then
		for i,v in ipairs(args) do
			strs[#strs + 1] = v
		end
	end
	
	newStr = table.concat(strs, "") -- table.concat(table tab, string separator)
	return newStr
end

function _STRING.FindCharReverse(str, char)
	local revStr = string.reverse(str)
	local i = string.find(revStr, char)
	return string.len(str) - i + 1
end

function _STRING.GetFileDirectory(filePath)
	-- return string.match(filePath, "(.+)/[^/]*%.%w+$")
	local rs = string.reverse(filePath)
	local pos = string.find(rs, "/")
	return string.reverse(string.sub(rs, pos + 1))
end

return _STRING
--[[
	Desc: methods to handle text
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

--- @param str string 
--- @param delimiter string 
--- @return result table 
function split(str, delimiter)
	if str  then
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

function strcat(str_1, str_2, ...)
	local _strs = {str_1, str_2}
	local _newStr = ""
	local args = {...} -- use this solution to package multiple parameters because of luajit does not support arg which is supported by native lua(stop support after 5.2)
	
	if #args > 0 then
		for i,v in ipairs(args) do
			_strs[#_strs + 1] = v
		end
	end
	
	_newStr = table.concat(_strs, "") -- table.concat(table tab, string separator)
	return _newStr
end

-- get the path of directory that file in
local text = "Data/character/swordman/asd.lua"
-- print("___string test = ", string.match(text, "(.+)/[^/]*%.%w+$"))
print("___string test = ", string.match(text, "(.+)/[^/]*") .. "/")
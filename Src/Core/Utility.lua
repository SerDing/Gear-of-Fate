--[[
	Desc: utility functions set
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

local _Utility = {}

function _Utility.GetRunPath()
    os.execute("cd > cd.tmp")
    local f = io.open("cd.tmp", r)
    local cwd = f:read("*a")
    f:close()
    os.remove("cd.tmp")
    return string.sub(cwd, 1, -2)
end

string.split = function (str, delimiter)
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

function _Utility.GetDistance(p1, p2) -- Get distance between two points
	return math.sqrt(math.pow(math.abs(p1.x - p2.x),2) + math.pow(math.abs(p1.y - p2.y),2))
end

return _Utility;


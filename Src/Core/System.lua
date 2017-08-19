--[[
	Desc: methods about system operations
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

function GetRunPath()
    os.execute("cd > cd.tmp")
    local f = io.open("cd.tmp", r)
    local cwd = f:read("*a")
    f:close()
    os.remove("cd.tmp")
    return string.sub(cwd, 1, -2)
end
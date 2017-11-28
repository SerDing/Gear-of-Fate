--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]

local _Object = require("Src.Class")()

function _Object:Ctor()
	self.type = "OBJECT"
	self.layerId = 1000

end 

function _Object:SetType(type)
    self.type = type
end 

function _Object:SetLayerId(id)
    self.layerId = id
end

function _Object:GetType()
    return self.type 
end

function _Object:GetY()
    return 0 
end

return _Object 
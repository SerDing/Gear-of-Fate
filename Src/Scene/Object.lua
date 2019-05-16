--[[
	Desc: game object interface
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* game object is the object which has a concrete image in game and stored in normal layer of scene
		* override the function getY() when you implement this interface
]]

local _Object = require("Src.Core.Class")()

function _Object:Ctor()
	self.type = "OBJECT"
	self.layerId = 1000
	self.layer = ""
	self.Y = 0
end 

function _Object:SetType(type)
    self.type = type
end 

function _Object:SetLayerId(id)
    self.layerId = id
end

function _Object:SetLayer(layer)
    self.layer = layer
end

function _Object:GetLayer(layer)
    return self.layer
end

function _Object:GetType()
    return self.type
end

function _Object:GetId()
    return self.layerId
end

function _Object:GetY()
    return self.Y 
end



return _Object 
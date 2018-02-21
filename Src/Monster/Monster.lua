--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]
local _obj = require "Src.Scene.Object" 
local _Monster = require("Src.Core.Class")(_obj)

local _AniPack = require "Src.AniPack"
local _KEYBOARD = require "Src.Core.KeyBoard" 

function _Monster:Ctor(path)

	self.path = path
	self.property = {}

	path = string.gsub( path,".mob","" )

	self.property = require(path)

	self:SetType("MONSTER")

	self.pos = {x = 0, y = 0, z = 0}
	self.dir = 1
	self.Y = 0

	self.debug = false

	self.pakArr = {
		["body"] = _AniPack.New(),
	}

	local _pathHead = "Data/monster/"
	local _pathMid = split(path, "/")
	_pathMid = _pathMid[#_pathMid - 1] .. "/"

	local _motions = {
		"[waiting motion]",
		"[move motion]",
		"[sit motion]",
		"[damage motion 1]",
		"[damage motion 2]",
		"[down motion]",
		"[overturn motion]",
	}

	for k,v in pairs(self.pakArr) do
		for i=1,#_motions do
			self.property[_motions[i]] = string.gsub(self.property[_motions[i]], ".ani","")
			v:AddAnimation(_pathHead .. _pathMid .. self.property[_motions[i]], 1, _motions[i])
		end
		for j=1,#self.property["[attack motion]"] do
			self.property["[attack motion]"][j] = string.gsub(self.property["[attack motion]"][j], ".ani","")
			v:AddAnimation(_pathHead .. _pathMid .. self.property["[attack motion]"][j], 1, "[attack motion " .. tostring(j) .. "]")
		end
	end

	self.pakArr["body"]:SetAnimation("[waiting motion]")

end 

function _Monster:Update(dt)
	
	for k,v in pairs(self.pakArr) do
		v:Update(dt)
	end
	self.Y = self.pos.y + self.pos.z
end 

function _Monster:Draw(x,y)
    for k,v in pairs(self.pakArr) do
		v:Draw(self.pos.x, self.pos.y + self.pos.z)
	end
end

function _Monster:SetPos(x,y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
end

function _Monster:GetY()
	return self.Y
end

return _Monster 
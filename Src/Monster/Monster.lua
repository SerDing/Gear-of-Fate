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
local _FSM = require "Src.FSM.FSM"
local _ObjectMgr = require "Src.Scene.ObjectManager"



function _Monster:Ctor(path)

	self.path = path
	self.property = {}

	path = string.gsub( path,".mob","" )

	self.property = require(path)

	self:SetType("MONSTER")
	self.subType = "MONSTER_GOBLIN"
	self.pos = {x = 0, y = 0, z = 0}
	self.aim = {x = 0, y = 0}
	self.speed = {x = 2, y = 1.5}
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

	self.pakArr["body"]:SetAnimation("[move motion]")

	self.FSM = _FSM.New(self, "waiting", self.subType)
	self.FSM:SetState("move", self, 800, 460)
end 

function _Monster:Update(dt)
	
	for k,v in pairs(self.pakArr) do
		v:Update(dt)
	end
	
	local hero_ = _ObjectMgr.GetHero()

	self:SetAim(hero_.pos.x, hero_.pos.y)

	self.FSM:Update(self)

	self.Y = self.pos.y + self.pos.z
end 

function _Monster:Draw(x,y)
    for k,v in pairs(self.pakArr) do
		v:Draw(self.pos.x, self.pos.y + self.pos.z)
	end
end

function _Monster:X_Move(offset)
	self.pos.x = self.pos.x + offset
end

function _Monster:Y_Move(offset)
	self.pos.y = self.pos.y + offset
end

function _Monster:SetPos(x,y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
end

function _Monster:SetAim(x,y)
	self.aim.x = x or self.aim.x
	self.aim.y = y or self.aim.y
end

function _Monster:SetDir(dir)
	self.dir = dir or self.dir
	for k,v in pairs(self.pakArr) do
		v:SetDir(dir)
	end
end

function _Monster:GetPos()
	return self.pos
end

function _Monster:GetAim()
	return self.aim
end

function _Monster:GetY()
	return self.Y
end

function _Monster:GetSpeed()
	return self.speed
end

function _Monster:GetBody()
	return self.pakArr["body"]
end

return _Monster 
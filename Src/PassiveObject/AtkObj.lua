--[[
	Desc: Attack Object
	Author: Night_Walker 
	Since: 2018-03-25 20:12:39 
	Last Modified time: 2018-03-25 20:12:39 
	Docs: 
		* Write notes here even more 
]]
local _obj = require "Src.Scene.Object" 
local _AtkObj = require("Src.Core.Class")(_obj)

local _AniPack = require "Src.AniPack" 

function _AtkObj:Ctor(path)

	self:SetType("ATKOBJ")
	self.objType = "NORMAL_OBJ"
	local _pathArr = split(path, "/")
	local _rootPath = string.gsub(path, _pathArr[#_pathArr], "")

	self.data = require(string.sub(path, 1, string.len(path) - 4))
	self.pathInfo = {}
	self.aniFiles = {}
	self.aniArr = {}

	self.pathInfo["[attack info]"] = _rootPath .. string.sub(self.data["[attack info]"], 1, string.len(self.data["[attack info]"]) - 4)
	self.atkInfo = require(self.pathInfo["[attack info]"])

	if self.data["[add object effect]"] then
		self.pathInfo["[add object effect]"] = _rootPath .. string.sub(self.data["[add object effect]"][1], 1, string.len(self.data["[add object effect]"][1]) - 4)
		self.aniFiles["[add object effect]"] = require(self.pathInfo["[add object effect]"])
		self.aniArr["addAni"] = _AniPack.New()
		self.aniArr["addAni"]:SetAnimation(self.aniFiles["[add object effect]"], 1)
	end

	self.pathInfo["[basic motion]"] = _rootPath .. string.sub(self.data["[basic motion]"], 1, string.len(self.data["[basic motion]"]) - 4)
	self.aniFiles["[basic motion]"] = require(self.pathInfo["[basic motion]"])
	self.aniArr["basicAni"] = _AniPack.New()
	self.aniArr["basicAni"]:SetAnimation(self.aniFiles["[basic motion]"], 1)
	
	for _,v in pairs(self.aniArr) do
		if self.data["[object destroy condition]"] and 
		self.data["[object destroy condition]"][2] == "[on end of animation]" then
			v:SetCurrentPlayNum(1)
		else
			v:SetCurrentPlayNum(-1)
		end
		-- v.debug = true
	end

	self.pos = {x = 0, y = 0, z = 0}
	self.speed = 0
	self.hitTime = 0
	self.dir = 1
	self.over = false
end 

function _AtkObj:Update(dt)
	
	if love.timer.getTime() - self.hitTime <= self.hitRecovery / 1000 then
		return
	end

	for _,v in pairs(self.aniArr) do
		v:Update(dt)
	end

	local _overNum = 0
	local _elementNum = 0
	for _,v in pairs(self.aniArr) do
		if v:GetCurrentPlayNum() == 0 then
			_overNum = _overNum + 1
		end
		_elementNum = _elementNum + 1
	end
	
	if _overNum == _elementNum then
		self.over = true
	end

	if self.speed ~= 0 then
		self.pos.x = self.pos.x + self.speed * self.dir
	end	

	local _atkBoxExists = false
	for _,v in pairs(self.aniArr) do
		if v:GetAttackBox() then
			_atkBoxExists = true
			break
		end
	end

	if _atkBoxExists then
		self.attackJudger:Judge(self, "MONSTER", "GoreCrossObj", self.atkInfo)
	end
end 

function _AtkObj:Draw(x,y)
   
	for _,v in pairs(self.aniArr) do
		v:SetPos(math.floor(self.pos.x), math.floor(self.pos.y) + math.floor(self.pos.z))
		v:Draw()
	end

	love.graphics.circle("line", self.pos.x, self.pos.y, 3, 50)
	love.graphics.circle("line", self.pos.x, self.pos.y + self.pos.z, 3, 50)

end

function _AtkObj:SetHost(host)
	self.host = host
	self:SetAtkJudger(host:GetAtkJudger())
	self:SetHitRecovery(host:GetHitRecovery())
	self.attackJudger:ClearDamageArr()
	for _,v in pairs(self.aniArr) do
		v:SetBaseRate(host:GetAtkSpeed())
		v:Draw()
	end
end

function _AtkObj:SetAtkJudger(judger)
	self.attackJudger = judger
end

function _AtkObj:SetHitRecovery(hitReco)
	self.hitRecovery = hitReco
end

function _AtkObj:SetPos(x, y, z)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.pos.z = z or self.pos.z
end

function _AtkObj:SetDir(dir)
	self.dir = dir or self.dir
	for _,v in pairs(self.aniArr) do
		v:SetDir(dir)
	end
end

function _AtkObj:SetHitTime(hitTime)
	self.hitTime = hitTime or self.hitTime
end

function _AtkObj:SetMoveSpeed(v)
	self.speed = v
	if v > 0 then
		self.objType = "MOV_OBJ"
	end
end

function _AtkObj:GetAttackBox()
	for _,v in pairs(self.aniArr) do
		if v:GetAttackBox() then
			return v:GetAttackBox()
		end
	end
	-- return self.aniArr["basicAni"]:GetAttackBox() or self.aniArr["addAni"]:GetAttackBox()
end

function _AtkObj:GetPos()
	return self.pos
end

function _AtkObj:GetDir()
	return self.dir
end

function _AtkObj:IsOver()
	return self.over
end

function _AtkObj:GetBody()
	-- if self.aniArr["basicAni"]:GetAttackBox() then
		return self.aniArr["basicAni"]
	-- elseif self.aniArr["addAni"]:GetAttackBox() then
	-- 	return self.aniArr["addAni"]
	-- end
end

function _AtkObj:GetY()
	return  self.pos.y
end

function _AtkObj:GetAtkObjType()
	return self.objType
end

return _AtkObj 
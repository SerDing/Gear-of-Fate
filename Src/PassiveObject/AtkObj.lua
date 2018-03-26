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

	local _pathArr = split(path, "/")
	local _rootPath = string.gsub(path, _pathArr[#_pathArr], "")

	self.data = require(string.sub(path, 1, string.len(path) - 4))
	self.pathInfo = {}
	self.pathInfo["[basic motion]"] = _rootPath .. string.sub(self.data["[basic motion]"], 1, string.len(self.data["[basic motion]"]) - 4)
	self.pathInfo["[add object effect]"] = _rootPath .. string.sub(self.data["[add object effect]"][1], 1, string.len(self.data["[add object effect]"][1]) - 4)
	self.pathInfo["[attack info]"] = _rootPath .. string.sub(self.data["[attack info]"], 1, string.len(self.data["[attack info]"]) - 4)

	self.anis = {
		["[basic motion]"] = require(self.pathInfo["[basic motion]"]),
		["[add object effect]"] = require(self.pathInfo["[add object effect]"]),
	}
	
	self.atkInfo = require(self.pathInfo["[attack info]"])

	self.basicAni = _AniPack.New()
	self.addAni = _AniPack.New()
	self.basicAni:SetAnimation(self.anis["[basic motion]"])
	self.addAni:SetAnimation(self.anis["[add object effect]"])

	
	if self.data["[object destroy condition]"][2] == "[on end of animation]" then
		self.basicAni:SetCurrentPlayNum(1) 
		self.addAni:SetCurrentPlayNum(1)
	else
		self.basicAni:SetCurrentPlayNum(-1) 
		self.addAni:SetCurrentPlayNum(-1)
	end

	-- self.basicAni.debug = true
	-- self.addAni.debug = true

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

	self.basicAni:Update(dt)
	self.addAni:Update(dt)
	
	if self.basicAni:GetCurrentPlayNum() == 0 and
	   self.addAni:GetCurrentPlayNum() == 0 then
		self.over = true
	end

	if self.speed ~= 0 then
		self.pos.x = self.pos.x + self.speed * self.dir
	end	

	if self.basicAni:GetAttackBox() or self.addAni:GetAttackBox() then
		self.attackJudger:Judge(self, "MONSTER", "GoreCrossObj", self.atkInfo)
	end

end 

function _AtkObj:Draw(x,y)
    self.basicAni:SetPos(math.floor(self.pos.x), math.floor(self.pos.y) + math.floor(self.pos.z))
	self.addAni:SetPos(math.floor(self.pos.x), math.floor(self.pos.y) + math.floor(self.pos.z))
	
	self.addAni:Draw()
	self.basicAni:Draw()
end

function _AtkObj:SetHost(host)
	self.host = host
	self:SetAtkJudger(host:GetAtkJudger())
	self:SetHitRecovery(host:GetHitRecovery())
	self.attackJudger:ClearDamageArr()
	self.basicAni:SetBaseRate(host:GetAtkSpeed())
	self.addAni:SetBaseRate(host:GetAtkSpeed())
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
	self.basicAni:SetDir(dir)
	self.addAni:SetDir(dir)
end

function _AtkObj:SetHitTime(hitTime)
	self.hitTime = hitTime or self.hitTime
end

function _AtkObj:SetMoveSpeed(v)
	self.speed = v
end

function _AtkObj:GetAttackBox()
	return self.basicAni:GetAttackBox() or self.addAni:GetAttackBox()
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
	-- if self.basicAni:GetAttackBox() then
		return self.basicAni
	-- elseif self.addAni:GetAttackBox() then
	-- 	return self.addAni
	-- end
end

function _AtkObj:GetY()
	return  self.pos.y
end


return _AtkObj 
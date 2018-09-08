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
local _AttackJudger = require "Src.Game.AttackJudger"

local _AniPack = require "Src.AniPack" 

function _AtkObj:Ctor(path)

	self:SetType("ATKOBJ")
	self.objType = "NORMAL_OBJ"
	local _pathArr = split(path, "/")
	local _rootPath = string.gsub(path, _pathArr[#_pathArr], "")

	self.data = require(string.sub(path, 1, string.len(path) - 4))
	self.pathInfo = {} -- storage path which is getn in data
	self.aniFiles = {}
	self.aniArr = {}
	self.etcAniArr = {}

	-- load attack info by paths
	self.pathInfo["[attack info]"] = strcat(_rootPath, string.sub(self.data["[attack info]"], 1, string.len(self.data["[attack info]"]) - 4))
	self.atkInfo = require(self.pathInfo["[attack info]"])

	-- init add object effect
	if self.data["[add object effect]"] then
		self.pathInfo["[add object effect]"] = strcat(_rootPath, string.sub(self.data["[add object effect]"][1], 1, string.len(self.data["[add object effect]"][1]) - 4))
		self.aniFiles["[add object effect]"] = require(self.pathInfo["[add object effect]"])
		self.aniArr["addAni"] = _AniPack.New()
		self.aniArr["addAni"]:SetAnimation(self.aniFiles["[add object effect]"], 1)
	end

	-- init etc motion
	
	if self.data["[etc motion]"] then
		self.pathInfo["[etc motion]"] = {}
		self.aniFiles["[etc motion]"] = {}
		local _str, count
		for i,v in ipairs(self.data["[etc motion]"]) do
			_str, count = string.gsub(v, ".ani", "")
			self.pathInfo["[etc motion]"][i] = strcat(_rootPath, _str) -- delete suffixv
			self.aniFiles["[etc motion]"][i] = require(self.pathInfo["[etc motion]"][i])
			self.etcAniArr[i] = _AniPack.New()
			self.etcAniArr[i]:SetAnimation(self.aniFiles["[etc motion]"][i], 1)
		end
		
	end

	-- init basic motion
	self.pathInfo["[basic motion]"] = strcat(_rootPath, string.sub(self.data["[basic motion]"], 1, string.len(self.data["[basic motion]"]) - 4))
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
	self.stableFPS = 60
	self.hitTime = 0
	self.hitRecovery = 40
	self.dir = 1
	self.over = false

	self.attackJudger = _AttackJudger.New(self, "ATK_OBJ")
end 

function _AtkObj:Update(dt)
	
	if love.timer.getTime() - self.hitTime <= self.hitRecovery / 1000 then
		return
	end

	for _,v in pairs(self.aniArr) do
		v:Update(dt)	
	end

	for _,etc in pairs(self.etcAniArr) do
		etc:Update(dt)
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
		self.pos.x = self.pos.x + self.speed * self.stableFPS * dt * self.dir
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

	for _,etc in pairs(self.etcAniArr) do
		etc:SetPos(math.floor(self.pos.x), math.floor(self.pos.y) + math.floor(self.pos.z))
		etc:Draw()
	end

	-- love.graphics.circle("line", self.pos.x, self.pos.y, 3, 50)
	-- love.graphics.circle("line", self.pos.x, self.pos.y + self.pos.z, 3, 50)
	-- love.graphics.line(self.pos.x, self.pos.y - self.atkInfo["Y"] / 2, self.pos.x, self.pos.y + self.atkInfo["Y"] / 2)

end

function _AtkObj:SetHost(host)
	self.host = host
	-- self:SetAtkJudger(host:GetAtkJudger())
	-- self:SetHitRecovery(host:GetHitRecovery())
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

function _AtkObj:Destroy()
	self.attackJudger = nil
	self.data = nil

	for k,v in pairs(self.aniArr) do
		v:Destroy()
	end

	self.aniArr = nil

	for _,etc in pairs(self.etcAniArr) do
		etc:Destroy()
	end

	self.etcAniArr = nil

	for k,v in pairs(self.pathInfo) do
		if type(v) == "table" then
			for i,v2 in ipairs(v) do
				v2 = nil
			end
		else
			v = nil
		end
	end

	self.pathInfo = nil

	for k,v in pairs(self.aniFiles) do
		if type(v) == "table" then
			for i,v2 in ipairs(v) do
				v2 = nil
			end
		else
			v = nil
		end
	end

	self.aniFiles = nil
end
return _AtkObj 
--[[
	Desc: Bullet object, which has appearance, moving and attack ability.
	Author: SerDing 
	Since: 2018-03-25 20:12:39 
	Last Modified time: 2018-03-25 20:12:39 
	Docs: 
		* Write notes here even more 
]]

local _STRING = require("engine.string")
local _RESMGR = require "system.resource.resmgr"
local _Animator = require "entity.drawable.frameani"
local _AttackJudger = require "component.combat"
local _HitStop = require("component.hitstop")

local _Bullet = require("core.class")()

function _Bullet:Ctor(path)
	self:SetType("ATKOBJ")
	self.objType = "NORMAL_OBJ"
	local _pathArr = _STRING.split(path, "/")
	local _rootPath = string.gsub(path, _pathArr[#_pathArr], "")

	self.data = _RESMGR.LoadDataFile(path)

	self.pathInfo = {} -- storage pathinfo in datafile
	self.aniFiles = {}
	self.aniArr = {}
	self.etcAniArr = {}

	-- load attack info by paths
	self.pathInfo["[attack info]"] = _rootPath .. self.data["[attack info]"]
	self.atkInfo = dofile(self.pathInfo["[attack info]"])
	
	-- init add object effect
	if self.data["[add object effect]"] then
		self.pathInfo["[add object effect]"] = _rootPath .. self.data["[add object effect]"][1]
		self.aniFiles["[add object effect]"] = dofile(self.pathInfo["[add object effect]"])
		self.aniArr["addAni"] = _Animator.New()
		self.aniArr["addAni"]:Play(self.aniFiles["[add object effect]"], 1)
		-- self.aniArr["addAni"]:SetActive(false)
	end
	-- add object effect data format:{aniPath, int, int, delayFrames}

	-- init etc motion
	if self.data["[etc motion]"] then
		self.pathInfo["[etc motion]"] = {}
		self.aniFiles["[etc motion]"] = {}
		for i,v in ipairs(self.data["[etc motion]"]) do
			self.pathInfo["[etc motion]"][i] = _rootPath .. v -- delete suffixv
			self.aniFiles["[etc motion]"][i] = dofile(self.pathInfo["[etc motion]"][i])
			self.etcAniArr[i] = _Animator.New()
			self.etcAniArr[i]:Play(self.aniFiles["[etc motion]"][i], 1)
		end
		
	end

	-- init basic motion
	self.pathInfo["[basic motion]"] = _rootPath .. self.data["[basic motion]"]
	self.aniFiles["[basic motion]"] = dofile(self.pathInfo["[basic motion]"])
	self.aniArr["basicAni"] = _Animator.New()
	self.aniArr["basicAni"]:Play(self.aniFiles["[basic motion]"], 1)
	
	-- play animations in order
	if self.data["[add object effect]"] and self.data["[add object effect]"][2] < 0 then
		self.aniArr["basicAni"]:SetActive(false) -- [add object effect] is prioritized, delay [basic motion]
	else
		self.aniArr["basicAni"]:Play(self.aniFiles["[basic motion]"], 1)
	end


	for _,v in pairs(self.aniArr) do
		--if self.data["[object destroy condition]"] and
		--self.data["[object destroy condition]"][2] == "[on end of animation]" then
		--	v:SetCurrentPlayNum(1)
		--else
		--	v:SetCurrentPlayNum(-1)
		--end
		-- v.debug = true
	end

	self.position = {x = 0, y = 0, z = 0}
	self.speed = 0
	self.hitTime = 0
	self.hitRecovery = 40
	self.dir = 1
	self.over = false

	self.attackJudger = _AttackJudger.New(self, "ATK_OBJ")
	self.components = {}
	self.components.hitstop = _HitStop.New(self)
end 

function _Bullet:Update(dt)
	-- resume playing basic motion
	if self.aniArr["basicAni"].active == false then
		-- print("self.aniArr[addAni]:GetCount() = ", self.aniArr["addAni"]:GetCount())
		if self.aniArr["addAni"]:GetCount() == - self.data["[add object effect]"][2] then
			self.aniArr["basicAni"]:Play(self.aniFiles["[basic motion]"], 1)
			self.aniArr["basicAni"]:SetActive(true)
		end
	end

	-- if love.timer.getTime() - self.hitTime <= self.hitRecovery / 1000 then
	-- 	return 
	-- end
	self.components.hitstop:Update(dt)

	for _,v in pairs(self.aniArr) do
		v:Update(dt)
	end

	for _,etc in pairs(self.etcAniArr) do
		etc:Update(dt)
	end

	----- check whether all animations are over
	local _overNum = 0
	local _elementNum = 0
	for _,v in pairs(self.aniArr) do
		if v.playOver then
			_overNum = _overNum + 1
		end
		_elementNum = _elementNum + 1
	end
	
	if _overNum == _elementNum then
		self.over = true
	end

	if self.speed ~= 0 and self.aniArr["basicAni"].active then
		self.position.x = self.position.x + self.speed * dt * self.dir
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

function _Bullet:Draw(x, y)
   
	for _,v in pairs(self.aniArr) do
		v:Draw(math.floor(self.position.x), math.floor(self.position.y) + math.floor(self.position.z), 0, 1 * self.dir, 1)
	end

	for _,etc in pairs(self.etcAniArr) do
		etc:Draw(math.floor(self.position.x), math.floor(self.position.y) + math.floor(self.position.z), 0, 1 * self.dir, 1)
	end

	love.graphics.circle("line", self.position.x, self.position.y, 3, 50)
end

function _Bullet:SetHost(host)
	self.host = host
	self.attackJudger:ClearAttackedList()
	--for _,v in pairs(self.aniArr) do
	--	v:SetPlayRate(host:GetAtkSpeed())
	--	v:Draw(math.floor(self.position.x), math.floor(self.position.y) + math.floor(self.position.z), 0, 1 * self.dir, 1)
	--end
	self.dir = self.host.transform.direction
end

function _Bullet:SetHitRecovery(hitReco)
	self.hitRecovery = hitReco
end

function _Bullet:SetPos(x, y, z)
	self.position.x = x or self.position.x
	self.position.y = y or self.position.y
	self.position.z = z or self.position.z
end

function _Bullet:SetDir(dir)
	self.dir = dir or self.dir
	for _,v in pairs(self.aniArr) do
		v:SetDir(dir)
	end
end

function _Bullet:SetMoveSpeed(v)
	self.speed = v
	if v > 0 then
		self.objType = "MOV_OBJ"
	end
end

function _Bullet:GetAttackBox()
	for _,v in pairs(self.aniArr) do
		if v:GetAttackBox() then
			return v:GetAttackBox()
		end
	end
	-- return self.aniArr["basicAni"]:GetAttackBox() or self.aniArr["addAni"]:GetAttackBox()
end

function _Bullet:GetPos()
	return self.position
end

function _Bullet:GetDir()
	return self.dir
end

function _Bullet:IsOver()
	return self.over
end

function _Bullet:GetComponent(k)
	-- assert(self.components[k], "no component: " .. k)
	return self.components[k] or nil
end

function _Bullet:GetBody()
	-- if self.aniArr["basicAni"]:GetAttackBox() then
		return self.aniArr["basicAni"]
	-- elseif self.aniArr["addAni"]:GetAttackBox() then
	-- 	return self.aniArr["addAni"]
	-- end
end

function _Bullet:GetAtkObjType()
	return self.objType
end

function _Bullet:Destroy()
	self.data = {}
	self.attackJudger = {}
	self.data = {}
	self.aniArr = {}
	self.aniFiles = {}
	self.etcAniArr = {}
	self.pathInfo = {}

	self = {}
	
end
return _Bullet 
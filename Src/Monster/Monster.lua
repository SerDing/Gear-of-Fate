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
local _FSMAIControl = require "Src.FSM.FSMAIControl"

local scene_ = {} -- init a null Scene Pointer

function _Monster:Ctor(path)

	self.path = path
	self.property = {}

	path = string.gsub( path,".mob","" )

	self.property = require(path)

	self:SetType("MONSTER")
	self.subType = "MONSTER_GOBLIN"
	self.pos = {x = 0, y = 0, z = 0}
	self.drawPos = {x = 0, y = 0, z = 0}
	self.aim = {x = 0, y = 0}
	self.speed = {x = 2, y = 1.5}
	
	self.speed = {
		x = self.property["[move speed]"][1] / 1000 * 2, 
		y = self.property["[move speed]"][2] / 1000 * 2
	}

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

	self.AI_Control = _FSMAIControl.New(self.FSM, self)

end 

function _Monster:Update(dt)
	
	for k,v in pairs(self.pakArr) do
		v:Update(dt)
	end

	self.FSM:Update(self)

	self.AI_Control:Update(dt,self)	

	self.Y = self.pos.y
end 

function _Monster:Draw(x,y)
	-- love.graphics.rectangle("line", self.pos.x - 320, self.pos.y - 150, 320 * 2, 150 * 2)
	-- love.graphics.rectangle("line", self.pos.x - 400, self.pos.y - 85, 400 * 2, 85 * 2)
	for k,v in pairs(self.pakArr) do
		v:Draw(self.drawPos.x, self.drawPos.y + self.drawPos.z)
	end
	
end

function _Monster:X_Move(offset)
	local _result
	local _pass
	local _next = self.pos.x + offset
	
	if scene_:IsInMoveableArea(_next, self.pos.y) then
		
		_result = scene_:CollideWithObstacles(_next, self.pos.y)
		
		if _result[1] then
			if offset > 0 then
				_next = _result[2].vertex[1].x - 1
			else
				_next = _result[2].vertex[2].x + 1
			end
			_pass = false
		else
			_pass = true
		end
		
	else
		if offset > 0 then
			_next = scene_.map["[virtual movable area]"][1] + scene_.map["[virtual movable area]"][3] - 1
		else
			_next = scene_.map["[virtual movable area]"][1] + 1
		end
		_pass = false
	end

	self.pos.x = _next
	self.drawPos.x = math.floor(self.pos.x)
	scene_:CheckEvent(self.pos.x, self.pos.y)

	return _pass
end

function _Monster:Y_Move(offset)
	
	local _result
	local _pass
	local _next = self.pos.y + offset

	if scene_:IsInMoveableArea(self.pos.x, _next) then
		
		_result = scene_:CollideWithObstacles(self.pos.x, _next)
		
		if _result[1] then
		
			if offset > 0 then
				_next = _result[2].vertex[1].y - 1
			elseif offset < 0 then
				_next = _result[2].vertex[2].y + 1
			end
			_pass = false
		else
			_pass = true
		end
	
	else
		if offset > 0 then
			_next = scene_.map["[virtual movable area]"][2] + 200 + scene_.map["[virtual movable area]"][4] - 1
		else
			_next = scene_.map["[virtual movable area]"][2] + 200 + 1
		end
		_pass = false
	end

	self.pos.y = _next
	self.drawPos.y = math.floor(self.pos.y)
	scene_:CheckEvent(self.pos.x, self.pos.y)

	return _pass
end

function _Monster:Damage(obj, backPower, backSpeed, float, bounce)
	log("monster damage")

	-- fix direction
	if obj.pos.x > self.pos.x then
		self:SetDir(1)
	else
		self:SetDir(-1)
	end

	_damageInfo = {
		["obj"] = obj,
		["backPower"] = backPower,
		["backSpeed"] = backSpeed or 1,
		["float"] = float or 6,
		["bounce"] = bounce,
	}

	self.FSM:SetState("damage", self, _damageInfo)
end

function _Monster:SetPos(x,y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.drawPos.x = math.floor(self.pos.x)
	self.drawPos.y = math.floor(self.pos.y)
end

function _Monster:SetZ(z)
	self.pos.z = z or self.pos.z
	self.drawPos.z = math.floor(self.pos.z)
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

function _Monster:SetAnimation(aniName)
	for k,v in pairs(self.pakArr) do
		v:SetAnimation(aniName)
	end
end

function _Monster:NextFrame()
	for k,v in pairs(self.pakArr) do
		v:NextFrame()
	end
end

function _Monster:SetScenePtr(ptr)
	assert(ptr,"Err: _Monster:SetScenePtr() scene pointer is nil!")
	scene_ = ptr
end

function _Monster:GetPos()
	return self.pos
end

function _Monster:GetAim()
	return self.aim
end

function _Monster:GetDir()
	return self.dir
end

function _Monster:GetZ()
	return self.pos.z
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

function _Monster:IsDead()
	return false
end

function _Monster:GetDamageBox()
	return self.pakArr["body"]:GetDamageBox()
end

return _Monster 
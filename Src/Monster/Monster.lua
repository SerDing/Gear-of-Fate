--[[
	Desc: Monster class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]
local _obj = require "Src.Scene.Object" 
local _Monster = require("Src.Core.Class")(_obj)

local _AniPack = require "Src.AniPack"
local _Input = require "Src.Input.Input"
local _FSM = require "Src.FSM.FSM"
local _FSMAIControl = require "Src.FSM.FSMAIControl"
local _HP_Model = require "Src.Components.Model.HP"
local _HMP_Bar = require("Src.GUI.Widgets.HMP_Bar")

local scene_ = {} -- init a null Scene Pointer

function _Monster:Ctor(path, nav)

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
		x = self.property["[move speed]"][1] / 7.5, 
		y = self.property["[move speed]"][2] / 7.5
	}
	self.dir = 1
	self.Y = 0
	self.dead = false
	self.AI = true
	self.debug = false

	self.aniArr = {
		["body"] = _AniPack.New(),
	}
	self.extraEffects = {}

	local _pathHead = "Data/monster/"
	local _pathMid = split(path, "/")
	_pathMid = strcat(_pathMid[#_pathMid - 1], "/")

	local _motions = {
		"[waiting motion]",
		"[move motion]",
		"[sit motion]",
		"[damage motion 1]",
		"[damage motion 2]",
		"[down motion]",
		"[overturn motion]",
	}

	for k,v in pairs(self.aniArr) do
		for i=1,#_motions do
			self.property[_motions[i]] = string.gsub(self.property[_motions[i]], ".ani","")
			v:AddAnimation(strcat(_pathHead, _pathMid, self.property[_motions[i]]), 1, _motions[i])
		end
		for j=1,#self.property["[attack motion]"] do
			self.property["[attack motion]"][j] = string.gsub(self.property["[attack motion]"][j], ".ani","")
			v:AddAnimation(strcat(_pathHead, _pathMid, self.property["[attack motion]"][j]), 1, strcat("[attack motion ", tostring(j), "]"))
		end
		v:SetBaseRate(self.property["[attack speed]"][1] / 1000)
	end

	self.aniArr["body"]:SetAnimation("[move motion]")

	self.input = _Input.New(self)

	self.FSM = _FSM.New(self, "waiting", self.subType)

	self.AI_Control = _FSMAIControl.New(self.FSM, self, nav, self.input)

	self.Models = {}
	self.Models['HP'] = _HP_Model.New(1000, 1000)
	self.HP_Bar = _HMP_Bar.New(self.pos.x, self.pos.y, require("Data.ui.progressbar.mon_hp"), self.Models["HP"], nil, true)
end 

function _Monster:Update(dt)
	if self.dead then
		return
	end
	
	for k,v in pairs(self.aniArr) do
		v:Update(dt)
	end
	
	for n = 1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Update  then
			self.extraEffects[n]:Update(dt)
		end 
	end 
	
	for n = #self.extraEffects,1,-1 do
		if self.extraEffects[n]:IsOver() then
			self.extraEffects[n] = nil
			table.remove(self.extraEffects,n)
		end 
	end 

	self.FSM:Update(self)
	
	self.AI_Control:Update(dt,self)

	self.input:Update(dt)
	
	self.Y = self.pos.y
end 

function _Monster:Draw(x, y)
	-- love.graphics.rectangle("line", self.pos.x - 320, self.pos.y - 150, 320 * 2, 150 * 2)
	-- love.graphics.rectangle("line", self.pos.x - 400, self.pos.y - 85, 400 * 2, 85 * 2)
	
	
	for n=1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Draw and self.extraEffects[n].layer == 0 then
			self.extraEffects[n]:Draw()
		end 
	end 
	
	for k,v in pairs(self.aniArr) do
		v:Draw(self.drawPos.x, self.drawPos.y + self.drawPos.z)
	end

	for n=1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Draw and self.extraEffects[n].layer == 1 then
			self.extraEffects[n]:Draw()
		end 
	end 

	if not self.dead then
		self.HP_Bar:Draw(self.pos.x - self.HP_Bar:GetWidth() / 2, self.pos.y + self.pos.z - self.aniArr["body"]:GetHeight() - self.HP_Bar:GetHeight(), x, y)
	end
	
	-- move aim debug drawing
	-- love.graphics.line(self.pos.x, self.pos.y, self.aim.x, self.aim.y)
	-- love.graphics.circle("fill", self.pos.x, self.pos.y, 3, 20)
	-- local r, g, b, a = love.graphics.getColor()
	-- love.graphics.setColor(200, 0, 0, 255)
	-- love.graphics.circle("fill", self.aim.x, self.aim.y, 5, 20)
	-- love.graphics.setColor(r, g, b, a)
	
end

function _Monster:X_Move(offset)
	offset = offset * love.timer.getDelta()
	local _result
	local _pass
	local _next = self.pos.x + offset
	
	if scene_:IsInMoveableArea(_next, self.pos.y) then
		
		_result = scene_:IsInObstacles(_next, self.pos.y)
		
		if _result[1] then
			self:SetNearestObs(_result[2])
			if offset > 0 then
				_next = _result[2]:GetVertex()[1].x - 1
			else
				_next = _result[2]:GetVertex()[2].x + 1
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
	offset = offset * love.timer.getDelta()
	local _result
	local _pass
	local _next = self.pos.y + offset

	if scene_:IsInMoveableArea(self.pos.x, _next) then
		
		_result = scene_:IsInObstacles(self.pos.x, _next)
		
		if _result[1] then
			self:SetNearestObs(_result[2])
			if offset > 0 then
				_next = _result[2]:GetVertex()[1].y - 1
			elseif offset < 0 then
				_next = _result[2]:GetVertex()[2].y + 1
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

function _Monster:Damage(obj, damageInfo)
	local d = (obj:GetPos().x - self.pos.x > 0) and 1 or -1
	
	if obj:GetType() == "ATKOBJ" and obj:GetAtkObjType() == "MOV_OBJ" then
		if obj:GetDir() == d then
			d = -obj:GetDir()
		end
	end
	
	self:SetDir(d)-- fix direction
	self.FSM:SetState("damage", self, damageInfo, obj)

	-- decrease hp
	if not damageInfo["[damage bonus]"] then
		damageInfo["[damage bonus]"] = 35
	end
	self.Models["HP"]:Decrease(damageInfo["[damage bonus]"])

end

function _Monster:Die()
	self.dead = true
	self.aniArr["body"]:SetColor(100, 100, 100, 255)
	print("_Monster: i'm really dead!")
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

function _Monster:SetAimNode(node)
    self.aimNode = node
    if self.nodeIndex ~= 1 then
        node:SetColor(100, 0, 240, 255)
    end
    local nodePos = node:GetPos()
    self:SetAim(nodePos.x, nodePos.y)
end

function _Monster:SetAim(x,y)
	self.aim.x = x or self.aim.x
	self.aim.y = y or self.aim.y
end

function _Monster:SetDir(dir)
	self.dir = dir or self.dir
	for k,v in pairs(self.aniArr) do
		v:SetDir(dir)
	end
end

function _Monster:SetAnimation(aniName)
	for k,v in pairs(self.aniArr) do
		v:SetAnimation(aniName)
	end
end

function _Monster:NextFrame()
	for k,v in pairs(self.aniArr) do
		v:NextFrame()
	end
end

function _Monster:SetScenePtr(ptr)
	assert(ptr,"Err: _Monster:SetScenePtr() scene pointer is nil!")
	scene_ = ptr
	self.AI_Control:SetScenePtr(ptr)
end

function _Monster:SetNearestObs(obs)
	self.nearestObs = obs
end

function _Monster:GetNearestObs(obs)
	return self.nearestObs
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

function _Monster:GetInput()
	return self.input
end

function _Monster:GetSpeed()
	return self.speed
end

function _Monster:GetBody()
	return self.aniArr["body"]
end

function _Monster:IsDead()
	return self.dead
end

function _Monster:IsAI()
	return self.AI
end

function _Monster:GetDamageBox()
	return self.aniArr["body"]:GetDamageBox()
end

function _Monster:GetProperty(index)
	return self.property[index]
end

function _Monster:AddExtraEffect(effect)
	assert(effect,"Warning: Hero_SwordMan:AddExtraEffect() got a nil effect!")
	self.extraEffects[#self.extraEffects + 1] = effect
	self.extraEffects[#self.extraEffects]:SetLayerId(1000 + #self.extraEffects)
end

return _Monster 
--[[
	Desc: Monster class
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2019-11-05 12:40:40
	Docs:
		*Write notes here even more
]]

local _Animator = require("engine.animation.frameani")
local _Avatar = require("component.avatar")
local _Input = require("component.input")
local _FSM = require("utils.fsm")
local _FSMAIControl = require("component.ai")
local _Effect = require("component.effect")
local _RESMGR = require("system.resource.resmgr")

local scene_ = {} -- init a null Scene Pointer

---@class Monster
local _Monster = require("core.class")()


function _Monster:Ctor(path, nav)
	self.property = _RESMGR.LoadDataFile(path)

	self:SetType("MONSTER")
	self.subType = "MONSTER_GOBLIN"
	self.pos = {x = 0, y = 0, z = 0}
	self.drawPos = {x = 0, y = 0, z = 0}
	self.aim = {x = 0, y = 0}
	self.speed = {
		x = self.property["[move speed]"][1] , 
		y = self.property["[move speed]"][2]
	}
	self.dir = 1
	self.Y = 0
	self.dead = false
	self.debug = false

	self.components = {}
	self.components.avatar = _Avatar.New(self)
	self.components.avatar:InitBody()

	self.components["Input"] = _Input.New(self)
	self.components.effect = _Effect.New(self)

	self.FSM = _FSM.New(self, "waiting", self.subType)

	self.AI_Control = _FSMAIControl.New(self.FSM, self, nav, self.input)

	self.Models = {}
	self.Models['HP'] = _HP_Model.New(1000, 1000) -- 600 or 6000

	self.skillShortcutsMap = {
		["SKILL_SHORTCUT_1"] = nil,
		["SKILL_SHORTCUT_EX_1"] = nil,
	}

	self.extraEffects = {}
end 

function _Monster:Update(dt)
	
	self.components.effect:Update(dt)

	if self.dead then
		return
	end

	self.components.avatar:Update(dt)
	self.FSM:Update(dt)
	self.AI_Control:Update(dt,self)
	self.components["Input"]:Update(dt)
	
end 

function _Monster:Draw(x, y)
	self.components.avatar:Draw(self.drawPos.x, self.drawPos.y + self.drawPos.z)
	self.components.effect:Draw()
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
	
	self:SetDir(d) -- fix direction
	self.FSM:SetState("damage", damageInfo, obj)

	if not damageInfo["[damage bonus]"] then
		damageInfo["[damage bonus]"] = 35
	end
	self.Models["HP"]:Decrease(damageInfo["[damage bonus]"])
end

function _Monster:Die()
	self.dead = true
	self.components.avatar:GetPart("body"):SetColor(100, 100, 100, 255)
	print("monster died")
end

function _Monster:Reborn()
	self.dead = false
	self.FSM:SetState("waiting")
	self.Models.HP:Increase(1000)
	self.components.avatar:GetPart("body"):SetColor(255, 255, 255, 255)
	print("monster reborn")
end

function _Monster:SetPos(x, y, z)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.pos.z = z or self.pos.z
	self.drawPos.x = math.floor(self.pos.x)
	self.drawPos.y = math.floor(self.pos.y)
	self.drawPos.z = math.floor(self.pos.z)
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
	self.components.avatar:SetDir(dir)
end

function _Monster:Play(animID)
	self.components.avatar:Play(animID)
end

function _Monster:NextFrame()
	self.components.avatar:NextFrame()
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

function _Monster:GetSpeed()
	return self.speed
end

function _Monster:GetBody()
	return self.components.avatar:GetPart("body")
end

function _Monster:IsDead()
	return self.dead
end

function _Monster:GetDamageBox()
	return self.components.avatar:GetPart("body"):GetDamageBox()
end

return _Monster 
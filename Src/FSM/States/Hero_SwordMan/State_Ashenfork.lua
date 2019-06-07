--[[
	Desc: Ashenfork 
	Author: Night_Walker 
	Since: 2018-04-21 03:51:58 
	Last Modified time: 2018-04-21 03:51:58 
	Docs: 
		* Write notes here even more 
]]
local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_Ashenfork = require("Src.Core.Class")(base)

local _EffectMgr = require "Src.Scene.EffectManager" 
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"

function _State_Ashenfork:Ctor(...)
	base.Ctor(self, ...)
	self.name = "ashenfork"
	self.skillID = 16
	self.jumpPower = 0
	self.g = 160 -- 130
	self.speed = 140 * 1.3
	self.landed = false
	self.enoughHeight = false
	self:SetEffectKeyFrame(0, "jumpattackhold.lua")
end 

function _State_Ashenfork:Enter()
	self.attackName = "ashenfork"
	self.hero:SetAnimation("flowmindtwoattack1") -- waiting for changing a right one
	for i=1,3 do
		self.hero:NextFrame()
	end

	self.jumpPower = 0
	self.landed = false
	self.enoughHeight = (self.hero:GetZ() < -120) and true or false

	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.atkObj = nil
	self.movement = self.hero:GetComponent('Movement')
	self.movement.dir_z = -1
	base.Enter(self)
	self.hero:SetActionStopTime(love.timer.getTime())
end

function _State_Ashenfork:Update()
	local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()

	base.Update(self) -- super class update
	self:AtkObjBorn()
	self:Gravity()
	self:X_Move()
	self:EffectPosFix()
	
	-- attack judgement
    if self.hero:GetAttackBox() then
        self.atkJudger:Judge(self.hero, "MONSTER", self.attackName)
    end
end 

function _State_Ashenfork:Gravity()
	self.movement:Set_g(self.g, self.hero:GetAtkSpeed())
	local function landEvent()
		self.hero:SetAnimation("sit")
	end
	self.movement:Gravity(nil, landEvent)
end

function _State_Ashenfork:X_Move()
    if self.hero:GetZ() < 0 then
		self.movement:X_Move( self.speed * self.hero:GetDir())
	end 
end

function _State_Ashenfork:EffectPosFix()
    for n=1,2 do
		if self.effect[n] then
			self.effect[n].pos.x = self.hero.pos.x  - self.hero:GetDir() * 9
			self.effect[n].pos.y = self.hero.pos.y
			self.effect[n]:SetOffset(0, self.hero:GetZ())
		end 
	end 
end

function _State_Ashenfork:AtkObjBorn()
	if self.hero:GetZ() >= 0 then
		if not self.atkObj and self.enoughHeight then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20016)
			self.atkObj:SetHost(self.hero)
			self.atkObj:SetPos(self.hero:GetPos().x + 0 * self.hero:GetDir(), self.hero:GetPos().y - 1, 0)
			self.atkObj:SetDir(self.hero:GetDir())
		end
	end
end

function _State_Ashenfork:Exit()
    base.Exit(self)
end

return _State_Ashenfork 
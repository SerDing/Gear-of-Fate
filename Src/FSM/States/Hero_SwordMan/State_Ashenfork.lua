--[[
	Desc: Ashenfork 
	Author: Night_Walker 
	Since: 2018-04-21 03:51:58 
	Last Modified time: 2018-04-21 03:51:58 
	Docs: 
		* Write notes here even more 
]]
local _State_AtkBase  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_Ashenfork = require("Src.Core.Class")(_State_AtkBase)

local _EffectMgr = require "Src.Scene.EffectManager" 
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"

function _State_Ashenfork:Ctor()
	self:_Init()
	self.jumpPower = 0
	self.g = 130
	self.speed = 2.5
	self.landed = false
	self.enoughHeight = false
	self:SetEffectKeyFrame(0, "jumpattackhold.lua")
end 

function _State_Ashenfork:Enter(hero_)
    self.name = "ashenfork"
	hero_:SetAnimation("flowmindtwoattack1") -- waiting for change a right one
	
	for i=1,3 do
		hero_:NextFrame()
	end

	self.jumpPower = 0
	self.landed = false
	self.enoughHeight = (hero_.jumpOffset < -100) and true or false

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.atkObj = nil
	self:_Enter(hero_)
end

function _State_Ashenfork:Update(hero_,FSM_)
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	self:_Update(FSM_) -- super class update
	self:AtkObjBorn()
	self:Gravity()
	self:X_Move()
	self:EffectPosFix()
	
end 

function _State_Ashenfork:Gravity()
    self.jumpPower = self.jumpPower + self.dt * self.g
	
	if self.hero_.jumpOffset < 0 then
		self.hero_.jumpOffset = self.hero_.jumpOffset + self.jumpPower
	end

	if not self.landed and self.hero_.jumpOffset >= 0 then 
		self.hero_:SetAnimation("sit")
		self.hero_.jumpOffset = 0
		self.landed = true
	end
end

function _State_Ashenfork:X_Move()
    if self.hero_.jumpOffset < 0 then
		self.hero_:X_Move( self.speed * self.hero_.spd.x * self.hero_:GetDir())
	end 
end

function _State_Ashenfork:EffectPosFix()
    for n=1,2 do
		if self.effect[n] then
			self.effect[n].pos.x = self.hero_.pos.x
			self.effect[n].pos.y = self.hero_.pos.y
			self.effect[n]:SetOffset(0, self.hero_.jumpOffset)
		end 
	end 
end

function _State_Ashenfork:AtkObjBorn()
	if self.hero_.jumpOffset >= 0 then
		if not self.atkObj and self.enoughHeight then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20016)
			self.atkObj:SetHost(self.hero_)
			self.atkObj:SetPos(self.hero_:GetPos().x + 0 * self.hero_:GetDir(), self.hero_:GetPos().y, 0)
			self.atkObj:SetDir(self.hero_:GetDir())
			
		end
	end
end

function _State_Ashenfork:Exit(hero_)
    self:_Exit()
end

return _State_Ashenfork 
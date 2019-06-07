--[[
	Desc: state of moonlight slash
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]
local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_MoonSlash = require("Src.Core.Class")(base)

local _EffectMgr = require "Src.Scene.EffectManager"
local _HotKeyMgr = require "Src.Input.HotKeyMgr"

function _State_MoonSlash:Ctor(...)
	base.Ctor(self, ...)
	self.name = "moonlightslash"
	self.skillID = 77
	self.childName ={
        "moonlightslash1",
        "moonlightslash2",
    }
    self.KEYID = {}
	self.effect = {}
	self.moveSpd = 1.5

end 

function _State_MoonSlash:Enter()
	self.hero:SetAnimation(self.childName[1])
	self.atkNum = 1
	self.attackName = self.childName[self.atkNum]
	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.input = self.hero:GetComponent("Input")
	self.movement = self.hero:GetComponent('Movement')
	base.Enter(self)
end

function _State_MoonSlash:Update()
	local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()
	
	if self.hero:GetAttackBox() then
		self.atkJudger:Judge(self.hero, "MONSTER", self.attackName)
	end

	self.KEYID = _HotKeyMgr.GetSkillKey(self.skillID)

	if _body:GetCount() == 2 and not self.effect[1] then
		self:Effect("moonlightslash1.lua", 1, 1)
	end
	
	if _body:GetCount() <= 3  and self.atkNum == 1 then
		self.movement:X_Move(self.hero.spd.x * self.moveSpd * self.hero.dir )
	elseif _body:GetCount() <= 3  and self.atkNum == 2 then
		self.movement:X_Move(self.hero.spd.x * self.moveSpd * self.hero.dir )
	end 

	if _body:GetCount() >= 2 and self.atkNum == 1 then
		if self.input:IsPressed(self.KEYID) then
			self.hero:SetAnimation(self.childName[2])
			self.atkNum = 2
			self.atkJudger:ClearDamageArr()
			self.attackName = self.childName[self.atkNum]
			self:Effect("moonlightslash2.lua", 1, 1)
		end 
		
	end 
	
	if (self.input:IsHold(self.FSM.HotKeyMgr_.KEY["LEFT"]) and self.hero.dir == -1 ) or 
	(self.input:IsHold(self.FSM.HotKeyMgr_.KEY["RIGHT"]) and self.hero.dir == 1 )   then
		self.movement:X_Move(self.hero.spd.x * 20 * _dt * self.hero.dir )
	end

end 

function _State_MoonSlash:Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
    end 
end

return _State_MoonSlash 
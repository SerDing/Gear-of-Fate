--[[
	Desc: DashAttack state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of DashAttack state in this class
]]
local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_DashAttack = require("Src.Core.Class")(base)

function _State_DashAttack:Ctor(...)
	base.Ctor(self, ...)
end 

function _State_DashAttack:Enter()
	self.name = "dashattack"
	self.attackName = {"dashattack","dashattackmultihit"}
	self.hero:Play(self.name)
	self.attackCount = 1
	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.input = self.hero:GetComponent("Input")
	self.movement = self.hero:GetComponent('Movement')
	base.Enter(self)
end

function _State_DashAttack:Update()

	local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()
	
	if _body:GetCount() >= 2 and _body:GetCount() <= 4 then
		if self.attackCount == 1 then
			self.movement:X_Move(self.hero.spd.x * 2 * self.hero.dir )
		elseif self.attackCount == 2 then
			self.movement:X_Move(self.hero.spd.x * 4 * self.hero.dir )
		end 
	end 

	if _body:GetCount() > 3 and _body:GetCount() < 8 then -- 
		if self.input:IsPressed("ATTACK") and self.attackCount == 1 then
			self.hero.avatar:SetFrame(2)
			self.attackCount = self.attackCount + 1
			self.atkJudger:ClearDamageArr()
		end 
	end 

	if _body:GetCount() == 2 and not self.effect[1] and self.attackCount > 1 then
		base.Effect(self, "dashattackmultihit1.lua")
		base.Effect(self, "dashattackmultihit2.lua")
	end

	for n = 1, 2 do
		if self.effect[n] then
			self.effect[n]:SetPos(self.hero.pos.x)
		end
	end

	if self.hero:GetAttackBox() then
		self.atkJudger:Judge(self.hero, "MONSTER", self.attackName[self.attackCount])
	end
	
end 

function _State_DashAttack:Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_DashAttack 
--[[
	Desc: DashAttack state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of DashAttack state in this class
]]
local _State_AtkBase  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_DashAttack = require("Src.Core.Class")(_State_AtkBase)

local _KEYBOARD = require "Src.Core.KeyBoard"

function _State_DashAttack:Ctor()
	self.effect = {}
	self:_Init()
end 

function _State_DashAttack:Enter(hero_)
	self.name = "dashattack"
	self.attackName = {"dashattack","dashattackmultihit"}
	hero_:SetAnimation(self.name)
	self.attackCount = 1
	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self:_Enter(hero_)
end

function _State_DashAttack:Update(hero_,FSM_)

	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()
	
	if _body:GetCount() >= 2 and _body:GetCount() <= 4 then
		if self.attackCount == 1 then
			hero_:X_Move(hero_.spd.x * 75 * _dt * hero_.dir )
		elseif self.attackCount == 2 then
			hero_:X_Move(hero_.spd.x * 225 * _dt * hero_.dir )
		end 
	end 

	if _body:GetCount() > 3 then
		if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and self.attackCount <2 then
			hero_:GetBody():SetFrame(2)
			hero_:GetWeapon():SetFrame(2)
			self.attackCount = self.attackCount + 1
			self.atkJudger:ClearDamageArr()
		end 
	end 

	if _body:GetCount() == 2 and not self.effect[1] and self.attackCount > 1 then
		self.effect[1] = self:Effect("dashattackmultihit1.lua", 0, 1)	
		self.effect[2] = self:Effect("dashattackmultihit2.lua", 0, 1)	
	end 
	
	for n=1,#self.effect do
		if self.effect[n] then
			self.effect[n].pos.x = self.effect[n].pos.x + hero_.spd.x * 225 * _dt * hero_.dir
		end 
	end 
	
	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.attackName[self.attackCount])
	end
	
end 

function _State_DashAttack:Exit(hero_)
    for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_DashAttack 
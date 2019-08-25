--[[
	Desc: gorecross
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]
local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_GoreCross = require("Src.Core.Class")(base)

local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"

function _State_GoreCross:Ctor(...)
	base.Ctor(self, ...)
	self.name = "gorecross"
	self.skillID = 64
	self.effect = {}
	self.plusAtk = false
	self.input = nil
end 

function _State_GoreCross:Enter()
    
	self.hero:Play(self.name)

	self.plusAtk = false

	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.attackName = "gorecross1"
	self.atkObj = nil
	self.input = self.hero:GetComponent("Input")
	base.Enter(self)
end

function _State_GoreCross:Update()
    local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()
	
	-- attack judgement
	if _body:GetCount() == 6 then
		self.atkJudger:ClearDamageArr()
		self.attackName = "gorecross2"
	end

	if self.hero:GetAttackBox() then
		self.atkJudger:Judge(self.hero, "MONSTER", self.attackName)
	end

	-- jump the next frames
	if _body:GetCount() == 10 then -- slash action play over
		if self.effect[2] then
			self.effect[2].playOver = true
		end 
	end 
	
	-- generate effect
	if _body:GetCount() == 1 and not self.effect[1] and not self.effect[2] then
		self:Effect("gorecross/slash1.lua")
		self:Effect("gorecross/slash2.lua")
	end 
	
	if self.effect[2] and self.effect[2].playOver then
		if not self.atkObj then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20028)
			self.atkObj:SetHost(self.hero)
			self.atkObj:SetPos(self.hero:GetPos().x + 85 * self.hero:GetDir(), self.hero:GetPos().y, - 85) -- x + 70 * dir, y - 85
			self.atkObj:SetDir(self.hero:GetDir())
			self.atkObj:SetMoveSpeed(4)
			-- for k,v in pairs(self.atkObj.aniArr) do
			-- 	v:SetPlayRate(self.hero:GetAtkSpeed())
			-- end
			--print("gorecross effect2 playover")
		end
	end 

	if self.atkObj then
		if self.atkObj:IsOver() then
			self.atkObj = nil
			-- self.hero.avatar:Continue()
			-- self.FSM:SetState(self.FSM.oriState)
		end
	end
	
	-- check whether add attack
	if _body:GetCount() >= 9 then 
		if self.input:IsPressed("gorecross") then
			self.plusAtk = true
		end
	end

	if _body:GetCount() == 11 then
		if not self.plusAtk then -- jump the next frames
			self.hero.avatar:SetPlayOver(true)
		else
			-- if self.effect[3] and self.effect[4] then
				self.hero.avatar:NextFrame()
				self.hero.avatar:NextFrame()
			-- end
		end
	end

end 

function _State_GoreCross:Exit()
	self.effect = {}

end

return _State_GoreCross 
--[[
	Desc: gorecross
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

local _State_GoreCross = require("Src.Core.Class")()

local _EffectMgr = require "Src.Scene.EffectManager" 
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"
local _HotKeyMgr = require "Src.Input.HotKeyMgr"

function _State_GoreCross:Ctor(FSM, hero)
	self.FSM = FSM
    self.hero = hero
	self.name = "gorecross"
	self.skillID = 64
	self.effect = {}
	self.KEYID = ""
	self.plusAtk = false
end 

function _State_GoreCross:Enter()
    
	self.hero:SetAnimation(self.name)

	self.KEYID = ""
	self.plusAtk = false

	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.attackName = "gorecross1"
	self.atkObj = nil
	self.input = self.hero:GetComponent("Input")
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
	if _body:GetCount() == 10 then 
		if self.effect[2] then
			self.effect[2]:GetAni():SetCurrentPlayNum(0)
		end 
	end 
	
	-- effect generate
	if _body:GetCount() == 1 and not self.effect[1] and not self.effect[2] then
		
		self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "gorecross/slash1.lua", self.hero)
		self.effect[1]:GetAni():SetBaseRate(self.hero:GetAtkSpeed() )
		
		self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "gorecross/slash2.lua", self.hero) 
		self.effect[2]:GetAni():SetBaseRate(self.hero:GetAtkSpeed() * 1.05)
		
	end 
	
	if self.effect[2] and self.effect[2]:GetAni():GetCurrentPlayNum() == 0 then -- 
		if not self.atkObj then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20028)
			self.atkObj:SetHost(self.hero)
			self.atkObj:SetPos(self.hero:GetPos().x + 85 * self.hero:GetDir(), self.hero:GetPos().y, - 85) -- x + 70 * dir, y - 85
			self.atkObj:SetDir(self.hero:GetDir())
			self.atkObj:SetMoveSpeed(4)
		end
		-- table.remove(self.effect, 2)
		self.effect[2].over = false
	end 

	if self.atkObj then
		if self.atkObj:IsOver() then
			self.atkObj = nil
		end
	end
	
	-- check whether attack
	if _body:GetCount() >= 9 then 
		if self.input:IsPressed(_HotKeyMgr.GetSkillKey(self.skillID)) then
			self.plusAtk = true
		end
	end

	if _body:GetCount() == 11 then
		if not self.plusAtk then -- jump the next frames
			self.hero.animMap:SetCurrentPlayNum(0)
		else
			-- if self.effect[3] and self.effect[4] then
				self.hero.animMap:NextFrame() 
				self.hero.animMap:NextFrame() 
			-- end
		end
	end

end 

function _State_GoreCross:Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_GoreCross 
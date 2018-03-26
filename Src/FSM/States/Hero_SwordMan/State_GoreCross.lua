--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_GoreCross = require("Src.Core.Class")()

local _EffectMgr = require "Src.Scene.EffectManager" 
local _KEYBOARD = require "Src.Core.KeyBoard" 
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"

function _State_GoreCross:Ctor() 
	self.effect = {}
	self.KEYID = ""
	self.plusAtk = false
end 

function _State_GoreCross:Enter(hero_)
    self.name = "gorecross"
	hero_:GetBody():SetAnimation(self.name)
	hero_:GetWeapon():SetAnimation(self.name)
	
	self.KEYID = ""
	self.plusAtk = false

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.attackName = "gorecross1"
	self.atkObj = nil
end

function _State_GoreCross:Update(hero_,FSM_)
    local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	-- if _body:GetCount() == 4 then
	-- 	_EffectMgr:ProduceEffect()
	-- 	_SoundMgr:PlaySound()
	-- end 
	
	-- attack judgement
	if _body:GetCount() == 6 then
		self.atkJudger:ClearDamageArr()
		self.attackName = "gorecross2"
	end

	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.attackName)
	end

	-- jump the next frames
	if _body:GetCount() == 10 then 
		if self.effect[2] then
			self.effect[2]:GetAni():SetCurrentPlayNum(0)
		end 
	end 
	
	-- effect generate
	if _body:GetCount() == 1 and not self.effect[1] and not self.effect[2] then
		
		self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "gorecross/slash1.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_)
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		
		self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "gorecross/slash2.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_) 
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		
	end 
	
	if self.effect[2] and not self.effect[3] then
		if  self.effect[2]:GetAni():GetCurrentPlayNum() == 0 then
			
			if not self.atkObj then
				self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20028)
				self.atkObj:SetHost(hero_)
				self.atkObj:SetPos(hero_:GetPos().x + 70 * hero_:GetDir(), hero_:GetPos().y, - 85)
				self.atkObj:SetDir(hero_:GetDir())
				self.atkObj:SetMoveSpeed(4)
			end
			-- self.effect[4]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		end 
	end 
	
	-- effect movement
	for n=1,2 do
		if self.effect[n + 2] then
			self.effect[n + 2]:SetMoveSpeed(4)
		end 
	end

	-- whether plusAtk check
	if _body:GetCount() >= 9 then 
		self.KEYID = hero_:GetSkillKeyID("GoreCross")
		if _KEYBOARD.Press(hero_.KEY[self.KEYID]) then
			self.plusAtk = true
		end
	end

	if _body:GetCount() == 10 then 
		if not self.plusAtk then -- jump the next frames
			hero_:GetBody():SetCurrentPlayNum(0) 
			hero_:GetWeapon():SetCurrentPlayNum(0)
		else
			if self.effect[3] and self.effect[4] then
				hero_:GetBody():NextFrame() 
				hero_:GetWeapon():NextFrame()
				hero_:GetBody():NextFrame() 
				hero_:GetWeapon():NextFrame()
			end
		end
	end

end 

function _State_GoreCross:Exit(hero_)
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_GoreCross 
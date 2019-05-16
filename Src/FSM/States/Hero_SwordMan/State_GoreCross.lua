--[[
	Desc: gorecross
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_GoreCross = require("Src.Core.Class")()

local _EffectMgr = require "Src.Scene.EffectManager" 
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"
local _HotKeyMgr = require "Src.Input.HotKeyMgr"

function _State_GoreCross:Ctor()
	self.name = "gorecross"
	self.skillID = 64
	self.effect = {}
	self.KEYID = ""
	self.plusAtk = false
end 

function _State_GoreCross:Enter(hero_)
    
	hero_:SetAnimation(self.name)

	self.KEYID = ""
	self.plusAtk = false

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.attackName = "gorecross1"
	self.atkObj = nil
	self.input = hero_:GetComponent("Input")
end

function _State_GoreCross:Update(hero_,FSM_)
    local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()
	
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
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed() )
		
		self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "gorecross/slash2.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_) 
		self.effect[2]:GetAni():SetBaseRate(hero_:GetAtkSpeed() * 1.05)
		
	end 
	
	if self.effect[2] and self.effect[2]:GetAni():GetCurrentPlayNum() == 0 then -- 
		if not self.atkObj then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20028)
			self.atkObj:SetHost(hero_)
			self.atkObj:SetPos(hero_:GetPos().x + 85 * hero_:GetDir(), hero_:GetPos().y, - 85) -- x + 70 * dir, y - 85
			self.atkObj:SetDir(hero_:GetDir())
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
			hero_.animMap:SetCurrentPlayNum(0)
		else
			-- if self.effect[3] and self.effect[4] then
				hero_.animMap:NextFrame() 
				hero_.animMap:NextFrame() 
			-- end
		end
	end

end 

function _State_GoreCross:Exit(hero_)
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_GoreCross 
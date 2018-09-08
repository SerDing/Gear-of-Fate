--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_MoonSlash = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 
local _EffectMgr = require "Src.Scene.EffectManager"

function _State_MoonSlash:Ctor()
	self.name = "moonslash"
	self.childName ={
        "moonlightslash1",
        "moonlightslash2",
    } 
    self.KEYID = {}
    self.effect = {}
end 

function _State_MoonSlash:Enter(hero_)
	hero_:SetAnimation(self.childName[1])
	self.atkNum = 1
	self.attackName = self.childName[self.atkNum]
	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	
	self.movement = hero_:GetComponent('Movement')
end

function _State_MoonSlash:Update(hero_,FSM_)
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()
	
	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.attackName)
	end

	self.KEYID["MoonLightSlash"] = hero_:GetSkillKeyID("MoonLightSlash")

	if _body:GetCount() == 2 and not self.effect[1] then
		self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "moonlightslash1.lua", hero_.pos.x, hero_.pos.y + 1, 1, hero_:GetDir(), hero_)
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
	end
	
	if _body:GetCount() <= 3  and self.atkNum == 1 then
		self.movement:X_Move(hero_.spd.x * 40 * _dt * hero_.dir )
	elseif _body:GetCount() <= 3  and self.atkNum == 2 then
		self.movement:X_Move(hero_.spd.x * 40 * _dt * hero_.dir )
	end 

	if _body:GetCount() >= 2 and self.atkNum == 1 then
		if _KEYBOARD.Press(hero_.KEY[self.KEYID["MoonLightSlash"]]) then
			hero_:SetAnimation(self.childName[2])
			self.atkNum = 2
			self.atkJudger:ClearDamageArr()
			self.attackName = self.childName[self.atkNum]

			self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "moonlightslash2.lua",hero_.pos.x, hero_.pos.y + 1, 1, hero_:GetDir(), hero_)
			self.effect[2]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		end 
		
	end 
	
	if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
	(_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
		self.movement:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )
	end

end 

function _State_MoonSlash:Exit(hero_)
	for n=1,#self.effect do
		self.effect[n] = nil
    end 
end

return _State_MoonSlash 
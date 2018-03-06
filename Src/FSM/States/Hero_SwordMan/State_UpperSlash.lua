--[[
	Desc: UpperSlash state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of UpperSlash state in this class
]]

local _State_UpperSlash = require("Src.Core.Class")()

local _EffectMgr = require "Src.Scene.EffectManager" 
local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_UpperSlash:Ctor()
	self.effect = {}
end 

function _State_UpperSlash:Enter(hero_)
    self.name = "upperslash"
	hero_:GetBody():SetAnimation("hitback")
	hero_:GetWeapon():SetAnimation("hitback")
	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
end

function _State_UpperSlash:Update(hero_,FSM_)
    local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	if _body:GetCount() >= 2 and _body:GetCount() <=4 then
		hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )
		if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
		(_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
			
			hero_:X_Move(hero_.spd.x * 50 * _dt * hero_.dir )
		end 
	end 

	if _body:GetCount() == 2 and not self.effect[1] then
		self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "upperslash1.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_)	
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		
	end 
	
	if self.effect[1] then
		self.effect[1].pos.x = self.effect[1].pos.x + hero_.spd.x * 20 * _dt * hero_.dir
	end 

	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.name)
	end

end 

function _State_UpperSlash:Exit(hero_)
    self.effect[1] = nil
end

return _State_UpperSlash 
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

function _State_UpperSlash:Ctor()
	self.name = "upperslash"
	self.skillID = 46
	self.effect = {}
	self.smooth = 1.2
end 

function _State_UpperSlash:Enter(hero_)
	hero_:SetAnimation("hitback")
	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.movement = hero_:GetComponent('Movement')
	self.input = hero_:GetComponent("Input")
end

function _State_UpperSlash:Update(hero_,FSM_)
    local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	local _movable = true

    if (self.input:IsHold(FSM_.HotKeyMgr_.KEY["LEFT"]) and hero_.dir == 1) or
    (self.input:IsHold(FSM_.HotKeyMgr_.KEY["RIGHT"]) and hero_.dir == -1) then
        _movable = false
    end

	if _movable then
		if _body:GetCount() >= 2 and _body:GetCount() <=4 then
			self.movement:X_Move(hero_.spd.x * self.smooth * hero_.dir )
		end 
		if (self.input:IsHold(FSM_.HotKeyMgr_.KEY["LEFT"]) and hero_.dir == -1 ) or 
		(self.input:IsHold(FSM_.HotKeyMgr_.KEY["RIGHT"]) and hero_.dir == 1 )   then
			
			self.movement:X_Move(hero_.spd.x * self.smooth * 0.5 * hero_.dir )
		end 
		if self.effect[1] then
			self.effect[1].pos.x = self.effect[1].pos.x + _dt * hero_.spd.x * self.smooth * hero_.dir
		end 
	end

	if _body:GetCount() == 2 and not self.effect[1] then
		self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "upperslash1.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_)	
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
	end 
	
	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.name)
	end

end 

function _State_UpperSlash:Exit(hero_)
    self.effect[1] = nil
end

return _State_UpperSlash 
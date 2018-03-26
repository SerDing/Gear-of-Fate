--[[
	Desc: stay state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of stay state in this class
]]

local _State_Stay = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 
local _EffectMgr = require "Src.Scene.EffectManager" 
local _HOLD_SPACE = 0.3

local _time = 0

function _State_Stay:Ctor()
	self.keyPressTime = {left = 0, right = 0}
	self.KEYID = {}
end 

function _State_Stay:Enter(hero_)
    self.name = "stay"
	hero_:GetBody():SetAnimation(self.name)
	hero_:GetWeapon():SetAnimation(self.name)
	_time = 0
end

function _State_Stay:Update(hero_,FSM_)
    
	local _up = hero_.KEY["UP"]
	local _down = hero_.KEY["DOWN"]
	local _left = hero_.KEY["LEFT"]
	local _right = hero_.KEY["RIGHT"]
	

	if _KEYBOARD.Hold(_up) or _KEYBOARD.Hold(_down) then
		FSM_:SetState("move",hero_)
	end 
	
	if _KEYBOARD.Hold(_left) then
		if love.timer.getTime() - self.keyPressTime.left <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else
			self.keyPressTime.left = love.timer.getTime()
			hero_:SetDir(-1)
			FSM_:SetState("move",hero_)
		end 
	elseif _KEYBOARD.Hold(_right) then
		if love.timer.getTime() - self.keyPressTime.right <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else 
			self.keyPressTime.right = love.timer.getTime()
			hero_:SetDir(1)
			FSM_:SetState("move",hero_)
		end
	end
	self:UpdateSwitch(hero_,FSM_)
end 

function _State_Stay:Exit(hero_)

end

function _State_Stay:UpdateSwitch(hero_,FSM_)
----[[  Normal state switching  ]]

	self:StateSwitch("JUMP","jump",hero_,FSM_)

	self:StateSwitch("ATTACK","attack",hero_,FSM_)

	self:StateSwitch("UNIQUE","upperslash",hero_,FSM_)

	self:StateSwitch("BACK","jump",hero_,FSM_,true)
	
----[[  Skill state switching  ]]

	self:AtkStateSwitch("GoreCross","gorecross",hero_,FSM_)

	self:AtkStateSwitch("HopSmash","hopsmash",hero_,FSM_)

	self:AtkStateSwitch("Frenzy","frenzy",hero_,FSM_)

	self:AtkStateSwitch("MoonLightSlash","moonslash",hero_,FSM_)

	self:AtkStateSwitch("TripleSlash","tripleslash",hero_,FSM_)

end

function _State_Stay:StateSwitch(keyID,stateName,hero_,FSM_,...)
	if _KEYBOARD.Press(hero_.KEY[keyID]) then
		FSM_:SetState(stateName,hero_,...)
	end 
end

function _State_Stay:AtkStateSwitch(skillName,stateName,hero_,FSM_)

	self.KEYID[skillName] = hero_:GetSkillKeyID(skillName)
	
	if _KEYBOARD.Press(hero_.KEY[self.KEYID[skillName]]) then
		FSM_:SetState(stateName,hero_)
	end 

end

return _State_Stay 
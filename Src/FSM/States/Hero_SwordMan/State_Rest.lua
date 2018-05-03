--[[
	Desc: rest state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of rest state in this class
]]

local _State_Rest = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

local _HOLD_SPACE = 0.3

function _State_Rest:Ctor()
	self.keyPressTime = {left = 0, right = 0}
	self.KEYID = {}
	self.trans = {
		{"NORMAL", "JUMP", "jump"}, 
		{"NORMAL", "ATTACK", "attack"}, 
		{"NORMAL", "UNIQUE", "upperslash"}, 
		{"NORMAL", "BACK", "jump", true}, 
		{"SKILL", "GoreCross", "gorecross"}, 
		{"SKILL", "HopSmash", "hopsmash"}, 
		{"SKILL", "Frenzy", "frenzy"}, 
		{"SKILL", "MoonLightSlash", "moonslash"}, 
		{"SKILL", "TripleSlash", "tripleslash"}, 
	}
end 

function _State_Rest:Enter(hero_,_keyRlstime)
    self.name = "rest"
	hero_:SetAnimation(self.name)
	
	
end

function _State_Rest:Update(hero_,FSM_)
    
	local _up = hero_.KEY["UP"]
	local _down = hero_.KEY["DOWN"]
	local _left = hero_.KEY["LEFT"]
	local _right = hero_.KEY["RIGHT"]
	local _jump = hero_.KEY["JUMP"]
	
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
end 

function _State_Rest:Exit(hero_)
end

function _State_Rest:GetTrans()
	return self.trans
end

return _State_Rest 
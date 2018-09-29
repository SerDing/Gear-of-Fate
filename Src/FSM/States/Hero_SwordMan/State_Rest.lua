--[[
	Desc: rest state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of rest state in this class
]]

local _State_Rest = require("Src.Core.Class")()

local _HOLD_SPACE = 0.4

function _State_Rest:Ctor()
	self.keyPressTime = {left = 0, right = 0}
	self.KEYID = {}
	self.trans = {
		{"NORMAL", "JUMP", "jump"}, 
		{"NORMAL", "ATTACK", "attack"}, 
		{"NORMAL", "BACK", "jump", true}, 
		{"SKILL", 46, "upperslash"}, 
		{"SKILL", 64, "gorecross"}, 
		{"SKILL", 65, "hopsmash"}, 
		{"SKILL", 76, "frenzy"}, 
		{"SKILL", 77, "moonslash"}, 
		{"SKILL", 8, "tripleslash"}, 
	}
end 

function _State_Rest:Enter(hero_,_keyRlstime)
    self.name = "rest"
	hero_:SetAnimation(self.name)
	self.input = hero_:GetInput()
end

function _State_Rest:Update(hero_,FSM_)
    
	local _up = FSM_.HotKeyMgr_.KEY["UP"]
	local _down = FSM_.HotKeyMgr_.KEY["DOWN"]
	local _left = FSM_.HotKeyMgr_.KEY["LEFT"]
	local _right = FSM_.HotKeyMgr_.KEY["RIGHT"]
	local _jump = FSM_.HotKeyMgr_.KEY["JUMP"]
	
	if self.input:IsHold(_up) or self.input:IsHold(_down) then
		FSM_:SetState("move",hero_)
	end 
	
	if self.input:IsHold(_left) then
		if love.timer.getTime() - self.keyPressTime.left <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else
			self.keyPressTime.left = love.timer.getTime()
			hero_:SetDir(-1)
			FSM_:SetState("move",hero_)
		end 
	elseif self.input:IsHold(_right) then
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
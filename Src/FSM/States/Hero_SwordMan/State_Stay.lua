--[[
	Desc: stay state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of stay state in this class
]]

local _State_Stay = require("Src.Core.Class")()

local _HOLD_SPACE = 0.4

function _State_Stay:Ctor(FSM, hero)
	self.FSM = FSM
    self.hero = hero
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

function _State_Stay:Enter()
    self.name = "stay"
	self.hero:Play(self.name)
	self.input = self.hero:GetComponent("Input")
end

function _State_Stay:Update()
    
	local _up = self.FSM.HotKeyMgr_.KEY["UP"]
	local _down = self.FSM.HotKeyMgr_.KEY["DOWN"]
	local _left = self.FSM.HotKeyMgr_.KEY["LEFT"]
	local _right = self.FSM.HotKeyMgr_.KEY["RIGHT"]
	
	if self.input:IsHold(_up) or self.input:IsHold(_down) then
		self.FSM:SetState("move",self.hero)
	end 
	
	if self.input:IsHold(_left) then
		if love.timer.getTime() - self.keyPressTime.left <= _HOLD_SPACE then
			self.FSM:SetState("dash",self.hero)
		else
			self.keyPressTime.left = love.timer.getTime()
			self.hero:SetDir(-1)
			self.FSM:SetState("move",self.hero)
		end 
	elseif self.input:IsHold(_right) then
		if love.timer.getTime() - self.keyPressTime.right <= _HOLD_SPACE then
			self.FSM:SetState("dash",self.hero)
		else 
			self.keyPressTime.right = love.timer.getTime()
			self.hero:SetDir(1)
			self.FSM:SetState("move",self.hero)
		end
	end
end 

function _State_Stay:Exit()
end

function _State_Stay:GetTrans()
	return self.trans
end

return _State_Stay 
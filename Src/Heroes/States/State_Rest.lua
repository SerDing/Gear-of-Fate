--[[
	Desc: rest state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of rest state in this class
]]

local _State_Rest = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

local _HOLD_SPACE = 0.2

function _State_Rest:Ctor()
    self.keyPressTime = {left = 0, right = 0}
end 

function _State_Rest:Enter(hero_,_keyRlstime)
    self.name = "rest"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
	
end

function _State_Rest:Update(hero_,FSM_)
    
	local _up = hero_.KEY["UP"]
	local _down = hero_.KEY["DOWN"]
	local _left = hero_.KEY["LEFT"]
	local _right = hero_.KEY["RIGHT"]
	local _jump = hero_.KEY["JUMP"]
	
	if(_KEYBOARD.Hold(_up) or _KEYBOARD.Hold(_down))then
		FSM_:SetState("move",hero_)
	end 
	
	if(_KEYBOARD.Hold(_left))then
		if love.timer.getTime() - self.keyPressTime.left <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else
			self.keyPressTime.left = love.timer.getTime()
			hero_:SetDir(-1)
			FSM_:SetState("move",hero_)
		end 
	elseif(_KEYBOARD.Hold(_right))then
		if love.timer.getTime() - self.keyPressTime.right <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else 
			self.keyPressTime.right = love.timer.getTime()
			hero_:SetDir(1)
			FSM_:SetState("move",hero_)
		end
	end

	if _KEYBOARD.Press(_jump) then
		FSM_:SetState("jump",hero_)
	end 
	
	if _KEYBOARD.Press(hero_.KEY["ATTACK"]) then
		FSM_:SetState("attack",hero_)
	end 
	

end 

function _State_Rest:Exit(hero_)
    
end

return _State_Rest 
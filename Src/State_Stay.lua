--[[
	Desc: stay state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of stay state in this class
]]

local _State_Stay = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 



local _HOLD_SPACE = 0.2
local _keyPressTime = {left = 0, right = 0}
function _State_Stay:Ctor()
    --body
end 

function _State_Stay:Enter(hero_)
    self.name = "stay"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
	
end

function _State_Stay:Update(hero_,FSM_)
    
	local _up = hero_.KEY["UP"]
	local _down = hero_.KEY["DOWN"]
	local _left = hero_.KEY["LEFT"]
	local _right = hero_.KEY["RIGHT"]
	local _jump = hero_.KEY["JUMP"]

	if(_KEYBOARD.Press(_up) or _KEYBOARD.Press(_down))then
		FSM_:SetState("move",hero_)
	end 
	
	if(_KEYBOARD.Press(_left))then
		if love.timer.getTime() - _keyPressTime.left <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else
			_keyPressTime.left = love.timer.getTime()
			hero_:SetDir(-1)
			FSM_:SetState("move",hero_)
		end 
	elseif(_KEYBOARD.Press(_right))then
		if love.timer.getTime() - _keyPressTime.right <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else 
			_keyPressTime.right = love.timer.getTime()
			hero_:SetDir(1)
			FSM_:SetState("move",hero_)
		end
	end

	if _KEYBOARD.Press(_jump) then
		FSM_:SetState("jump",hero_)
	end 

end 

function _State_Stay:Exit(hero_)
    --body
end

return _State_Stay 
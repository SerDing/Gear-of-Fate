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
local _keyPressTime = {left = 0, right = 0}
function _State_Rest:Ctor()
    
end 

function _State_Rest:Enter(hero_,_keyRlstime)
    self.name = "rest"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)

end

function _State_Rest:Update(hero_,FSM_)
    
	if(_KEYBOARD.Press("up") or _KEYBOARD.Press("down"))then
		FSM_:SetState("move",hero_)
	end 
	
	if(_KEYBOARD.Press("left"))then
		if love.timer.getTime() - _keyPressTime.left <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else
			_keyPressTime.left = love.timer.getTime()
			hero_:SetDir(-1)
			FSM_:SetState("move",hero_)
		end 
	elseif(_KEYBOARD.Press("right"))then
		if love.timer.getTime() - _keyPressTime.right <= _HOLD_SPACE then
			FSM_:SetState("dash",hero_)
		else 
			_keyPressTime.right = love.timer.getTime()
			hero_:SetDir(1)
			FSM_:SetState("move",hero_)
		end
	end
end 

function _State_Rest:Exit(hero_)
    
end

return _State_Rest 
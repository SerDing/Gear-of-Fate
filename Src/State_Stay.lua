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

local _Hold_space = 0.15

function _State_Stay:Ctor()
    --body
end 

function _State_Stay:Enter(hero_,_keyRlstime)
    self.name = "stay"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
	self.keyReleaseTime = _keyRlstime or {left = 0, right = 0}
end

function _State_Stay:Update(hero_,FSM_)
    
	if(_KEYBOARD.Hold("up") or _KEYBOARD.Hold("down"))then
		FSM_:SetState("move",hero_)
	end 
	
	if(_KEYBOARD.Hold("left"))then
		if love.timer.getTime() - self.keyReleaseTime.left <= _Hold_space then
			
			FSM_:SetState("dash",hero_)
		else 
			self.keyReleaseTime = 0
			FSM_:SetState("move",hero_)
			hero_:SetDir(-1)
		end 
	elseif(_KEYBOARD.Hold("right"))then
		if love.timer.getTime() - self.keyReleaseTime.right <= _Hold_space then
			FSM_:SetState("dash",hero_)
		else 
			self.keyReleaseTime = 0
			FSM_:SetState("move",hero_)
			hero_:SetDir(1)
		end
	end

end 

function _State_Stay:Exit(hero_)
    --body
end

return _State_Stay 
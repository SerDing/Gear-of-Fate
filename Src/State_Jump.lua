--[[
	Desc: Jump state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Jump state in this class
]]

local _State_Jump = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 


local _jumpPower = 0

function _State_Jump:Ctor()
    --body
end 

function _State_Jump:Enter(hero_,FSM_)
    self.name = "jump"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)

	if FSM_.preState.name == "dash" then
		_jumpPower = 8
	else 
		_jumpPower = 7
	end 
end

function _State_Jump:Update(hero_,FSM_,dt)
    
	local _body = hero_.pakGrp.body
	local _dt = love.timer.getDelta()

	if _body:GetCount() > 0 and _body:GetCount() <= 7 then
		_jumpPower = _jumpPower - _dt * 15
		if _jumpPower < 0 then
			_jumpPower = 0
		end

		hero_.jumpOffset = hero_.jumpOffset - _jumpPower
		if _jumpPower <= 0 then
			for _,v in pairs(hero_.pakGrp) do
				v:NextFrame()
			end
		end

	elseif _body:GetCount() > 7 and _body:GetCount() <= 14 then
		_jumpPower = _jumpPower + _dt * 20
		if hero_.jumpOffset < 0 then
			hero_.jumpOffset = hero_.jumpOffset + _jumpPower + _dt
		end
		if hero_.jumpOffset >= 0 then
			for _,v in pairs(hero_.pakGrp) do
				v:NextFrame()
			end
		end

	end 
	
	if _body:GetCount() > 0 and _body:GetCount() <= 14 then
		
		local k = 0.9

		if FSM_.preState.name == "dash" then
			k = 1.2
		end 
		
		if _KEYBOARD.Hold(hero_.KEY["LEFT"]) then
			hero_:SetDir(-1)
			hero_:X_Move(hero_.spd.x * k * -1)
		elseif _KEYBOARD.Hold(hero_.KEY["RIGHT"]) then
			hero_:SetDir(1)
			hero_:X_Move(hero_.spd.x * k * 1)
		end
	end 
	
	
end 

function _State_Jump:Exit(hero_)
    
end

return _State_Jump 
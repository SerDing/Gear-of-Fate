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
local _jumpDir = ""
local _jumpAttack = false

function _State_Jump:Ctor()
    --body
end 

function _State_Jump:Enter(hero_,FSM_)
    self.name = "jump"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)

	_jumpDir = ""

	if FSM_.preState.name == "dash" then
		_jumpPower = 8
	else 
		_jumpPower = 7
	end 
	
end

function _State_Jump:Update(hero_,FSM_)
    
	local _body = hero_.pakGrp.body
	local _dt = love.timer.getDelta()

	if not _jumpAttack then
		if _jumpDir ~= "up" and _jumpDir ~= "down" then
			if _body:GetCount() == 1 then
				_jumpDir = "up"
			end 
		end 
	end 
	

	if _jumpDir == "up" then
		
		_jumpPower = _jumpPower - _dt * 15
		
		if _jumpPower < 0 then
			_jumpPower = 0
		end
		
		hero_.jumpOffset = hero_.jumpOffset - _jumpPower
		
		if _jumpPower <= 0 then
			_jumpDir = "down"
			if not _jumpAttack then
				
				while _body:GetCount() <= 7 and _body:GetCount() > 0 do
					for _,v in pairs(hero_.pakGrp) do
						v:NextFrame()
					end
				end
				
			end

		end

	elseif _jumpDir == "down" then
		
		_jumpPower = _jumpPower + _dt * 20
		
		if hero_.jumpOffset < 0 then
			hero_.jumpOffset = hero_.jumpOffset + _jumpPower + _dt
		end
		
		if hero_.jumpOffset >= 0 then
			if not _jumpAttack then
				
				while _body:GetCount() <= 14 and _body:GetCount() > 7 do
					for _,v in pairs(hero_.pakGrp) do
						v:NextFrame()
					end
				end

			end
			
		end
		
	end 

	
	if _jumpDir == "up" or _jumpDir == "down" then
		local k = 0.9
		if FSM_.preState.name == "dash" then
			k = 1.2
		end 
		if _KEYBOARD.Hold(hero_.KEY["LEFT"]) then
			if not _jumpAttack then
				hero_:SetDir(-1)
			end
			hero_:X_Move(hero_.spd.x * k * -1)
		elseif _KEYBOARD.Hold(hero_.KEY["RIGHT"]) then
			if not _jumpAttack then
				hero_:SetDir(1)
			end
			hero_:X_Move(hero_.spd.x * k * 1)
		end
	end 

	-- hero_:Logic_Jump()

	if not _jumpAttack then
		
		if  hero_.jumpOffset < -2  then
			
			if _KEYBOARD.Hold(hero_.KEY["ATTACK"]) then
				_jumpAttack = true
				print("jump attacking")
				hero_.pakGrp.body:SetAnimation("jumpattack")
				hero_.pakGrp.weapon:SetAnimation("jumpattack")
				-- FSM_:SetState("jumpattack",hero_)
			end 
		end 


		
	end

	if _jumpAttack then
		if _body.playNum == 0 then
			if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and hero_.jumpOffset < -2 then
				_body.playNum = 1
			else 
				_jumpAttack = false
				if hero_.jumpOffset >= 0 then
					FSM_:SetState(FSM_.oriState,hero_)
				else 
					hero_.pakGrp.body:SetAnimation(self.name)
					hero_.pakGrp.weapon:SetAnimation(self.name)
					hero_.pakGrp.body:SetFrame(8)
					hero_.pakGrp.weapon:SetFrame(8)
				end 
				
				
			end 
			
		end 

		if hero_.jumpOffset >= 0 then
			_jumpAttack = false
			FSM_:SetState(FSM_.oriState,hero_)
		end 
		
		
	end 
	

	
	
	
end 

function _State_Jump:Exit(hero_)
    _jumpDir = ""
	_jumpAttack = false

end

return _State_Jump 
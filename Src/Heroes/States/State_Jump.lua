--[[
	Desc: Jump state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Jump state in this class
]]

local _State_Jump = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_Jump:Ctor()
    self.jumpPower = 0
	self.jumpDir = ""
	self.jumpAttack = false
end 

function _State_Jump:Enter(hero_,FSM_,backJump)
    self.name = "jump"
	hero_:GetBody():SetAnimation(self.name)
	hero_:GetWeapon():SetAnimation(self.name)

	self.jumpDir = ""

	if FSM_.preState.name == "dash" then
		self.jumpPower = 8 + 2
	else 
		self.jumpPower = 7 + 2
	end 
	
	if backJump then
		self.jumpPower = 3.5 + 1
		self.backJump = backJump
		hero_.pakGrp.body:SetFrame(8)
		hero_.pakGrp.weapon:SetFrame(8)
	else 
		self.backJump = false
	end 
	

	
end

function _State_Jump:Update(hero_,FSM_)
    
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

------[[  start jump  ]]
	
	if not self.jumpAttack then
		if self.jumpDir ~= "up" and self.jumpDir ~= "down" then
			if _body:GetCount() == 1 or _body:GetCount() == 8 then
				self.jumpDir = "up"
			end 
		end 
	end 
	
------[[	up and down logic in jump	]]
	
	if self.jumpDir == "up" then
		
		self.jumpPower = self.jumpPower - _dt * 20
		
		if self.jumpPower < 0 then
			self.jumpPower = 0
		end
		
		hero_.jumpOffset = hero_.jumpOffset - self.jumpPower
		
		if self.jumpPower <= 0 then
			self.jumpDir = "down"
			if not self.jumpAttack then
				if not self.backJump then
					while _body:GetCount() <= 7 and _body:GetCount() > 0 do
						for _,v in pairs(hero_.pakGrp) do
							v:NextFrame()
						end
					end
				end 

			end

		end

		print("jump up:", hero_.jumpOffset)

	elseif self.jumpDir == "down" then
		
		self.jumpPower = self.jumpPower + _dt * 25
		
		if hero_.jumpOffset < 0 then
			hero_.jumpOffset = hero_.jumpOffset + self.jumpPower + _dt
		end
		
		print("jump down:", hero_.jumpOffset)

		if hero_.jumpOffset >= 0 then
			if not self.jumpAttack then
				
				while _body:GetCount() <= 14 and _body:GetCount() > 7 do
					for _,v in pairs(hero_.pakGrp) do
						v:NextFrame()
					end
				end

			end
			
		end
		
	end 

------[[	move logic in jump	]]
	
	if not self.backJump then
		if self.jumpDir == "up" or self.jumpDir == "down" then
			local k = 0.9
			if FSM_.preState.name == "dash" then
				k = 2
			end 
			if _KEYBOARD.Hold(hero_.KEY["LEFT"]) then
				if not self.jumpAttack then
					hero_:SetDir(-1)
				end
				hero_:X_Move(hero_.spd.x * k * -1)
			elseif _KEYBOARD.Hold(hero_.KEY["RIGHT"]) then
				if not self.jumpAttack then
					hero_:SetDir(1)
				end
				hero_:X_Move(hero_.spd.x * k * 1)
			end

			if _KEYBOARD.Hold(hero_.KEY["UP"]) then
				hero_:Y_Move(hero_.spd.y * k * 0.5 * -1)
			elseif _KEYBOARD.Hold(hero_.KEY["DOWN"]) then
				hero_:Y_Move(hero_.spd.y * k * 0.5 * 1)
			end
		end 
	else 
		if self.jumpDir == "up" or self.jumpDir == "down" then
			hero_:X_Move( 1.75 * hero_.spd.x * hero_:GetDir() * -1)
		end
	end 
	

	

------[[	jump attack logic (contain animation handle)	]]
	
	if not self.jumpAttack then
		
		if  hero_.jumpOffset < -2  then
			
			if _KEYBOARD.Press(hero_.KEY["ATTACK"]) then
				self.jumpAttack = true
				hero_:GetBody():SetAnimation("jumpattack")
				hero_:GetWeapon():SetAnimation("jumpattack")
				-- FSM_:SetState("jumpattack",hero_)
			end 
		end 
	end

	if self.jumpAttack then
		if _body.playNum == 0 then
			if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and hero_.jumpOffset < -2 then
				_body.playNum = 1
			else 
				self.jumpAttack = false
				if hero_.jumpOffset >= 0 then  --[[	hero has been on land  ]]
					FSM_:SetState(FSM_.oriState,hero_)
				else 
					hero_:GetBody():SetAnimation(self.name)
					hero_:GetWeapon():SetAnimation(self.name)
					hero_:GetBody():SetFrame(8)
					hero_:GetWeapon():SetFrame(8)
				end 
				
				
			end 
			
		end 

		--[[	Hero has been on land ,then set state to oriState	]]

		if hero_.jumpOffset >= 0 then
			self.jumpAttack = false
			FSM_:SetState(FSM_.oriState,hero_)
		end 
		
		--[[	jump attack check	]]
		-- local _bodyAtkBox = _body:GetAttackBox()
		-- if _bodyAtkBox then
		-- 	_ATK_CHECK:CollisionDetection(_bodyAtkBox)
		-- end 
		
	end 
	

	
	
	
end 

function _State_Jump:Exit(hero_)
    self.jumpDir = ""
	self.jumpAttack = false
	hero_.jumpOffset = 0
end

return _State_Jump 
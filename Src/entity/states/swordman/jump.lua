--[[
	Desc: Jump state 
 	Author: SerDing
	Since: 2017-07-28 
	Alter: 2020-1-3
]]
local _AUDIOMGR = require "engine.audio"
local _Base = require("entity.states.base")

---@class State.Jump : State.Base
local _Jump = require("core.class")(_Base)

function _Jump:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
    self.jumpPower = 0
	self.jumpDirection = 0
	self.jumpAttack = false
	self.directionLock = false
	self.g = 25
	self.sounds = {"SM_JUMP_ATK_01", "SM_JUMP_ATK_02"}
end 

function _Jump:Enter(backJump)
	_Base.Enter(self)
	
	self.combat:ClearDamageArr()

	self.jumpDirection = 0
	if self.STATE.preState.name == "dash" then
		self.jumpPower = 720
	else 
		self.jumpPower = 660
	end 
	
	self.backJump = backJump
	if backJump then
		self.jumpPower = 300
		self.avatar:SetFrame(9)
	end
	
	self.directionLock = false
	self.hasHit = false
	self.jumpAtkTimes = 0
	self.jumpStart = false

	self.movement.eventMap.top:AddListener(self, self.Top)
	self.movement.eventMap.land:AddListener(self, self.Land)
end

function _Jump:Update(dt)
	_Base.AutoEndTrans(self, dt)
	self:StartJump()	
	self:Movement() 
	self:JumpAttack()
	
	-- attack judgement
	-- if not self.hasHit then
	-- 	if self._entity:GetAttackBox() then
	-- 		self.hasHit = self.combat:Judge(self._entity, "MONSTER", "jumpattack")
	-- 	end
	-- end

end 

function _Jump:StartJump()
	if not self.jumpAttack and not self.jumpStart then
		if self.movement.directionZ ~= 1 and self.movement.directionZ ~= -1 then
			if self.body:GetFrame() == 1 or self.backJump then
				self.movement:StartJump(self.jumpPower, self.g)
				self.jumpStart = true
			end 
		end 
	end 
end

function _Jump:Top()
	if not self.jumpAttack and not self.backJump then
		while self.body:GetFrame() <= 8 and self.body:GetFrame() > 0 do
			self.avatar:NextFrame()
		end
	end
end

function _Jump:Land() 
	if not self.jumpAttack then
		while self.body:GetFrame() <= 15 and self.body:GetFrame() > 8 do
			self.avatar:NextFrame()
		end
	end
	-- self.STATE:SetState(self.nextState) 
end

function _Jump:Movement()
	self.jumpDirection = self.movement.directionZ
	if not self.backJump then
		if self.jumpDirection == 1 or self.jumpDirection == -1 then
			local v = 0.9 -- rate of movement
			if self.STATE.preState.name == "dash" then
				v = 2
			end 
			if self.input:IsHold("LEFT") then
				if not self.jumpAttack and not self.directionLock then
					self._entity.transform.direction = -1
				end
				self.movement:X_Move(self._entity.spd.x * v * -1)
			elseif self.input:IsHold("RIGHT") then
				if not self.jumpAttack and not self.directionLock then
					self._entity.transform.direction = 1
				end
				self.movement:X_Move(self._entity.spd.x * v * 1)
			end

			if self.input:IsHold("UP") then
				self.movement:Y_Move(self._entity.spd.y * v * 0.5 * -1)
			elseif self.input:IsHold("DOWN") then
				self.movement:Y_Move(self._entity.spd.y * v * 0.5 * 1)
			end
		end 
	else 
		if self.jumpDirection == 1 or self.jumpDirection == -1 then
			self.movement:X_Move(250 * self._entity.transform.direction * -1)
		end
	end 
end

function _Jump:JumpAttack()
	if not self.jumpAttack and not self.backJump then
		if  self._entity.transform.position.z < -2  then
			if self.input:IsPressed("ATTACK") then
				self.avatar:Play("jumpattack")
				self.directionLock = true
				self.jumpAttack = true
				self.hasHit = false
				self.jumpAtkTimes = self.jumpAtkTimes + 1
				self.combat:ClearDamageArr()
				self:PlaySound()
			end 
		end 
	end

	if self.jumpAttack then -- multi-attack
		if self.body:GetFrame() >= 5 then
			if self.input:IsPressed("ATTACK") and self._entity.transform.position.z < -2 then
				self.body.playNum = 1
				self.jumpAtkTimes = self.jumpAtkTimes + 1
				self.combat:ClearDamageArr()
				self.avatar:Play("jumpattack")
				self:PlaySound()
				self.hasHit = false
			else
				self.jumpAttack = false
				if self._entity.transform.position.z >= 0 then  -- hero has been landed
					self.STATE:SetState(self._nextState)
				else 
					self.avatar:Play(self.name) -- trans to jump state
					self.avatar:SetFrame(9)
				end 
			end 
			
		end 

		--[[	Hero has been on land, then set state to oriState	]]
		if self._entity.transform.position.z >= 0 then
			self.jumpAttack = false
			self.STATE:SetState(self._nextState)
		end 

	end 
end

function _Jump:PlaySound()
	_AUDIOMGR.PlaySound(self.sounds[math.random(1, 2)])
end

function _Jump:Exit()
	_Base.Exit(self)
    self.jumpDirection = ""
	self.jumpAttack = false
	self.movement.eventMap.top:AddListener(self, self.Top)
	self.movement.eventMap.land:AddListener(self, self.Land)
end

function _Jump:GetTrans()
	return self._trans
end

return _Jump 
--[[
	Desc: Jump state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Jump state in this class
]]

local _State_Jump = require("Src.Core.Class")()

local _AUDIOMGR = require "Src.Audio.AudioManager"

function _State_Jump:Ctor()
    self.jumpPower = 0
	self.jumpDir = 0
	self.jumpAttack = false
	self.dirLock = false -- direction lock
	self.g = 25
	self.input = {}
	self.stableFPS = 60
	self.sounds = {"SM_JUMP_ATK_01", "SM_JUMP_ATK_02"}
	self.trans = {
		{"NORMAL", "UNIQUE", "ashenfork"}, 
	}
	self.topMsg = false
	self.landMsg = false
end 

function _State_Jump:Enter(hero_,FSM_,backJump)
    self.name = "jump"
	hero_:SetAnimation(self.name)
	self.jumpDir = 0

	if FSM_.preState.name == "dash" then
		self.jumpPower = 12 * self.stableFPS
	else 
		self.jumpPower = 11 * self.stableFPS
	end 
	
	self.backJump = backJump
	if backJump then
		self.jumpPower = (3.5 + 1.5) * self.stableFPS
		hero_.pakGrp.body:SetFrame(8)
		hero_.pakGrp.weapon:SetFrame(8)
	end
	
	self.dirLock = false
	self.hasHit = false
	self.jumpAtkTimes = 0
	
	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.input = hero_:GetInput()
	self.movement = hero_:GetComponent('Movement')

	self.jumpStart = false
	self.topMsg = false
	self.landMsg = false

end

function _State_Jump:Update(hero_,FSM_)
    
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	self:StartJump(_body)	
	self:Gravity(hero_, _body, _dt) -- rising and fall
	self:Movement(FSM_, hero_) -- move logic in jump
	self:JumpATK(FSM_, hero_, _body) -- jump attack logic (contain animation handle)
	
	-- attack judgement
	if not self.hasHit then
		if hero_:GetAttackBox() then
			self.hasHit = self.atkJudger:Judge(hero_, "MONSTER", "jumpattack")
		end
	end
	
--[[ new gravity algorithm
		void Update()
		{
			time_Gravity += Time.deltaTime;
			tempY_Gravity = (v0 - gravity * time_Gravity * 0.5f) * time_Gravity;
			mTransform.position = new Vector3(mTransform.position.x, originY_Gravity + tempY_Gravity, mTransform.position.z);
			// v0：初速度
			// gravity ：重力加速
		}
		private void Jump()
		{
			// height_Fly：跳跃的高度
			v0 = Mathf.Sqrt(2 * gravity * height_Fly);
			originY_Gravity = mTransform.position.y;
			t = v0 / gravity;
			time_Gravity = 0;
		}
	]]

end 

function _State_Jump:StartJump(_body)
	if not self.jumpAttack and not self.jumpStart then
		if self.movement.dir_z ~= 1 and self.movement.dir_z ~= -1 then
			if _body:GetCount() == 1 or self.backJump then
				self.movement:StartJump(self.jumpPower, self.g)
				self.jumpStart = true
			end 
		end 
	end 
end

function _State_Jump:Gravity(hero_, _body, _dt)
	
	local function topEvent()
		self.topMsg = true
	end

	local function landEvent()
		self.landMsg = true
	end
	
	self.movement:Gravity(topEvent, landEvent)

	if self.topMsg then
		if not self.jumpAttack and not self.backJump then
			while _body:GetCount() <= 7 and _body:GetCount() > 0 do
				for _,v in pairs(hero_.pakGrp) do
					v:NextFrame()
				end
			end
		end
	end

	if self.landMsg then
		if not self.jumpAttack then
			while _body:GetCount() <= 14 and _body:GetCount() > 7 do
				for _,v in pairs(hero_.pakGrp) do
					v:NextFrame()
				end
			end
		end
	end

end

function _State_Jump:Movement(FSM_, hero_)
	self.jumpDir = self.movement.dir_z
	if not self.backJump then
		if self.jumpDir == 1 or self.jumpDir == -1 then
			local v = 0.9 -- rate of movement
			if FSM_.preState.name == "dash" then
				v = 2
			end 
			if self.input:IsHold(hero_.KEY["LEFT"]) then
				if not self.jumpAttack and not self.dirLock then
					hero_:SetDir(-1)
				end
				self.movement:X_Move(hero_.spd.x * v * -1)
			elseif self.input:IsHold(hero_.KEY["RIGHT"]) then
				if not self.jumpAttack and not self.dirLock then
					hero_:SetDir(1)
				end
				self.movement:X_Move(hero_.spd.x * v * 1)
			end

			if self.input:IsHold(hero_.KEY["UP"]) then
				self.movement:Y_Move(hero_.spd.y * v * 0.5 * -1)
			elseif self.input:IsHold(hero_.KEY["DOWN"]) then
				self.movement:Y_Move(hero_.spd.y * v * 0.5 * 1)
			end
		end 
	else 
		if self.jumpDir == 1 or self.jumpDir == -1 then
			self.movement:X_Move( 2 * hero_.spd.x * hero_:GetDir() * -1)
		end
	end 
end

function _State_Jump:JumpATK(FSM_, hero_, _body)
	if not self.jumpAttack then
		if  hero_:GetZ() < -2  then
			if self.input:IsPressed(hero_.KEY["ATTACK"]) then
				hero_:SetAnimation("jumpattack")
				self.dirLock = true
				self.jumpAttack = true
				self.hasHit = false
				self.jumpAtkTimes = self.jumpAtkTimes + 1
				self.atkJudger:ClearDamageArr()
				self:PlaySound()
			end 
		end 
	end

	if self.jumpAttack then -- multiple slash
		if _body:GetCount() >= 5 then --   _body.playNum == 0
			if self.input:IsPressed(hero_.KEY["ATTACK"]) and hero_:GetZ() < -2 then
				_body.playNum = 1
				self.jumpAtkTimes = self.jumpAtkTimes + 1
				self.atkJudger:ClearDamageArr()
				hero_:SetAnimation("jumpattack")
				self:PlaySound()
				self.hasHit = false
				-- self:PlaySound()
			else
				self.jumpAttack = false
				if hero_:GetZ() >= 0 then  --[[	hero has been on land  ]]
					FSM_:SetState(FSM_.oriState, hero_)
				else 
					hero_:SetAnimation(self.name) -- trans to jump state
					hero_:GetBody():SetFrame(8)
					hero_:GetWeapon():SetFrame(8)
				end 
			end 
			
		end 

		--[[	Hero has been on land, then set state to oriState	]]
		if hero_:GetZ() >= 0 then
			self.jumpAttack = false
			FSM_:SetState(FSM_.oriState, hero_)
		end 

	end 
end

function _State_Jump:PlaySound()
	_AUDIOMGR.PlaySound(self.sounds[math.random(1, 2)])
end

function _State_Jump:Exit(hero_)
    self.jumpDir = ""
	self.jumpAttack = false
end

function _State_Jump:GetTrans()
	return self.trans
end

return _State_Jump 
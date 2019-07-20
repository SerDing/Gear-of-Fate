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

function _State_Jump:Ctor(FSM, hero)
	self.FSM = FSM
    self.hero = hero
    self.jumpPower = 0
	self.jumpDir = 0
	self.jumpAttack = false
	self.dirLock = false -- direction lock
	self.g = 25
	-- self.g = 10
	self.input = {}
	-- self.stableFPS = 60
	self.sounds = {"SM_JUMP_ATK_01", "SM_JUMP_ATK_02"}
	self.trans = {
		{"SKILL", 16, "ashenfork"}, 
	}
	self.topMsg = false
	self.landMsg = false
end 

function _State_Jump:Enter(backJump)
    self.name = "jump"
	self.hero:Play(self.name)
	self.jumpDir = 0

	if self.FSM.preState.name == "dash" then
		self.jumpPower = 720 -- 12 * 60
	else 
		self.jumpPower = 660 -- 11 * 60
	end 
	
	self.backJump = backJump
	if backJump then
		self.jumpPower = 300 -- 5 * 60
		self.hero.animMap:SetFrame(8)
	end
	
	self.dirLock = false
	self.hasHit = false
	self.jumpAtkTimes = 0
	
	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.input = self.hero:GetComponent("Input")
	self.movement = self.hero:GetComponent('Movement')

	self.jumpStart = false
	self.topMsg = false
	self.landMsg = false

end

function _State_Jump:Update()
    
	local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()

	self:StartJump(_body)	
	self:Gravity(_body, _dt) -- rising and fall
	self:Movement() -- move logic in jump
	self:JumpATK(_body) -- jump attack logic (contain animation handle)
	
	-- attack judgement
	if not self.hasHit then
		if self.hero:GetAttackBox() then
			self.hasHit = self.atkJudger:Judge(self.hero, "MONSTER", "jumpattack")
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

function _State_Jump:Gravity(_body, _dt)
	
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
				self.hero:NextFrame()
			end
		end
	end

	if self.landMsg then
		if not self.jumpAttack then
			while _body:GetCount() <= 14 and _body:GetCount() > 7 do
				self.hero:NextFrame()
			end
		end
	end

end

function _State_Jump:Movement()
	self.jumpDir = self.movement.dir_z
	if not self.backJump then
		if self.jumpDir == 1 or self.jumpDir == -1 then
			local v = 0.9 -- rate of movement
			if self.FSM.preState.name == "dash" then
				v = 2
			end 
			if self.input:IsHold(self.FSM.HotKeyMgr_.KEY["LEFT"]) then
				if not self.jumpAttack and not self.dirLock then
					self.hero:SetDir(-1)
				end
				self.movement:X_Move(self.hero.spd.x * v * -1)
			elseif self.input:IsHold(self.FSM.HotKeyMgr_.KEY["RIGHT"]) then
				if not self.jumpAttack and not self.dirLock then
					self.hero:SetDir(1)
				end
				self.movement:X_Move(self.hero.spd.x * v * 1)
			end

			if self.input:IsHold(self.FSM.HotKeyMgr_.KEY["UP"]) then
				self.movement:Y_Move(self.hero.spd.y * v * 0.5 * -1)
			elseif self.input:IsHold(self.FSM.HotKeyMgr_.KEY["DOWN"]) then
				self.movement:Y_Move(self.hero.spd.y * v * 0.5 * 1)
			end
		end 
	else 
		if self.jumpDir == 1 or self.jumpDir == -1 then
			self.movement:X_Move( 2 * self.hero.spd.x * self.hero:GetDir() * -1)
		end
	end 
end

function _State_Jump:JumpATK(_body)
	if not self.jumpAttack then
		if  self.hero:GetZ() < -2  then
			if self.input:IsPressed(self.FSM.HotKeyMgr_.KEY["ATTACK"]) then
				self.hero:Play("jumpattack")
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
			if self.input:IsPressed(self.FSM.HotKeyMgr_.KEY["ATTACK"]) and self.hero:GetZ() < -2 then
				_body.playNum = 1
				self.jumpAtkTimes = self.jumpAtkTimes + 1
				self.atkJudger:ClearDamageArr()
				self.hero:Play("jumpattack")
				self:PlaySound()
				self.hasHit = false
				-- self:PlaySound()
			else
				self.jumpAttack = false
				if self.hero:GetZ() >= 0 then  --[[	hero has been on land  ]]
					self.FSM:SetState(self.FSM.oriState, self.hero)
				else 
					self.hero:Play(self.name) -- trans to jump state
					self.hero.animMap:SetFrame(8)
				end 
			end 
			
		end 

		--[[	Hero has been on land, then set state to oriState	]]
		if self.hero:GetZ() >= 0 then
			self.jumpAttack = false
			self.FSM:SetState(self.FSM.oriState, self.hero)
		end 

	end 
end

function _State_Jump:PlaySound()
	_AUDIOMGR.PlaySound(self.sounds[math.random(1, 2)])
end

function _State_Jump:Exit()
    self.jumpDir = ""
	self.jumpAttack = false
end

function _State_Jump:GetTrans()
	return self.trans
end

return _State_Jump 
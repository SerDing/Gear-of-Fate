--[[
	Desc: skill state: hopsmash
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]
local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_HopSmash = require("Src.Core.Class")(base)

local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"
local _CAMERA = require "Src.Game.GameCamera" 
local _HotKeyMgr = require "Src.Input.HotKeyMgr"

local _GetTime = love.timer.getTime

function _State_HopSmash:Ctor(...)
	base.Ctor(self, ...)
	self.name = "hopsmash"
	self.skillID = 65
	self.attackName = {"hopsmash1", "hopsmash2", "hopsmash3"}

	self.basePower = 200
	self.v = 0
	self.stableFPS = 60
	self.jumpDir = ""
	self.jumpAttack = false
	self.effect = {}
	
	self.timer = 0.15
	self.time = 0
	self.period = 0
	
	self.atkTimeLimit = 2
	self.atkTimes = 0
	self.atkJudgeTime = 40 / 1000
	self.atkJudgeTimer = self.atkJudgeTime

	self.stopTime = 15

	self.amplitudeX = 15
	self.amplitudeY = 18

	self.start = false
	self.land = false
	self.smash = true
	self.smash = false

	self.input = nil
end 

function _State_HopSmash:Enter()
	base.Enter(self)

	self.hero:Play("hopsmashready",1,1)
	self.oriAtkSpeed = self.hero:GetAtkSpeed()
	-- self.atkSpeed = self.oriAtkSpeed * 1.1 -- 0.85
	-- self.hero:SetAtkSpeed(self.atkSpeed)
	
	self.period = 1
	self.increment = 1.2
	self.KEYID = ""
	self.time = _GetTime() -- time of key pressing

	self.start = false
	self.atkJudgeTimer = self.atkJudgeTime
	self.atkTimes = 0

	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.atkObj = nil
	
	self.input = self.hero:GetComponent("Input")
	self.movement = self.hero:GetComponent('Movement')
	self.land = false
end

function _State_HopSmash:StartJump(_body)
	if self.movement.dir_z ~= 1 and self.movement.dir_z ~= -1 then
		if _body:GetCount() == 1 or _body:GetCount() == 8 then
			self.movement:StartJump(self.v, self.basePower * 0.51 * self.hero:GetAtkSpeed())
		end 
	end 
end

function _State_HopSmash:Update()
	base.Update(self)
	local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()
	
-----[[  HopSmash Ready period  ]]
	if self.period == 1 then
		self.KEYID = _HotKeyMgr.GetSkillKey(self.skillID)
		if self.input:IsReleased(self.KEYID) or _GetTime() - self.time >= self.timer then 
			local t = 0
			if _GetTime() - self.time < self.timer and self.input:IsReleased(self.KEYID) then
				t = 0.9
			else
				t = 0.75
			end

			self.time = _GetTime() - self.time -- get the holding time of key

			-- calc the atk sped percent by self.time
			-- local _percent = 1 - self.time * 1.5
			local _percent = 1.056 - self.time --* 0.3
			self.atkSpeed = self.oriAtkSpeed * _percent
			-- self.hero:SetAtkSpeed(self.atkSpeed)
			self.speed = self.basePower * 0.8 * self.time * 0.2
			local _limit_time = 0.10
			if self.time < _limit_time then
				self.time = _limit_time
			end

			 --if self.time < 0.1 then
			 --	self.v = self.basePower * t * 0.0925 * math.sqrt(self.hero:GetAtkSpeed()) * self.stableFPS --0.0925
			 --	-- self.speed = self.basePower * 0.9 * self.time * 0.2
			 --else
				self.v = self.basePower * t * self.time * math.sqrt(self.hero:GetAtkSpeed()) * self.stableFPS
			 --end

			self.start = true

			self.hero:Play(self.name)
			self.period = 2

			self:Effect("hopsmash/sword.lua", 0.98)
			self:Effect("hopsmash/smash.lua", 0.965)
			
			self.v = self.v - _dt * self.basePower * self.stableFPS * 1  * self.hero:GetAtkSpeed()
			self.movement:Z_Move(-self.v)
		end

		if self.start then
			
		end
	end 
	
	if self.period == 1 then
		return  
	end 

	self:StartJump(_body)
	self:Gravity()
	self:SmashEffect(_body)
	self:AttackJudgement(_body, _dt)
	self:Movement()
end 

function _State_HopSmash:Gravity()
	local function landEvent()
		self.land = true
	end
	local function fallCond()
		if self.hero:GetBody():GetCount() >= 2 then
			return true 
		end
		return false
	end

	self.movement:Set_g(self.basePower * 0.51 * self.hero:GetAtkSpeed())
	self.movement:Gravity(nil, landEvent, fallCond)
end

function _State_HopSmash:AttackJudgement(_body, dt)
	if self.hero:GetAttackBox() then
		if _body:GetCount() >= 3 and _body:GetCount() <= 4 then
			if self.atkTimes < self.atkTimeLimit then

				if self.atkJudgeTimer < self.atkJudgeTime then
					self.atkJudgeTimer = self.atkJudgeTimer + dt
					return
				end

				local attackName = (self.hero.pos.z >= 0) and "hopsmashfinal" or "hopsmash"
				self.atkJudger:ClearDamageArr()
				if self.atkJudger:Judge(self.hero, "MONSTER", attackName) then
					self.atkTimes = self.atkTimes + 1
					self.atkJudgeTimer = 0
				end
			end
			
		end
	end
end

function _State_HopSmash:SmashEffect(_body)
	if self.land and _body:GetCount() == 4 then
		if not self.atkObj and self.smash == true then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20050)
			self.atkObj:SetHost(self.hero)
			self.atkObj:SetPos(self.hero:GetPos().x + 140 * self.hero:GetDir(), self.hero:GetPos().y)
			self.atkObj:SetDir(self.hero:GetDir())
		end

		-- log(self.time * 1.25)
		_CAMERA.Shake(
			0.2, 
			-self.amplitudeX * self.time, 
			self.amplitudeX * self.time, 
			-self.amplitudeY * self.time, 
			self.amplitudeY * self.time
		)
		

	end
end

function _State_HopSmash:Movement()
	if self.hero:GetZ() < 0 then
		if self.movement.dir_z == 1 then
			self.movement:X_Move( self.speed * self.hero:GetAtkSpeed() * self.hero.spd.x * self.hero:GetDir())
		elseif self.movement.dir_z == -1 then
			self.movement:X_Move( self.speed * self.hero:GetAtkSpeed() * self.hero.spd.x * self.hero:GetDir() * 0.25) -- * 0.25
		end
	end 
	-- effect movement
	for n=1,2 do
		if self.effect[n] then
			self.effect[n]:SetPos(
					self.hero.pos.x,
					self.hero.pos.y,
					self.hero:GetZ()
			)
		end 
	end 
end

function _State_HopSmash:Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
	self.time = 0
	self.period = 0
	self.hero:SetAtkSpeed(self.oriAtkSpeed)
end

return _State_HopSmash 
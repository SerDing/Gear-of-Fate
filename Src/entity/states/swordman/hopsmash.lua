--[[
	Desc: skill state: hopsmash
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]
local _AUDIO = require("engine.audio")
local _FACTORY = require("system.entityfactory") 
local _CAMERA = require "scene.camera"
local _Base  = require "entity.states.base"

---@class State.Hopsmash : State.Base
local _Hopsmash = require("core.class")(_Base)

function _Hopsmash:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self.skillID = 65

	self._process = 0
	self.basePower = 750 --90 * 7.9 -- 200
	self.g = 36
	self.v = 0
	self.speed = 100	
	self.holdTimer = 0.15
	self.holdTime = 0
	self.holdTimelimit = 0.11

	self.atkTimeLimit = 2
	self.atkTimes = 0
	self.atkJudgeTime = 40 / 1000
	self.atkJudgeTimer = self.atkJudgeTime

	self.amplitudeX = 15
	self.amplitudeY = 18

	self.landed = false
	self.smash = true
	self.smash = false
end 

function _Hopsmash:Enter()
	_Base.Enter(self)
	
	self._process = 1
	self.holdTime = love.timer.getTime()
	self.landed = false
	self.speed = 100

	self.atkJudgeTimer = self.atkJudgeTime
	self.atkTimes = 0
	self.atkObj = nil
	
	self.combat:ClearDamageArr()

	self.movement.eventMap.top:AddListener(self, self.Top)
	self.movement.eventMap.land:AddListener(self, self.Land)
end

function _Hopsmash:Top()
	self.movement:Set_g(self.g * 2.25 * self.attackRate)
	_AUDIO.PlaySound(self._soundDataSet.voice)
end

function _Hopsmash:Land()
	self.landed = true
end

function _Hopsmash:StartJump()
	local function fallCond()
		if self.avatar:GetPart():GetTick() == 2 then
			return true 
		end
		return false
	end
	if self.movement.directionZ ~= 1 and self.movement.directionZ ~= -1 then
		if self.body:GetFrame() == 1 then
			self.movement:StartJump(self.v, self.g * self._entity.stats.attackRate, fallCond)
		end 
	end 
end

function _Hopsmash:Update(dt)
	
	if self._process == 1 then -- ready to jump
		if self.input:IsReleased("hopsmash") or love.timer.getTime() - self.holdTime >= self.holdTimer then
			
			self.holdTime = love.timer.getTime() - self.holdTime
			if self.holdTime > self.holdTimer then
				self.holdTime = self.holdTimer
			end

			-- calc the attackRate percent by holding time of key
			local timePercent = self.holdTime / self.holdTimer
			local percent = 1.0 - timePercent
			self.attackRate = self._entity.stats.attackRate + (0.3 * percent)
			self.render.rate = self.attackRate
			
			self.speed = self.speed * timePercent * 4.5 * self._entity.stats.attackRate

			print("hopsmash, timePercent = ", timePercent)

			self.holdTime = (self.holdTime < self.holdTimelimit) and self.holdTimelimit or self.holdTime
			local root = math.floor(math.sqrt(self._entity.stats.attackRate) * 1000) * 0.001
			self.v = self.basePower * (self.holdTime / self.holdTimer) * root

			self.avatar:Play(self._animPathSet[2])

			local param = {master = self._entity}
			_FACTORY.NewEntity(self._entityDataSet[1], param)
			_FACTORY.NewEntity(self._entityDataSet[2], param)
			
			
			-- self.v = self.v - dt * self.basePower * 0.5 * self._entity.stats.attackRate * self.stableFPS
			-- self.movement:Z_Move(-self.v)

			self._process = 2
		end
	end 
	
	if self._process == 1 then
		return  
	end 

	self:StartJump()
	self:SmashEffect()
	-- self:AttackJudgement(dt)
	self:Movement(dt)

	_Base.AutoEndTrans(self)
end 

function _Hopsmash:AttackJudgement(dt)
	if self._entity:GetAttackBox() then
		if self.body:GetFrame() >= 3 and self.body:GetFrame() <= 4 then
			if self.atkTimes < self.atkTimeLimit then

				if self.atkJudgeTimer < self.atkJudgeTime then
					self.atkJudgeTimer = self.atkJudgeTimer + dt
					return
				end

				local attackName = (self._entity.transform.position.z >= 0) and "hopsmashfinal" or "hopsmash"
				self.combat:ClearDamageArr()
				if self.combat:Judge(self._entity, "MONSTER", attackName) then
					self.atkTimes = self.atkTimes + 1
					self.atkJudgeTimer = 0
				end
			end
			
		end
	end
end

function _Hopsmash:SmashEffect()
	if self.landed == true and self.body:GetFrame() >= 4 then 
		if not self.atkObj and self.smash == true then
			-- self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20050)
			self.atkObj:SetHost(self._entity)
			self.atkObj:SetPos(self._entity.transform.position.x + 140 * self._entity.transform.direction, self._entity.transform.position.y)
			--self.atkObj:SetDir(self._entity.transform.direction)
		end
		_CAMERA.Shake(
			0.2, 
			-self.amplitudeX * self.holdTime, 
			self.amplitudeX * self.holdTime, 
			-self.amplitudeY * self.holdTime, 
			self.amplitudeY * self.holdTime
		)
	end
end

function _Hopsmash:Movement(dt)
	if self._entity.transform.position.z < 0 then
		if self.movement.directionZ == 1 then
			self.movement:X_Move( self.speed * self._entity.transform.direction)
		elseif self.movement.directionZ == -1 then
			self.movement:X_Move( self.speed * self._entity.transform.direction * 0.5) -- * 0.25
		end
	end 
end

function _Hopsmash:Exit()
	_Base.Exit(self)
	self.movement.eventMap.top:DelListener(self, self.Top)
	self.movement.eventMap.land:DelListener(self, self.Land)
	self.holdTime = 0
	self._process = 0
end

return _Hopsmash 
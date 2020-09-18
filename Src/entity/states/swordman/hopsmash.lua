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
local _Timer = require("utils.timer")
local _Base  = require "entity.states.base"

---@class State.Hopsmash : State.Base
local _Hopsmash = require("core.class")(_Base)

function _Hopsmash:Ctor(data, ...)
	_Base.Ctor(self, data, ...)
	self.skillID = 65
	
	self._basePower = 750
	self._gravity = 36
	self._varAttackRate = data.varAttackRate
    self._minTimePercent = data.minTimePercent
	self._verticalSpeed = 0
	self._forwardSpeedBase = data.forwardSpeed or 450
	self._forwardSpeed = 0
	self._timer = _Timer.New()
	self._holdTimer = 0.15
	self._holdTime = 0
	self._holdTimelimitForJump = 0.11

	self.atkTimeLimit = 2
	self.atkTimes = 0
	self.atkJudgeTime = 40 / 1000
	self.atkJudgeTimer = self.atkJudgeTime

	self._process = 0
	self._shakeParam = {
		time = 0.3,
		x = 15, 
		y = 18
	}

	self.landed = false
	self.smash = true
	-- self.smash = false
end 

function _Hopsmash:Enter()
	_Base.Enter(self)
	
	self._process = 1
	self._timer:Start(self._holdTimer * 1000)

	self.atkJudgeTimer = self.atkJudgeTime
	self.atkTimes = 0
	self._projectile = nil
	
	self.combat:ClearDamageArr()
	self.movement.eventMap.top:AddListener(self, self._Top)
	self.movement.eventMap.land:AddListener(self, self._Land)
end

function _Hopsmash:_Top()
	self.movement:Set_g(self._gravity * 2.25 * self.attackRate)
	_AUDIO.PlaySound(self._soundDataSet.voice)
end

function _Hopsmash:_Land()
	self.landed = true
end

function _Hopsmash:Update(dt)
	if self._process == 1 then -- ready to jump
		self._timer:Tick(dt)
		if self.input:IsReleased("hopsmash") or self._timer.isRunning == false then
			self._holdTime = self._timer:GetCount() / 1000
			self._holdTime = math.min(self._holdTime, self._holdTimer)

			local timePercent = self._holdTime / self._holdTimer
			self.attackRate = self._entity.stats.attackRate + (self._varAttackRate * (1.0 - timePercent))
			self.render.rate = self.attackRate
			self._forwardSpeed = self._forwardSpeedBase * math.max(self._minTimePercent, timePercent) * self._entity.stats.attackRate
			
			self._holdTime = math.max(self._holdTimelimitForJump, self._holdTime)
			local root = math.ceil(math.sqrt(self._entity.stats.attackRate) * 1000) * 0.001
			self._verticalSpeed = self._basePower * (self._holdTime / self._holdTimer) * root

			local param = {master = self._entity}
			_FACTORY.NewEntity(self._entityDataSet[1], param)
			_FACTORY.NewEntity(self._entityDataSet[2], param)
			self.avatar:Play(self._animNameSet[2])
			self._process = 2
		end
	elseif self._process == 2 then
		self:_StartJump()
		self:_SmashEffect()
		-- self:AttackJudgement(dt)
		self:_Movement(dt)
		_Base.AutoEndTrans(self)
	end 
end 

function _Hopsmash:_StartJump()
	local function fallCond()
		if self.avatar:GetPart():GetTick() == 2 then
			return true 
		end
		return false
	end
	if self.movement.directionZ ~= 1 and self.movement.directionZ ~= -1 then
		if self.body:GetFrame() == 1 then
			self.movement:StartJump(self._verticalSpeed, self._gravity * self._entity.stats.attackRate, fallCond)
		end 
	end 
end

function _Hopsmash:_AttackJudgement(dt)
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
function _Hopsmash:_SmashEffect()
	if self.landed and self.body:GetFrame() >= 4 then 
		if self.smash then
			local masterPosition = self._entity.transform.position
			local masterDirection = self._entity.transform.direction
			local param = {
				x = masterPosition.x + 140 * masterDirection, 
				y = masterPosition.y + 10, 
				direction = masterDirection, 
				master = self._entity,
				camp = self._entity.identity.camp,
			}
			_FACTORY.NewEntity(self._entityDataSet[3], param)
			_FACTORY.NewEntity(self._entityDataSet[4], param)
		end
		_CAMERA.Shake(self._shakeParam.time, -self._shakeParam.x * self._holdTime, self._shakeParam.x * self._holdTime, -self._shakeParam.y * self._holdTime, self._shakeParam.y * self._holdTime)
		self.landed = false
	end
end

function _Hopsmash:_Movement(dt)
	if self._entity.transform.position.z < 0 then
		if self.movement.directionZ == 1 then
			self.movement:X_Move( self._forwardSpeed * self._entity.transform.direction)
		elseif self.movement.directionZ == -1 then
			self.movement:X_Move( self._forwardSpeed * self._entity.transform.direction * 0.35) -- * 0.25
		end
	end 
end

function _Hopsmash:Exit()
	_Base.Exit(self)
	self.movement.eventMap.top:DelListener(self, self._Top)
	self.movement.eventMap.land:DelListener(self, self._Land)
	self.landed = false
	self._holdTime = 0
	self._process = 0
end

return _Hopsmash 
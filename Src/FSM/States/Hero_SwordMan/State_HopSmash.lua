--[[
	Desc: skill state: hopsmash
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]
local _State_AtkBase  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_HopSmash = require("Src.Core.Class")(_State_AtkBase)

local _EffectMgr = require "Src.Scene.EffectManager" 
local _PassiveObjMgr = require "Src.PassiveObject.PassiveObjManager"
local _CAMERA = require "Src.Game.GameCamera" 
local _HotKeyMgr = require "Src.Input.HotKeyMgr"
local _GetTime = love.timer.getTime

function _State_HopSmash:Ctor()
	self.name = "hopsmash"
	self.skillID = 65
	self.attackName = {"hopsmash1", "hopsmash2", "hopsmash3"}
	self.judgeEvents = {[3] = false, [4] = false, [5] = false, [6] = false}

	self.basePower = 200
	self.v = 0
	self.stableFPS = 60
	self.jumpDir = ""
	self.jumpAttack = false
	self.effect = {}
	
	self.timer = 0.15
	self.time = 0
	self.period = 0
	self.atkTimeLimit = 3
	self.atkTimes = 0
	self.atkJudgeTimer = 0.32
	self.atkJudgeTime = 0
	self.stopTime = 15

	self.amplitudeX = 15
	self.amplitudeY = 18

	self.start = false
	self.input = {}
	self.land = false
end 

function _State_HopSmash:Enter(hero_)
    
	hero_:SetAnimation("hopsmashready",1,1)
	self.oriAtkSpeed = hero_:GetAtkSpeed()
	-- self.atkSpeed = self.oriAtkSpeed * 0.85
	-- hero_:SetAtkSpeed(self.atkSpeed)
	
	self.period = 1
	self.increment = 1.2
	self.KEYID = ""
	self.time = _GetTime() -- press key time

	self.start = false

	self.atkTimes = 0
	self.judgeEvents = {[3] = false, [4] = false, [5] = false}

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.atkObj = nil
	
	self.input = hero_:GetInput()
	self.movement = hero_:GetComponent('Movement')
	self.land = false
	self:_Enter(hero_)
end

function _State_HopSmash:StartJump(hero_, _body)
	if self.movement.dir_z ~= 1 and self.movement.dir_z ~= -1 then
		if _body:GetCount() == 1 or _body:GetCount() == 8 then
			self.movement:StartJump(self.v, self.basePower * 0.51 * hero_:GetAtkSpeed())
		end 
	end 
end

function _State_HopSmash:Update(hero_,FSM_)
	local _body = hero_:GetBody()
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
			hero_:SetAtkSpeed(self.atkSpeed)
			self.speed = self.basePower * 0.8 * self.time * 0.2
			if self.time < 0.11 then
				self.time = 0.11
			end

			-- if self.time < 0.1 then
			-- 	self.v = self.basePower * t * 0.0925 * math.sqrt(hero_:GetAtkSpeed()) * self.stableFPS --0.0925
			-- 	-- self.speed = self.basePower * 0.9 * self.time * 0.2
			-- else
				self.v = self.basePower * t * self.time * math.sqrt(hero_:GetAtkSpeed()) * self.stableFPS
			-- end 

			self.start = true

			hero_:SetAnimation(self.name)
			self.period = 2

			self:Effect("hopsmash/sword.lua", 1, 1, 0.98)
			self:Effect("hopsmash/smash.lua", 1, 1, 0.965)
			
			self.v = self.v - _dt * self.basePower * self.stableFPS * 1  * hero_:GetAtkSpeed()
			self.movement:Z_Move(-self.v)
		end

		if self.start then
			
		end
	end 
	
	if self.period == 1 then
		return  
	end 

	self:StartJump(hero_, _body)
	self:Gravity(hero_)
	self:SmashEffect(hero_, _body)
	self:AttackJudgement(hero_, _body, _dt)
	self:Movement(hero_)

end 

function _State_HopSmash:Gravity(hero_)
	local function landEvent()
		self.land = true
	end
	local function fallCond()
		if hero_:GetBody():GetCount() >= 2 then
			return true
		end
		return false
	end
	self.movement:Set_g(self.basePower * 0.51 * hero_:GetAtkSpeed())
	self.movement:Gravity(nil, landEvent, fallCond)
end

function _State_HopSmash:AttackJudgement(hero_, _body, _dt)
	if hero_:GetAttackBox() then
		if _body:GetCount() >= 3 and _body:GetCount() <= 4 then
			-- local _judgeName = (_body:GetCount() == 5) and "hopsmash" or "hopsmash"
			-- if not self.judgeEvents[_body:GetCount()] then
			-- 	self.atkJudger:ClearDamageArr()
			-- 	self.atkJudger:Judge(hero_, "MONSTER", _judgeName)
			-- 	self.judgeEvents[_body:GetCount()] = true
			-- end

			-- self.atkJudgeTime = self.atkJudgeTime + _dt
			-- if self.atkJudgeTime < self.atkJudgeTimer then
			-- 	return
			-- end
			if self.atkTimes < 2 then
				self.atkJudger:ClearDamageArr()
				if self.atkJudger:Judge(hero_, "MONSTER", "hopsmash") then
					self.atkTimes = self.atkTimes + 1
				end
				self.judgeEvents[_body:GetCount()] = true
				
			end
			self.atkJudgeTime = 0
		end
	end
end

function _State_HopSmash:SmashEffect(hero_, _body)
	if self.land and _body:GetCount() == 4 and not self.effect[3] and not self.effect[4]  then
		if not self.atkObj then
			self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20050)
			self.atkObj:SetHost(hero_)
			self.atkObj:SetPos(hero_:GetPos().x + 140 * hero_:GetDir(), hero_:GetPos().y)
			self.atkObj:SetDir(hero_:GetDir())
		end

		-- log(self.time * 1.25)
		_CAMERA.Shake(
			0.2, 
			-self.amplitudeX * self.time, 
			self.amplitudeX * self.time, 
			-self.amplitudeY * self.time, 
			self.amplitudeY * self.time
		) -- shake effect
		

	end
end

function _State_HopSmash:Movement(hero_)
	if hero_:GetZ() < 0 then
		if self.movement.dir_z == 1 then
			self.movement:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir())
		elseif self.movement.dir_z == -1 then
			self.movement:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir() * 0.25) -- * 0.25
		end
	end 
	-- effect movement
	for n=1,2 do
		if self.effect[n] then
			self.effect[n].pos.x = hero_.pos.x
			self.effect[n].pos.y = hero_.pos.y -- plus 1 to make it be in front of hero's weapon
			self.effect[n]:SetOffset(0, hero_:GetZ())
		end 
	end 
end

function _State_HopSmash:Exit(hero_)
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
	self.time = 0
	self.period = 0
	hero_:SetAtkSpeed(self.oriAtkSpeed)
end

return _State_HopSmash 
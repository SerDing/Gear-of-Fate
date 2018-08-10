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

function _State_HopSmash:Ctor()

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

	self.amplitudeX = 15
	self.amplitudeY = 18

	self.start = false
	self.shake = false
	self.input = {}
end 

function _State_HopSmash:Enter(hero_)
    self.name = "hopsmash"
	hero_:SetAnimation("hopsmashready",1,1)
	self.oriAtkSpeed = hero_:GetAtkSpeed()
	-- self.atkSpeed = self.oriAtkSpeed * 0.85
	-- hero_:SetAtkSpeed(self.atkSpeed)
	
	self.period = 1
	self.increment = 1.2
	self.KEYID = ""
	self.time = love.timer.getTime() -- press key time

	self.start = false
	self.shake = false

	self.atkTimes = 0

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.atkObj = nil
	self.judgeEvents = {[3] = false, [4] = false, [5] = false}
	self.input = hero_:GetInput()
end

function _State_HopSmash:Update(hero_,FSM_)
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()
	
-----[[  HopSmash Ready period  ]]
	if self.period == 1 then
		
		self.KEYID = hero_:GetSkillKeyID("HopSmash")
		
		if self.input:IsReleased(hero_.KEY[self.KEYID]) or love.timer.getTime() - self.time >= self.timer then 

			local t = 0
			
			if love.timer.getTime() - self.time < self.timer and self.input:IsReleased(hero_.KEY[self.KEYID]) then
				t = 0.9
			else
				t = 0.75
			end

			self.time = love.timer.getTime() - self.time
			local _percent = 1 - self.time * 1.5
			-- print("hopsmash atk spd percent", _percent)
			self.atkSpeed = self.oriAtkSpeed * _percent
			hero_:SetAtkSpeed(self.atkSpeed)
			
			if self.time < 0.1 then
				self.v = self.basePower * t * 0.0925 * math.sqrt(hero_:GetAtkSpeed()) * self.stableFPS --0.0925
				-- self.speed = self.basePower * 0.9 * self.time * 0.2
			else
				self.v = self.basePower * t * self.time * math.sqrt(hero_:GetAtkSpeed()) * self.stableFPS
			end 

			self.speed = self.basePower * 0.8 * self.time * 0.2
			self.shake = true
			self.start = true
		end

		if self.start then
			hero_:SetAnimation(self.name)
			self.period = 2

			self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/sword.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_)	
			self.effect[1]:GetAni():SetBaseRate(self.atkSpeed)
			self.effect[1]:SetLayer(1)
			
			self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/smash.lua",hero_.pos.x,hero_.pos.y + 1,1,hero_:GetDir(), hero_)
			self.effect[2]:GetAni():SetBaseRate(self.atkSpeed)
			self.effect[2]:SetLayer(1)
		end
	end 
	
	if self.period == 1 then
		return  
	end 

------[[  Frozen animation action  ]]
	
	-- if _body:GetCount() == 3 then
	-- 	_gamePause = true
	-- end 

------[[  start jump  ]]
	
	
	if self.jumpDir ~= "up" and self.jumpDir ~= "down" then
		if _body:GetCount() == 1 or _body:GetCount() == 8 then
			self.jumpDir = "up"
		end 
	end 
	
------[[	up and down logic in jump	]]
	
	if self.jumpDir == "up" then
		
		self.v = self.v - _dt * self.basePower * self.stableFPS * 0.5  * hero_:GetAtkSpeed()
		
		if self.v < 0 then
			self.v = 0
		end

		hero_:SetZ(hero_:GetZ() - self.v * _dt)

		if hero_:GetBody():GetCount() >= 2 then -- perfect judgement!
			self.jumpDir = "down"
		end

		-- print("hopsmash up v:", self.v)

	elseif self.jumpDir == "down" then
		
		self.v = self.v + _dt * self.basePower * self.stableFPS * 0.8 * hero_:GetAtkSpeed()
		
		if hero_:GetZ() < 0 then
			hero_:SetZ(hero_:GetZ() + self.v * _dt)
		end

		if hero_:GetZ() >= 0 then
			hero_:SetZ(hero_:GetZ() / 10000)
		end

	end 

	self:AttackJudgement(hero_, _body, _dt)
	self:SmashEffect(hero_, _body)
	self:Movement(hero_)

end 

function _State_HopSmash:AttackJudgement(hero_, _body, _dt)
	if hero_:GetAttackBox() then
		if _body:GetCount() >= 3 and _body:GetCount() <= 4 then
			local _judgeName = (_body:GetCount() == 5) and "hopsmash_float" or "hopsmash_normal"
			if not self.judgeEvents[_body:GetCount()] then
				self.atkJudger:ClearDamageArr()
				self.atkJudger:Judge(hero_, "MONSTER", _judgeName)
				self.judgeEvents[_body:GetCount()] = true
			end
		end
	end
end

function _State_HopSmash:SmashEffect(hero_, _body)
	if self.jumpDir == "down" then
		if hero_:GetZ() >= 0 and _body:GetCount() == 4 and not self.effect[3] and not self.effect[4]  then
			
			-- add blood smash
			-- self.effect[3] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubback1.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y - 1,1,hero_:GetDir())
			-- self.effect[4] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubback2.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y - 1,1,hero_:GetDir())

			if not self.atkObj then
				self.atkObj = _PassiveObjMgr.GeneratePassiveObj(20050)
				self.atkObj:SetHost(hero_)
				self.atkObj:SetPos(hero_:GetPos().x + 140 * hero_:GetDir(), hero_:GetPos().y)
				self.atkObj:SetDir(hero_:GetDir())
			end

			if self.shake then
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
	end
end

function _State_HopSmash:Movement(hero_)
	if hero_:GetZ() < 0 then
		if self.jumpDir == "up" then
			hero_:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir())
		elseif self.jumpDir == "down" then
			hero_:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir() * 0.25)
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
    self.jumpDir = ""
	for n=1,#self.effect do
		self.effect[n] = nil
	end 

	self.time = 0
	self.period = 0
	
	hero_:SetZ(0)
	hero_:SetAtkSpeed(self.oriAtkSpeed)
end

return _State_HopSmash 
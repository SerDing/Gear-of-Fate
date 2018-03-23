--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_HopSmash = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 
local _EffectMgr = require "Src.Scene.EffectManager" 
local _CAMERA = require "Src.Game.GameCamera" 

function _State_HopSmash:Ctor()

	self.attackName = {
		"hopsmash1",
		"hopsmash2",
		"hopsmash3",
	}

    self.jumpPower = 0
	self.jumpDir = ""
	self.jumpAttack = false
	self.effect = {}
	
	self.timer = 0.15
	self.time = 0
	self.period = 0

	self.attackNum = 3
	

	self.start = false
	self.shake = false
end 

function _State_HopSmash:Enter(hero_)
    self.name = "hopsmash"
	hero_:SetAnimation("hopsmashready",1,1)
	self.oriAtkSpeed = hero_:GetAtkSpeed()
	hero_:SetAtkSpeed(1.3)
	self.basePower = 190
	self.period = 1
	self.increment = 1.2
	self.KEYID = ""
	self.time = love.timer.getTime()

	self.start = false
	self.shake = false
	
	self.attackTimer = 0
	self.attackTimes = 0

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
end

function _State_HopSmash:Update(hero_,FSM_)
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()
	
-----[[  HopSmash Ready period  ]]
	if self.period == 1 then
		
		self.KEYID = hero_:GetSkillKeyID("HopSmash")
		
		if _KEYBOARD.Release(hero_.KEY[self.KEYID]) or love.timer.getTime() - self.time >= self.timer then 
			self.time = love.timer.getTime() - self.time
			
			if self.time < 0.1 then
				self.jumpPower = self.basePower * 0.75 * 0.1  * math.sqrt(hero_:GetAtkSpeed())
				self.speed = self.basePower * 0.9 * 0.1 * 0.2
			else
				self.jumpPower = self.basePower * 0.75 * self.time  * math.sqrt(hero_:GetAtkSpeed())
				self.speed = self.basePower * 0.8 * self.time * 0.2
			end 
			
			if self.jumpPower < 18 then
				self.jumpPower = 18
			end

			-- if self.speed < 2.15 then
			-- 	self.speed = 2.15
			-- end

			self.shake = true
			self.start = true

		end

		if self.start then
			hero_.pakGrp.body:SetAnimation(self.name)
			hero_.pakGrp.weapon:SetAnimation(self.name)
			self.period = 2

			self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/sword.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir(), hero_)	
			self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			self.effect[1]:SetLayer(1)
			
			self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/smash.lua",hero_.pos.x,hero_.pos.y + 1,1,hero_:GetDir(), hero_)
			self.effect[2]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
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
		
		self.jumpPower = self.jumpPower - _dt * self.basePower * 0.5  * hero_:GetAtkSpeed()
		
		if self.jumpPower < 0 then
			self.jumpPower = 0
		end

		hero_.jumpOffset = hero_.jumpOffset - self.jumpPower 

		if self.jumpPower <= 0 then
			self.jumpDir = "down"
		end
		
	elseif self.jumpDir == "down" then
		
		self.jumpPower = self.jumpPower + _dt * self.basePower * 0.5 * hero_:GetAtkSpeed()
		
		if hero_.jumpOffset < 0 then
			hero_.jumpOffset = hero_.jumpOffset + self.jumpPower
		end

	end 

------[[  attack judgement  ]]
	-- 4 attack frames, total delay 480 
	
	if _body:GetCount() >= 3 and _body:GetCount() <= 6 then
		
		if self.attackTimes <= self.attackNum + 1 then
			
			self.attackTimer = self.attackTimer + _dt
			
			if self.attackTimer >= 480 / (1000 * hero_:GetAtkSpeed()) / self.attackNum then
				-- log("self.attackTimer", self.attackTimer)
				self.atkJudger:ClearDamageArr()
				-- self.atkJudger:Judge(hero_, "MONSTER")
				self.attackTimer = 0
				self.attackTimes = self.attackTimes + 1

			end
		end

		if hero_:GetAttackBox() then
			-- log(self.attackTimes + 1)
			self.atkJudger:Judge(hero_, "MONSTER", self.attackName[self.attackTimes + 1])
		end

	end

	

------[[	Effect logic	]]

	if self.jumpDir == "down" then
		if hero_.jumpOffset >= 0 and not self.effect[3] and not self.effect[4]  then
			hero_.jumpOffset = hero_.jumpOffset / 10000
			-- add blood smash
			self.effect[3] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubback1.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y - 1,1,hero_:GetDir())
			self.effect[4] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubfront1.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y + 1,1,hero_:GetDir())
			
			-- self.effect[3]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			-- self.effect[4]:GetAni():SetBaseRate(hero_:GetAtkSpeed())

			self.effect[5] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubback2.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y - 1,1,hero_:GetDir())
			self.effect[6] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubfront2.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y + 1,1,hero_:GetDir())
			
			-- self.effect[5]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			-- self.effect[6]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			if self.shake then
				-- log(self.time * 1.25)
				_CAMERA.Shake(0.2 , -3, 3 * self.time, -20 * self.time, 20 * self.time) -- shake effect
			end
			
		end
	end

------[[	move logic in jump	]]
	
	if hero_.jumpOffset < 0 then
		if self.jumpDir == "up" then
			hero_:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir())
		elseif self.jumpDir == "down" then
			hero_:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir() * 0.25)
		end
	end 


------[[	Effect offset	]]

	for n=1,2 do
		if self.effect[n] then
			self.effect[n].pos.x = hero_.pos.x
			self.effect[n].pos.y = hero_.pos.y + 1 -- plus 1 to make it be in front of hero's weapon
			self.effect[n]:SetOffset(0, hero_.jumpOffset)
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
	hero_.jumpOffset = 0

	hero_:SetAtkSpeed(self.oriAtkSpeed)
end

return _State_HopSmash 
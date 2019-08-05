--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_TripleSlash = require("Src.Core.Class")(base)

function _State_TripleSlash:Ctor(...)
	base.Ctor(self, ...)
	self.name = "tripleslash"
	self.skillID = 8
	self.childName ={
        "tripleslash1",
        "tripleslash2",
        "tripleslash3",
	} 
	self.attackNum = 0

	
	self.time_left = 0
	self.time_right = 0
	self.a = 200--255
	self.slideX = 0 -- slide x distance accumulation
end 

function _State_TripleSlash:Enter()
    
	self.hero:Play(self.childName[1])
	self.attackNum = 1
	self.attackName = self.childName[self.attackNum]
	self.nextDir = self.hero:GetDir()
	self.slideX = 0
	----[[  Call base class function  ]] 
    base.Enter(self)
    self:Effect("tripleslash/move1.lua")
	self:Effect("tripleslash/slash1.lua")
	self:ReSetSpeed()

	-- Get Components
	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.movement = self.hero:GetComponent('Movement')
end

function _State_TripleSlash:Update()

	base.Update(self) -- super class update


	self:ChangeDir()

	-- attack judgement
	if self.hero:GetAttackBox() then
		self.atkJudger:Judge(self.hero, "MONSTER", self.attackName)
	end

	if self.attackNum == 1 then
		if self.heroBody:GetCount() >= 3 then
			if self.input:IsPressed("tripleslash") then
				self:ChangeDir()
				self.hero:SetDir(self.nextDir)
				
				self.hero:Play(self.childName[2])
				self.attackNum = 2

				self.atkJudger:ClearDamageArr()
				self.attackName = self.childName[self.attackNum]

				self:ClearEffects()

				self:Effect("tripleslash/move2.lua")
				self:Effect("tripleslash/slash2.lua")
				self:ReSetSpeed()
			end 
		end 

	elseif self.attackNum == 2 then
		if self.heroBody:GetCount() >= 2 then
			if self.input:IsPressed("tripleslash") then
				self:ChangeDir()
				self.hero:SetDir(self.nextDir)

				self.hero:Play(self.childName[3])
				
				self.attackNum = 3

				self.atkJudger:ClearDamageArr()
				self.attackName = self.childName[self.attackNum]

				self:ClearEffects()

				self:Effect("tripleslash/move2.lua")
				self:Effect("tripleslash/slash3.lua")
				self:ReSetSpeed()
			end 

		end 

	end 

	self:Movement()

	for n=1,#self.effect do
        if self.effect[n] then
            self.effect[n]:SetPos(self.hero.pos.x, self.hero.pos.y)
        end 
	end 
	
end 

function _State_TripleSlash:Exit()
	base.Exit(self)
end

function _State_TripleSlash:Movement()
	self.movement:X_Move(self.speed * self.hero.dir)
	self.slideX = self.slideX + self.speed * self.dt

	-- self.speed = self.speed - self.a * self.dt
	-- print("movement:  tripslash move speed = ", self.speed)
	-- print("movement:  tripslash slideX = ", self.slideX)
	-- if self.speed < 0 then
	-- 	self.speed = 0
	-- end

	if self.slideX >= 120 then -- self.slideX >= 130   and self.speed > self.a    self.heroBody:GetCount() >= 3
		self.speed = self.speed - self.a * self.dt --* self.hero:GetAtkSpeed() / 1.5
		-- self.speed = self.speed - self.a * 1 / self.slideX
		if self.speed < 0 then
			self.speed = 0	
		end

		print("movement:  tripslash move speed = ", self.speed)

		-- if self.speed == 0 and self.heroBody.playOver then
		-- 	print("triplslash slide x = ", self.slideX)
		-- 	self.FSM:SetState(self.FSM.oriState, self.hero)
		-- end
	end 

	if self.speed == 0 then
		self.FSM:SetState(self.FSM.oriState, self.hero)
	end

	
end

function _State_TripleSlash:ReSetSpeed()
	--[[ 
		滑动距离由移动速度决定
		其不变时，攻速越快，滑动初速度越大，阻力加速度越大。
	]]
	
	-- self.speed = 255 * self.hero:GetAtkSpeed() * (self.hero:GetMovSpeed().x / 100 + 1)

	-- self.speed = 200 * (self.hero:GetMovSpeed().x / 100 + 1) -- 260
	
	
	-- self.speed = 200 * (self.hero:GetAtkSpeed() + 1) -- 260
	-- self.a = self.speed / self.hero:GetAtkSpeed() / 4 * 60
	-- self.slideX = 0
	
	
	self.speed = 180 * (self.hero:GetAtkSpeed() + 1) -- 260
	self.a = self.speed * 60 / 20 --  / self.hero:GetAtkSpeed()
	self.slideX = 0


	-- self.slideX = 120

	-- local t = 580 / (1000 * self.hero.atkSpeed) -- seconds
	-- print("movement: tripslash t = ", t)
	-- self.speed = 250 * (1 + self.hero:GetAtkSpeed()) -- 277
	-- self.a = self.speed / t
	
	-- self.a = self.speed * self.speed / (2 * self.slideX)
	
	
	-- self.a = 2 * self.slideX / (t * t)
	-- self.speed =  math.sqrt(2 * self.a * self.slideX)
	self.slideX = 0

	if self.a < 0 then
		self.a = - self.a
	end

	-- print("TripSlash Movement Args:")
	-- print("speed * dt =", self.speed, "a =", self.a)



	
	-- speed = baseSpeed * atkSpd -- 移动速度相对固定，因为只受攻击速度影响
	-- slideX = 固定值
	-- t = 580ms / (1000 * 动画播放加速倍数)  -- 单位:秒

	-- 推导加速度
	-- x = speed * t + a * t * t / 2 -- 一般方程 匀减速时 a < 0 
	-- x = 1 / 2 * a * t * t  -- 反过来看匀减速过程 即为从 v = 0 开始的匀加速
	-- a = 2 * x / (t * t) -- 由上式即可求出阻力加速度

end

function _State_TripleSlash:ChangeDir()
	
	local left = self.input:IsHold("LEFT")
	local right = self.input:IsHold("RIGHT")

	if left or right then
        if left and right then
            if self.time_left > self.time_right then
                self.nextDir = -1
            elseif self.time_left == self.time_right then
                self.nextDir = self.hero:GetDir()
            else 
                self.nextDir = 1
            end 
        elseif left then
			self.nextDir = -1
        else 
            self.nextDir = 1
        end
    end

	if self.input:IsPressed("left") then
        self.time_left = love.timer.getTime()
    end 
   
    if self.input:IsPressed("right") then
        self.time_right = love.timer.getTime()
    end 
	
end

return _State_TripleSlash 
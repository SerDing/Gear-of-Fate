--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_AtkBase  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_TripleSlash = require("Src.Core.Class")(_State_AtkBase)

local _HotKeyMgr = require "Src.Input.HotKeyMgr"

function _State_TripleSlash:Ctor()
	self.name = "tripleslash"
	self.skillID = 8
	self.childName ={
        "tripleslash1",
        "tripleslash2",
        "tripleslash3",
	} 
	self.attackNum = 0
	self.KEYID = {}
	self:_Init()
	
	self.time_left = 0
	self.time_right = 0
	self.a = 255
	self.slideX = 0 -- slide x distance accumulation
end 

function _State_TripleSlash:Enter(hero_)
    
	hero_:SetAnimation(self.childName[1])
	self.attackNum = 1
	self.attackName = self.childName[self.attackNum]
	self.nextDir = hero_:GetDir()
	self.slideX = 0
	----[[  Call base class function  ]] 
    self:_Enter(hero_)
    self:Effect("tripleslash/move1.lua", 1, 1)
	self:Effect("tripleslash/slash1.lua", 1, 1)
	self:ReSetSpeed()

	-- Get Components
	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.movement = hero_:GetComponent('Movement')
end

function _State_TripleSlash:Update(hero_,FSM_)

	self:_Update(FSM_) -- super class update

	self.KEYID = _HotKeyMgr.GetSkillKey(self.skillID)

	self:ChangeDir(FSM_)

	-- attack judgement
	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.attackName)
	end

	if self.attackNum == 1 then
		if self.heroBody:GetCount() >= 3 then
			if self.input:IsPressed(self.KEYID) then
				self:ChangeDir(FSM_)
				self.hero_:SetDir(self.nextDir)
				
				hero_:SetAnimation(self.childName[2])
				self.attackNum = 2

				self.atkJudger:ClearDamageArr()
				self.attackName = self.childName[self.attackNum]

				for n=1,#self.effect do
					self.effect[n].over = true
				end 
				
				for n=1,#self.effect do
					table.remove(self.effect,n)
				end 

				self:Effect("tripleslash/move2.lua", 1, 1)
				self:Effect("tripleslash/slash2.lua", 1, 1)
				self:ReSetSpeed()
			end 
		end 

	elseif self.attackNum == 2 then
		if self.heroBody:GetCount() >= 2 then
			if self.input:IsPressed(self.KEYID) then
				self:ChangeDir(FSM_)
				self.hero_:SetDir(self.nextDir)

				hero_:SetAnimation(self.childName[3])
				
				self.attackNum = 3

				self.atkJudger:ClearDamageArr()
				self.attackName = self.childName[self.attackNum]

				for n=1,#self.effect do
					self.effect[n].over = true
				end 
				
				for n=1,#self.effect do
					table.remove(self.effect,n)
				end 

				self:Effect("tripleslash/move2.lua", 1, 1)
				self:Effect("tripleslash/slash3.lua", 1, 1)
				self:ReSetSpeed()
			end 

		end 

	end 

	-- animation control
	-- if hero_:GetBody():GetCount() == 4 then
	-- 	hero_.animMap:Stop()
	-- end

	self:Movement(hero_, FSM_)

	for n=1,#self.effect do
        if self.effect[n] then
            self.effect[n].pos.x = hero_.pos.x
        end 
	end 
	
end 

function _State_TripleSlash:Exit(hero_)
	self:_Exit()
end

function _State_TripleSlash:Movement(hero_, FSM_)
	self.movement:X_Move(self.speed * hero_.dir)
	self.slideX = self.slideX + self.speed * self.dt

	-- self.speed = self.speed - self.a * self.dt
	-- print("movement:  tripslash move speed = ", self.speed)
	-- print("movement:  tripslash slideX = ", self.slideX)
	-- if self.speed < 0 then
	-- 	self.speed = 0
	-- end

	if self.slideX >= 120 then -- self.slideX >= 130   and self.speed > self.a    self.heroBody:GetCount() >= 3
		self.speed = self.speed - self.a * self.dt * hero_:GetAtkSpeed() / 1.5
		if self.speed < 0 then
			self.speed = 0	
		end

		print("movement:  tripslash move speed = ", self.speed)

		-- if self.speed == 0 and self.heroBody:GetCurrentPlayNum() == 0 then
		-- 	print("triplslash slide x = ", self.slideX)
		-- 	FSM_:SetState(FSM_.oriState, hero_)
		-- end
	end 
	
	-- if self.speed == 0 then
		
	-- 	FSM_:SetState(FSM_.oriState, hero_)
	-- end

	
end

function _State_TripleSlash:ReSetSpeed()
	--[[ 
		滑动距离由移动速度决定
		其不变时，攻速越快，滑动初速度越大，阻力加速度越大。
	]]
	
	-- self.speed = 255 * self.hero_:GetAtkSpeed() * (self.hero_:GetMovSpeed().x / 100 + 1)

	-- self.speed = 200 * (self.hero_:GetMovSpeed().x / 100 + 1) -- 260
	
	
	-- self.speed = 200 * (self.hero_:GetAtkSpeed() + 1) -- 260
	-- self.a = self.speed / self.hero_:GetAtkSpeed() / 4 * 60
	-- self.slideX = 0
	
	
	self.speed = 180 * (self.hero_:GetAtkSpeed() + 1) -- 260
	self.a = self.speed / self.hero_:GetAtkSpeed() / 6 * 60
	self.slideX = 0


	-- self.slideX = 120

	-- local t = 580 / (1000 * self.hero_.atkSpeed) -- seconds
	-- print("movement: tripslash t = ", t)
	-- self.speed = 250 * (1 + self.hero_:GetAtkSpeed()) -- 277
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

function _State_TripleSlash:ChangeDir(FSM_)
	
	local left = self.input:IsHold(FSM_.HotKeyMgr_.KEY["LEFT"])
	local right = self.input:IsHold(FSM_.HotKeyMgr_.KEY["RIGHT"])

	if left or right then
        if left and right then
            if self.time_left > self.time_right then
                self.nextDir = -1
            elseif self.time_left == self.time_right then
                self.nextDir = self.hero_:GetDir()
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
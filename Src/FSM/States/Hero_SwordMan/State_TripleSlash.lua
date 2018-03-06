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

local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_TripleSlash:Ctor()
	self.name = "tripleslash"
	self.childName ={
        "tripleslash1",
        "tripleslash2",
        "tripleslash3",
	} 
	self.attackNum = 0
	self.KEYID = {}
	self:AtkBase_Init()
	
	self.time_left = 0
	self.time_right = 0
end 

function _State_TripleSlash:Enter(hero_)
    
	hero_:SetAnimation(self.childName[1])
	self.attackNum = 1

	self.nextDir = hero_:GetDir()

----[[  Call base class function  ]]
    self:AtkBase_Enter(hero_)
    self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "tripleslash/move1.lua",0,1)
	self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "tripleslash/slash1.lua",0,1)
	self:ReSetSpeed()

	self.atkJudger = hero_:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.attackName = self.childName[self.attackNum]
end

function _State_TripleSlash:Update(hero_,FSM_)

	self:AtkBase_Update()

	self.KEYID["TripleSlash"] = hero_:GetSkillKeyID("TripleSlash")

	self:ChangeDir()

	-- attack judgement
	if hero_:GetAttackBox() then
		self.atkJudger:Judge(hero_, "MONSTER", self.attackName)
	end

	if self.attackNum == 1 then
		if self.heroBody:GetCount() >= 3 then
			if _KEYBOARD.Press(hero_.KEY[self.KEYID["TripleSlash"]]) then
				self:ChangeDir()
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

				self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "tripleslash/move2.lua",0,1)
				self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "tripleslash/slash2.lua",0,1)
				self:ReSetSpeed()
			end 
		end 
		hero_:X_Move(hero_.spd.x * self.speed * self.dt * hero_.dir )
		if self.heroBody:GetCount() >= 3 and self.speed >= 50 then
			self.speed = self.speed - 50 * hero_:GetAtkSpeed() / 1.5
		end 

	elseif self.attackNum == 2 then
		if self.heroBody:GetCount() >= 3 then
			if _KEYBOARD.Press(hero_.KEY[self.KEYID["TripleSlash"]]) then
				self:ChangeDir()
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

				self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "tripleslash/move2.lua",0,1)
				self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "tripleslash/slash3.lua",0,1)
				self:ReSetSpeed()
			end 

		end 
		
		hero_:X_Move(hero_.spd.x * self.speed * self.dt * hero_.dir )
		
		if self.heroBody:GetCount() >= 3 and self.speed >= 50 then
			self.speed = self.speed - 50 * hero_:GetAtkSpeed() / 1.5
		end 
	elseif self.attackNum == 3 then
		hero_:X_Move(hero_.spd.x * self.speed * self.dt * hero_.dir )
		
		if self.heroBody:GetCount() >= 3 and self.speed >= 50 then
			self.speed = self.speed - 50 * hero_:GetAtkSpeed() / 1.5
		end 
	end 

	for n=1,#self.effect do
        if self.effect[n] then
            self.effect[n].pos.x = hero_.pos.x
        end 
	end 
	
	

end 

function _State_TripleSlash:Exit(hero_)
	self:AtkBase_Exit()
	self:ReSetSpeed()
end

function _State_TripleSlash:ReSetSpeed()
	self.speed = 200 * self.hero_:GetAtkSpeed()
end

function _State_TripleSlash:ChangeDir()
	
	local left = _KEYBOARD.Hold(self.hero_.KEY["LEFT"])
	local right = _KEYBOARD.Hold(self.hero_.KEY["RIGHT"])

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

	if _KEYBOARD.Press("left") then
        self.time_left = love.timer.getTime()
    end 
   
    if _KEYBOARD.Press("right") then
        self.time_right = love.timer.getTime()
    end 
	
end

return _State_TripleSlash 
--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_HopSmash = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 
local _EffectMgr = require "Src.Scene.EffectManager" 

function _State_HopSmash:Ctor()
    self.jumpPower = 0
	self.jumpDir = ""
	self.jumpAttack = false
	self.effect = {}
	
	self.timer = 0.1
	self.time = 0
	self.period = 1
end 

function _State_HopSmash:Enter(hero_)
    self.name = "hopsmashready"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
	
	self.jumpDir = ""
	self.jumpPower = 12

	self.speed = self.jumpPower * 0.125

end

function _State_HopSmash:Update(hero_,FSM_)
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	if self.period == 1 then
		if self.time < self.timer then
			self.time = self.time + _dt
			print(self.time)
			return
		else 
			hero_.pakGrp.body:SetAnimation("hopsmash")
			hero_.pakGrp.weapon:SetAnimation("hopsmash")
			self.period = 2

			self.effect[1] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/sword.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir())	
			self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			
			self.effect[2] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/smash.lua",hero_.pos.x,hero_.pos.y + 1,1,hero_:GetDir())
			self.effect[2]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		end 
	end 
	
	if self.period == 1 then
		return  
	end 
------[[  Frezen animation action  ]]
	-- if _body:GetCount() == 3 then
	-- 	_gamePause = true
	-- end 

------[[  start jump  ]]
	
	if not self.jumpAttack then
		if self.jumpDir ~= "up" and self.jumpDir ~= "down" then
			if _body:GetCount() == 1 or _body:GetCount() == 8 then
				self.jumpDir = "up"
			end 
		end 
	end 
	
------[[	up and down logic in jump	]]
	
	if self.jumpDir == "up" then
		
		self.jumpPower = self.jumpPower - _dt * 40 * hero_:GetAtkSpeed()
		
		if self.jumpPower < 0 then
			self.jumpPower = 0
		end

		hero_.jumpOffset = hero_.jumpOffset - self.jumpPower

		if self.jumpPower <= 0 then
			self.jumpDir = "down"
		end
		

	elseif self.jumpDir == "down" then
		
		self.jumpPower = self.jumpPower + _dt * 50 * hero_:GetAtkSpeed()
		
		if hero_.jumpOffset < 0 then
			hero_.jumpOffset = hero_.jumpOffset + self.jumpPower + _dt
		end

		if hero_.jumpOffset >= 0 and not self.effect[3] and not self.effect[4]  then

			-- add blood smash
			self.effect[3] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubback1.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y - 1,1,hero_:GetDir())
			self.effect[4] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubfront1.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y + 1,1,hero_:GetDir())
			
			-- self.effect[3]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			-- self.effect[4]:GetAni():SetBaseRate(hero_:GetAtkSpeed())

			self.effect[5] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubback2.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y - 1,1,hero_:GetDir())
			self.effect[6] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "hopsmash/hopsmashsubfront2.lua",hero_.pos.x + 140 * hero_:GetDir(),hero_.pos.y + 1,1,hero_:GetDir())
			
			-- self.effect[5]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
			-- self.effect[6]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		else 
			-- if _body:GetCount() == 7 then
			-- 	for _,v in pairs(hero_.pakGrp) do
			-- 		v:SetFrame(7)
			-- 	end
			-- end
		end

	end 

	
	


------[[	move logic in jump	]]
	
	if hero_.jumpOffset <= 0 then
		hero_:X_Move( self.speed * hero_:GetAtkSpeed() * hero_.spd.x * hero_:GetDir())
	end 

	for n=1,2 do
		if self.effect[n] then
			self.effect[n].pos.x = hero_.pos.x
			self.effect[n].pos.y = hero_.pos.y + hero_.jumpOffset
		end 
	end 
	
	

	
end 

function _State_HopSmash:Exit(hero_)
    self.jumpDir = ""
	self.jumpAttack = false
	for n=1,#self.effect do
		self.effect[n] = nil
	end 

	self.time = 0
	self.period = 1
end

return _State_HopSmash 
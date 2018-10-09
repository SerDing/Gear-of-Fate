--[[
	Desc: Hero Class --> SwordMan
 	Author: Night_Walker
	Since: 2017-08-07 22:25:22
	Alter: 2017-08-09 01:53:21
	Docs:
		* used Finite State Machine to manage the states of hero.
		
]]
local _obj = require "Src.Scene.Object" 
local Hero_SwordMan = require("Src.Core.Class")(_obj)

-- Components
local _AniPack = require "Src.AniPack"
local _AnimGrp = require "Src.Animation.AnimGrp"
local _Weapon = require "Src.Heroes.Weapon"
local _FSM = require "Src.FSM.FSM_Hero"
local _AttackJudger = require "Src.Game.AttackJudger"
local _Input = require "Src.Input.Input"
local _Movement = require "Src.Components.Movement"

-- Models
local _HP_Model = require "Src.Components.Model.HP"

local HP_ModelUnitTest = require("Src.Components.Model.HP_UnitTest")

-- const
local _aniPath = {
"/Data/character/swordman/animation/",
"/Data/equipment/swordman/weapon/"
}

local _aniName = {"attack1", "attack2", "attack3","frenzy1","frenzy2","frenzy3","frenzy4",
"damage1","damage2","rest", "stay", "dash", "down", "move", "guard", "jump","jumpattack",
"getitem", "gorecross", "grab", "dashattack", "sit","hitback",	"hardattack", "hopsmash",
"hopsmashready","moonlightslash1","moonlightslash2","tripleslash1","tripleslash2","tripleslash3",
"summon1", "summon2", "upperslashafter", "flowmindtwoattack1", "outragebreakready", "outragebreakslash", 
}

local _name = {"body","weapon"}
local _pakNum = 2

function Hero_SwordMan:Ctor(x, y) --initialize
	self:SetType("HERO")
	self.pos = {x = x, y = y, z = 0}
	self.drawPos = {x = math.floor(x), y = math.floor(y), z = 0}
	self.spd = {x = 60 * 2.5, y = 35 * 2} -- 125 125

	--property
	self.property = require("Data/character/swordman/swordman")

	-- ints
	self.dir = 1
	self.Y = self.pos.y
	self.atkSpeed = 1.0 + 0.50 -- 0.26
	self.hitRecovery = 22.5 -- 45 65
	self.hitRecovery = 55 -- 45 65
	self.hitTime = 0
	self.actionStop = 170
	self.actionStopTime = 0

	-- string 
	self.camp = "HERO"
	self.subType = "HERO_SWORDMAN"
	self.atkMode = "normal" -- or frenzy

	-- bool
	self.hitStop = false
	self.AI = false
	self.dead = false

	self.buff = {
		["frenzy"] = {switch = false, ani = nil},
	}
	self.pakGrp = {
		["weapon"] = _Weapon.New(self.subType, self),
	}
	self.Models = {}
	self.Components = {}
	self.Models['HP'] = _HP_Model.New(120, 120)
	self.Models['MP'] = _HP_Model.New(120, 120, 0.325)
	self.Components['Movement'] = _Movement.New(self)
	self.Components['Weapon'] = _Weapon.New(self.subType, self)
	self.AttackJudger = _AttackJudger.New(self, self.subType)

	-- // fight with your own dark side
	-- local darkDepth = 50
	-- self.animMap:SetColor(darkDepth, darkDepth, darkDepth, 255)
	-- self.Components['Weapon']:SetSingle(true)
	
	self.Components['Weapon']:SetType("hsword", "lswd")  -- mainType, subType
	-- katana	katana	0001
	-- katana	katana	3201
	-- katana	lkatana	0004	0002
	-- hsword	lswd	0500	0100
	-- ssword	sswd	4200c	
	
	self.animMap = _AnimGrp.New()
	self.animMap:AddWidget("body")
	self.animMap:AddWidget("weapon_b1")
	self.animMap:AddWidget("weapon_b2")
	self.animMap:AddWidget("weapon_c1")
	self.animMap:AddWidget("weapon_c2")

	self.animMap:GetWidget("body"):SetFileNum(0001)

	for i = 1,#_aniName do
		self.animMap:GetWidget("body"):AddAnimation(strcat(_aniPath[1], _aniName[i]), 1, _aniName[i])
	end

	local _wpMainTp, _wpSubTp = self.Components['Weapon']:GetType()
	for i = 1,#_aniName do
		self.animMap:GetWidget("weapon_b1"):AddAnimation(strcat(_aniPath[2], _wpMainTp, "/", _wpSubTp, "/", _aniName[i]), 1, _aniName[i])
	end
	for i = 1,#_aniName do
		self.animMap:GetWidget("weapon_c1"):AddAnimation(strcat(_aniPath[2], _wpMainTp, "/", _wpSubTp, "/", _aniName[i]), 1, _aniName[i])
	end
	self.animMap:GetWidget("body"):SetBaseRate(self.atkSpeed)
	self.animMap:GetWidget("weapon_b1"):SetBaseRate(self.atkSpeed)
	self.animMap:GetWidget("weapon_c1"):SetBaseRate(self.atkSpeed)

	self.Components['Weapon']:SetRes("lswd", 0100)  -- subType, fileNum
	
	-- Components Models
	self.input = _Input.New(self)
	self.FSM = _FSM.New(self,"stay",self.subType)


	--------------- test ani file
	for n = 1,_pakNum do
		-- self.pakGrp[_name[n]]:SetPlayNum("outragebreakslash",-1)
		-- self.pakGrp[_name[n]]:SetAnimation("outragebreakslash")
		-- self.pakGrp[_name[n]]:SetPlayNum("down",-1)
		-- self.pakGrp[_name[n]]:SetAnimation("down")
		-- self.pakGrp[_name[n]]:NextFrame()
		-- self.pakGrp[_name[n]]:NextFrame()
	end
	-----------------------------
	self.extraEffects = {}
end

function Hero_SwordMan:Update(dt)

	if love.timer.getTime() - self.hitTime <= self.hitRecovery / 1000 then -- hit stop effect
		return
	else
		if self.hitStop then
			self.hitStop = false
		end
	end

	if love.timer.getTime() - self.actionStopTime <= self.actionStop / 1000 then -- action stop effect
		return
	end
	
	self.FSM:Update(self)
	self.input:Update(dt)
	self.animMap:Update(dt)

	for k,v in pairs(self.buff) do 
		if v.switch then
			v.ani:Update(dt)
		end 
	end

	for n = 1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Update  then
			self.extraEffects[n]:Update(dt)
		end 
	end 
	
	for n = #self.extraEffects,1,-1 do
		if self.extraEffects[n]:IsOver() then
			if self.extraEffects[n].Destroy then
				self.extraEffects[n]:Destroy()
			end
			self.extraEffects[n] = nil
			table.remove(self.extraEffects,n)
		end 
	end 

	for k,v in pairs(self.Models) do
		if v.Update then
			v:Update(dt)
		end
	end
	
	self.Y = self.pos.y

	-- HP_Model Unit Test
	-- HP_ModelUnitTest(self)
end

function Hero_SwordMan:Draw()
	
	for n=1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Draw and self.extraEffects[n].layer == 0 then
			self.extraEffects[n]:Draw()
		end 
	end 
	
	self.animMap:Draw(self.drawPos.x, self.drawPos.y + self.drawPos.z, 0, 1, 1)

	for k,v in pairs(self.buff) do
		if v.switch then
			v.ani:Draw(
				self.drawPos.x ,
				self.drawPos.y + self.drawPos.z
			)
		end 
	end 

	for n=1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Draw and self.extraEffects[n].layer == 1 then
			self.extraEffects[n]:Draw()
		end 
	end 
	
	-- love.graphics.circle("fill", self.drawPos.x, self.drawPos.y, 2.5, 10)

	-- if self.pos.z < 0 then
		-- love.graphics.circle("fill", self.drawPos.x, self.drawPos.y + self.pos.z, 2.5, 10)
		-- love.graphics.line(self.pos.x - 200, self.pos.y - 151, self.pos.x + 200, self.pos.y - 151)
	-- end

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(255, 255, 0, 255)
	-- love.graphics.print("初夏流光", self.drawPos.x, self.drawPos.y, 0, 1.5, 1.5) 
	love.graphics.setColor(r, g, b, a)
	
	self.AttackJudger:Draw()
	
end

function Hero_SwordMan:Damage()
	self.Models['HP']:Decrease(0.05)
end

function Hero_SwordMan:Die()
	self.dead = true
end

function Hero_SwordMan:SetPosition(x,y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.drawPos.x = math.floor(self.pos.x)
	self.drawPos.y = math.floor(self.pos.y)
end

function Hero_SwordMan:SetZ(z)
	self.pos.z = z or self.pos.z
	self.drawPos.z = math.floor(self.pos.z)
end

function Hero_SwordMan:GetZ()
	return self.pos.z
end

function Hero_SwordMan:SetDir(dir_)
	self.dir = dir_ 
	self.animMap:SetDir(dir_)
end

function Hero_SwordMan:SetAnimation(ani)
	self.animMap:SetAnimation(ani)
end

function Hero_SwordMan:NextFrame()
	self.animMap:NextFrame()
end

function Hero_SwordMan:SetScenePtr(ptr)
	assert(ptr,"Err: SetScenePtr() scene pointer is nil!")
	self.Components['Movement']:SetSceneRef(ptr)
end

function Hero_SwordMan:SetAttackMode(mode)
	self.atkMode = mode
end

function Hero_SwordMan:SetAtkSpeed(spd)
	self.atkSpeed = spd
	self.animMap:SetBaseRate(spd)
end

function Hero_SwordMan:SetHitTime(time)
	self.hitTime = time
	self.hitStop = true
end

function Hero_SwordMan:SetActionStopTime(time)
	self.actionStopTime = time
end

function Hero_SwordMan:GetDir()
	return self.dir
end

function Hero_SwordMan:GetPos()
	return self.pos
end

function Hero_SwordMan:GetDrawPos()
	return self.drawPos
end

function Hero_SwordMan:GetAtkSpeed()
	return self.atkSpeed
end

function Hero_SwordMan:GetMovSpeed()
	return self.spd
end

function Hero_SwordMan:GetY()
	return self.Y
end

function Hero_SwordMan:GetInput()
	return self.input
end

function Hero_SwordMan:GetBody()
	return self.animMap:GetWidget("body")
end

function Hero_SwordMan:GetWeapon()
	return self.Components['Weapon']
end

function Hero_SwordMan:GetAttackMode()
	return self.atkMode
end

function Hero_SwordMan:GetAttackBox()
	-- return self.pakGrp["weapon"]:GetAttackBox() or self.pakGrp["body"]:GetAttackBox()
	return self.animMap:GetAttackBox()
end

function Hero_SwordMan:GetAtkJudger()
	return self.AttackJudger
end

function Hero_SwordMan:GetHitRecovery()
	return self.hitRecovery
end

function Hero_SwordMan:GetProperty(key)
	return self.property[strcat("[", key, "]")]
end

function Hero_SwordMan:AddExtraEffect(effect)
	assert(effect,"Warning: Hero_SwordMan:AddExtraEffect() got a nil effect!")
	self.extraEffects[#self.extraEffects + 1] = effect
	self.extraEffects[#self.extraEffects]:SetLayerId(1000 + #self.extraEffects)
end

function Hero_SwordMan:GetSubType()
	return self.subType
end

function Hero_SwordMan:IsDead()
	return self.dead
end

function Hero_SwordMan:IsAI()
	return self.AI
end

function Hero_SwordMan:IsHitStop()
	return self.hitStop
end

function Hero_SwordMan:GetModel(tag)
	assert(self.Models[tag], "Hero_SwordMan:GetModel()  no model: " .. tag)
	return self.Models[tag]
end

function Hero_SwordMan:GetComponent(tag)
	assert(self.Components[tag], "Hero_SwordMan:GetComponent()  no component: " .. tag)
	return self.Components[tag]
end

return Hero_SwordMan
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

local _AniPack = require "Src.AniPack"
local _Weapon = require "Src.Heroes.Weapon"
local _FSM = require "Src.Heroes.States.FSM"
local _KEYBOARD = require "Src.Core.KeyBoard" 

-- const
local _path = {
"../Data/character/swordman/animation/",
"../Data/equipment/swordman/weapon/katana/"
}

local _aniName = {

	"attack1",
	"attack2",
	"attack3",
	
	"frenzy1",
	"frenzy2",
	"frenzy3",
	"frenzy4",
	
	"damage1",
	"damage2",
	"rest", -- idle stand calmly
	"stay", -- stand for fight
	"dash", -- run
	"down", -- fall down
	"move", -- walk
	"guard", -- use weapon to defend
	"jump",
	"jumpattack",
	"getitem", -- pick the item
	"gorecross", -- skill: cross slash 
	"grab", -- skill:use ghost_hand to pick an enemy and attack it

	"dashattack", -- attack when hero ran
	"sit",

	"hitback",	-- up slash action hit back enemy when hero was damaged
	"hardattack", -- use the sword with ghost attack enemy
	"hopsmash",
	"hopsmashready",

	"moonlightslash1",
	"moonlightslash2",

	"tripleslash1",
	"tripleslash2",
	"tripleslash3",

	"summon1", 
	"summon2", -- reckless 

	"upperslashafter",
}

local _name = {
	"body",
	"weapon"
}

local _pakNum = 2

local Scene_ = {} -- init a null Scene Pointer

local ffi = require("ffi")
local bit = require("bit")




function Hero_SwordMan:Ctor(x,y) --initialize
	self:SetType("HERO")
	self.pos = {x = x, y = y}
	self.spd = {x = 2.25, y = 2}
	self.dir = 1
	self.Y = self.pos.y
	self.camp = "HERO"

	self.subType = "HERO_SWORDMAN"

	self.jumpOffset = 0
	
	self.atkSpeed = 1.5

	self.atkMode = "normal" -- or frenzy

	self.KEY = {
		["UP"] = "up",
		["DOWN"] = "down",
		["LEFT"] = "left",
		["RIGHT"] = "right",
		
		["JUMP"] = "c",
		["ATTACK"] = "x",
		["UNIQUE"] = "z",
		["BACK"] = "v",

		["A"] = "a",
		["S"] = "s",
		["D"] = "d",
		["F"] = "f",
		["G"] = "g",
		["H"] = "h",

		["Q"] = "q",
		["W"] = "w",
		["E"] = "e",
		["R"] = "r",
		["T"] = "t",
		["Y"] = "y",
		
	}

	self.buff = {
		["frenzy"] = {switch = false,ani = nil},

	}

	self.pakGrp = {
		["body"] = _AniPack.New(),
		["weapon"] = _Weapon.New()
	}

	for n = 1,_pakNum do
		for k = 1,#_aniName do
			self.pakGrp[_name[n]]:AddAnimation(_path[n] .. _aniName[k],1,_aniName[k])
		end
		self.pakGrp[_name[n]]:SetBaseRate(self.atkSpeed)
	end
---- [[ Set some special animation play nums to -1(loop) ]]
	for n = 1,_pakNum do
		
		self.pakGrp[_name[n]]:SetPlayNum("rest",-1)
		self.pakGrp[_name[n]]:SetPlayNum("stay",-1)
		self.pakGrp[_name[n]]:SetPlayNum("dash",-1)

		self.pakGrp[_name[n]]:SetPlayNum("move",-1)
		self.pakGrp[_name[n]]:SetPlayNum("guard",-1)
		self.pakGrp[_name[n]]:SetPlayNum("sit",-1)
		
	end
	
	
	self.pakGrp.body:SetFileNum(0001)
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/katana/katana3201b.img",1)
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/katana/katana3201c.img",2)
	
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lkatana/lkatana0003b.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lkatana/lkatana0003c.img",2)

	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lswd/lswd0500b.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lswd/lswd0500c.img",2)

	-- self.pakGrp.weapon:SetSingle(true)
	
	self.FSM = _FSM.New(self,"stay")

---- [[test ani file]] 
	
	-- for n = 1,_pakNum do
	-- 	self.pakGrp[_name[n]]:SetPlayNum("summon2",-1)
	-- 	self.pakGrp[_name[n]]:SetAnimation("summon2")
	-- end
	
----
	self:InitSkillKeyList()
	self.extraEffects = {}
end

function Hero_SwordMan:Update(dt,screenOffset)
	
	_screenOffset = screenOffset

	self.FSM:Update(self)

	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Update(dt)
	end

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
			table.remove(self.extraEffects,n)
		end 
	end 

	

end

function Hero_SwordMan:Draw(screenOffset_x,screenOffset_y)
	
	for n=1,#self.extraEffects do
		if self.extraEffects[n].Draw and self.extraEffects[n].layer == 0 then
			self.extraEffects[n]:Draw(screenOffset_x, screenOffset_y)
		end 
	end 
	
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Draw(
			self.pos.x + screenOffset_x,
			self.pos.y + screenOffset_y + self.jumpOffset
		)
	end

	for k,v in pairs(self.buff) do
		if v.switch then
			v.ani:Draw(
				self.pos.x + screenOffset_x,
				self.pos.y + screenOffset_y + self.jumpOffset
			)
		end 
	end 

	for n=1,#self.extraEffects do
		if self.extraEffects[n].Draw and self.extraEffects[n].layer == 1 then
			self.extraEffects[n]:Draw(screenOffset_x, screenOffset_y)
		end 
	end 
	


	self.Y = self.pos.y + screenOffset_y
end

function Hero_SwordMan:UpdateAni()
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Update(dt)
	end
	
end

function Hero_SwordMan:X_Move(offset)
	local _dt = love.timer.getDelta()
	local _dir = (offset > 0) and -1 or 1

	Scene_:CheckEvent(self.pos.x + offset, self.pos.y)

	if Scene_:IsInMoveableArea(self.pos.x + offset, self.pos.y) then
		self.pos.x = self.pos.x + offset
	end
	
end

function Hero_SwordMan:Y_Move(offset)
	local _dt = love.timer.getDelta()
	local _dir = (offset > 0) and -1 or 1
	
	Scene_:CheckEvent(self.pos.x, self.pos.y + offset)

	if Scene_:IsInMoveableArea(self.pos.x, self.pos.y + offset) then
		self.pos.y = self.pos.y + offset
	end 

end

function Hero_SwordMan:SetPosition(x,y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
end

function Hero_SwordMan:SetDir(dir_)
	self.dir = dir_ 
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:SetDir(dir_)
	end
end

function Hero_SwordMan:SetScenePtr(ptr)
	assert(ptr,"Err: SetScenePtr() scene pointer is nil!")
	Scene_ = ptr
end

function Hero_SwordMan:SetAttackMode(mode)
	self.atkMode = mode

end

function Hero_SwordMan:GetDir()
	return self.dir
end

function Hero_SwordMan:GetAtkSpeed()
	return self.atkSpeed
end

function Hero_SwordMan:GetY()
	return self.Y
end

function Hero_SwordMan:GetBody()
	return self.pakGrp.body
end

function Hero_SwordMan:GetWeapon()
	return self.pakGrp.weapon
end

function Hero_SwordMan:GetAttackMode()
	return self.atkMode
end

function Hero_SwordMan:InitSkillKeyList()
	
	self.skillKeyList = {
		{"A", "HopSmash"}, 
		{"S", "GoreCross"}, 
		{"D", "Grab"},
		{"F","TripleSlash"},
		{"G","ReckLess"},
		{"H", "Frenzy"},
		
		{"E", "MoonLightSlash"},
	}
	
end

function Hero_SwordMan:GetSkillKeyID(skillName)
	
	for n=1,#self.skillKeyList do
		if self.skillKeyList[n][2] == skillName then
			return self.skillKeyList[n][1] 
		end 
	end 
	
end

function Hero_SwordMan:AddExtraEffect(effect)
	assert(effect,"Warning: Hero_SwordMan:AddExtraEffect() got a nil effect!")
	self.extraEffects[#self.extraEffects + 1] = effect
	self.extraEffects[#self.extraEffects]:SetLayerId(1000 + #self.extraEffects)
end

return Hero_SwordMan
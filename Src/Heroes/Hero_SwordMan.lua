--[[
	Desc: Hero Class --> SwordMan
 	Author: Night_Walker
	Since: 2017-08-07 22:25:22
	Alter: 2017-08-09 01:53:21
	Docs:
		* used Finite State Machine to manage the states of hero.
		
]]

local Hero_SwordMan = require("Src.Class")()

local _AniPack = require "Src.AniPack"
local _Weapon = require "Src.Heroes.Weapon"
local _FSM = require "Src.Heroes.States.FSM"
local _KEYBOARD = require "Src.Core.KeyBoard" 

-- const
local _path = {
"Src/Script/character/swordman/animation/",
"Src/Script/equipment/swordman/weapon/ssword/"
}

local _name = {
"body",
"weapon"
}

local _aniName = {
"rest", -- idle stand calmly
"stay", -- stand for fight
"dash", -- run
"down", -- fall down
"move", -- walk
"guard", -- use weapon to defend
"jump",
"jumpattack",
"getitem", -- pick the item
"grab", -- skill:use ghost_hand to pick an enemy and attack it

"dashattack", -- attack when hero ran
"sit",

"hitback",	-- up slash action hit back enemy when hero was damaged
"hardattack", -- use the sword with ghost attack enemy
"upperslashafter",

"attack1",
"attack2",
"attack3",
"damage1",
"damage2",




}

local _pakNum = 2

function Hero_SwordMan:Ctor(x,y) --initialize
	
	self.pos = {x = x, y = y}
	self.spd = {x = 3, y = 2}
	self.dir = 1

	self.camp = "HERO"

	self.jumpOffset = 0
	
	self.KEY = {
		["UP"] = "up",
		["DOWN"] = "down",
		["LEFT"] = "left",
		["RIGHT"] = "right",
		
		["JUMP"] = "c",
		["ATTACK"] = "x",
		["UNIQUE"] = "z",

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

	self.pakGrp = {
		["body"] = _AniPack.New(),
		["weapon"] = _Weapon.New()
	}

	for n = 1,_pakNum do
		for k = 1,#_aniName do
			self.pakGrp[_name[n]]:AddAnimation(_path[n] .. _aniName[k],-1,_aniName[k])
		end
	end

	for n = 1,_pakNum do
		self.pakGrp[_name[n]]:SetPlayNum("attack1",1)
		self.pakGrp[_name[n]]:SetPlayNum("attack2",1)
		self.pakGrp[_name[n]]:SetPlayNum("attack3",1)

		self.pakGrp[_name[n]]:SetPlayNum("jump",1)
		self.pakGrp[_name[n]]:SetPlayNum("jumpattack",1)

		self.pakGrp[_name[n]]:SetPlayNum("dashattack",1)
		self.pakGrp[_name[n]]:SetPlayNum("hitback",1)
	end
	
	
	self.pakGrp.body:SetFileNum(0001)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",2)
	
	self.pakGrp.weapon:SetSingle(true)
	
	self.FSM = _FSM.New(self,"rest")

-- test ani file 

	-- for n = 1,_pakNum do
	-- 	self.pakGrp[_name[n]]:SetAnimation("upperslashafter")
	-- end

end

function Hero_SwordMan:Update(dt)
	
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Update(dt)
	end

	self.FSM:Update(self)

end

function Hero_SwordMan:Draw(screenOffset)
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Draw(
			self.pos.x + screenOffset.x,
			self.pos.y + screenOffset.y + self.jumpOffset
		)
	end
end

--***************[[	 logic 	]]*********************

-- function Hero_SwordMan:Logic_Common()

-- end


function Hero_SwordMan:SetDir(dir_)
	self.dir = dir_ 
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:SetDir(dir_)
	end
end

function Hero_SwordMan:GetDir()
	return self.dir
end

function Hero_SwordMan:X_Move(offset)
	local _dt = love.timer.getDelta()
	self.pos.x = self.pos.x + offset
end

function Hero_SwordMan:Y_Move(offset)
	local _dt = love.timer.getDelta()
	self.pos.y = self.pos.y + offset
end

return Hero_SwordMan
--[[
	Desc: Hero Class --> SwordMan
 	Author: Night_Walker
	Since: 2017-08-07 22:25:22
	Alter: 2017-08-09 01:53:21
	Docs:
		*Write notes here even more
]]

local Hero_SwordMan = require("Src.Class")()

local _AniPack = require "Src.AniPack"
local _Weapon = require "Src.Weapon"
local _FSM = require "Src.FSM"  


-- const
local path = {
"Src/Script/character/swordman/animation/",
"Src/Script/equipment/swordman/weapon/ssword/"
}

local name = {
"body",
"weapon"
}

local aniName = {
"rest", -- idle stand calmly
"stay", -- stand for fight
"dash", -- run
"down", -- fall down
"move",
"guard", -- use weapon to defend
"jump",
"jumpattack",
"getitem", -- pick the item
"grab", -- skill:use ghost_hand to pick an enemy and attack it

"dashattack", -- attack when hero ran
"sit",

"hitback",
"hardattack", -- hard_attack

"attack1",
"attack2",
"attack3",
"damage1",
"damage2",

}

local pakNum = 2

function Hero_SwordMan:Ctor() --initialize

	self.pos = {x = 400, y = 300}
	self.spd = {x = 3, y = 2}

	self.pakGrp = {
		["body"] = _AniPack.New(),
		["weapon"] = _Weapon.New()
	}

	for n = 1,pakNum do
		for k = 1,#aniName do
			self.pakGrp[name[n]]:AddAnimation(path[n] .. aniName[k],-1,aniName[k])
		end
	end

	
	self.pakGrp.body:SetFileNum(0001)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",2)
	
	self.pakGrp.weapon:SetSingle(true)
	


	self.FSM = _FSM.New(self,"rest")


end

function Hero_SwordMan:Update(dt)
	
	for n=1,pakNum do
		self.pakGrp[name[n]]:Update(dt)
	end

	self.FSM:Update(self)

end

function Hero_SwordMan:Draw()
	for n=1,pakNum do
		self.pakGrp[name[n]]:Draw(self.pos.x,self.pos.y)
	end
end

function Hero_SwordMan:InputPress(key)
	self.key_press = key
end 

function Hero_SwordMan:InputRelease(key)
	self.key_release = key
end 

function Hero_SwordMan:SetDir(dir_)
	
	self.dir = dir_ 
	for n=1,pakNum do
		self.pakGrp[name[n]]:SetDir(dir_)
	end
end

return Hero_SwordMan
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


-- const
local path = {
"Src/Script/character/swordman/animation/",
"Src/Script/equipment/swordman/weapon/ssword/"
}
local name = {
"body",
"weapon"
}
local pakNum = 2

function Hero_SwordMan:Ctor() --initialize


	-- Resource Loading
	
	self.pakGrp = {
		["body"] = _AniPack.New(),
		["weapon"] = _Weapon.New()
	}

	for n=1,pakNum do
		self.pakGrp[name[n]]:AddAnimation(path[n] .. "attack3",-1,"attack3")
	end

	self.pakGrp.body:SetAnimation("attack3")
	self.pakGrp.body:SetFileNum(0001)

	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",2)
	self.pakGrp.weapon:SetSingle(true)
	self.pakGrp.weapon:SetAnimation("attack3")


	-- Data

	self.state0 = "idle"
	self.state = self.state0





end

function Hero_SwordMan:Update(dt)
	for n=1,pakNum do
		self.pakGrp[name[n]]:Update(dt)
	end
end

function Hero_SwordMan:Draw(x,y)
	for n=1,pakNum do
		self.pakGrp[name[n]]:Draw(x,y)
	end
end

return Hero_SwordMan
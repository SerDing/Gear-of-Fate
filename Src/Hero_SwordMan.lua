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

	self.state_ori = "stay"
	self.state = self.state_ori

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

	self.pakGrp.body:SetAnimation(self.state)
	self.pakGrp.body:SetFileNum(0001)

	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd4200c.img",2)
	self.pakGrp.weapon:SetSingle(true)
	self.pakGrp.weapon:SetAnimation(self.state)

end

function Hero_SwordMan:Update(dt)
	
	for n=1,pakNum do
		self.pakGrp[name[n]]:Update(dt)
	end

	if(self.pakGrp.body.playNum == 0)then
		self:SetState(self.state_ori)
	end 

	self:StateMachine()	

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

function Hero_SwordMan:StateMachine()
	
	if(self.state == "rest" or self.state == "stay")then 

		if(love.keyboard.isDown("up"))then
			self:SetState("move")
		end 
		
		if(love.keyboard.isDown("down"))then
			self:SetState("move")
		end 
		
		if(love.keyboard.isDown("left"))then
			self:SetState("move")
			self:SetDir(-1)
		end
		
		if(love.keyboard.isDown("right"))then
			self:SetState("move")
			self:SetDir(1)
		end
		
		
	elseif(self.state == "move")then
		if(love.keyboard.isDown("up"))then
			self.pos.y = self.pos.y - self.spd.y
		elseif(love.keyboard.isDown("down"))then
			self.pos.y = self.pos.y + self.spd.y
		end 

		if(love.keyboard.isDown("left"))then
			self.pos.x = self.pos.x - self.spd.x
			self:SetDir(-1)
		elseif(love.keyboard.isDown("right"))then
			self.pos.x = self.pos.x + self.spd.x
			self:SetDir(1)
		end
		
		if(love.keyboard.isDown("up") == false and
		love.keyboard.isDown("down") == false and
		love.keyboard.isDown("left") == false and
		love.keyboard.isDown("right") == false
		)then 
			self:SetState(self.state_ori)
		end 

	end 

end

function Hero_SwordMan:SetState(state_)
	
	if(self.state ~= state_)then
		self.state = state_
		self.pakGrp.body:SetAnimation(self.state)
		self.pakGrp.weapon:SetAnimation(self.state)
	else
		return
	end
end

function Hero_SwordMan:SetDir(dir_)
	
	self.dir = dir_      
	for n=1,pakNum do
		self.pakGrp[name[n]]:SetDir(dir_)
	end
end

return Hero_SwordMan
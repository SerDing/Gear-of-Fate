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
local _FSM = require "Src.FSM.FSM"
local _AttackJudger = require "Src.Game.AttackJudger"
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

local scene_ = {} -- init a null Scene Pointer

function Hero_SwordMan:Ctor(x,y) --initialize
	self:SetType("HERO")
	self.pos = {x = x, y = y}
	self.drawPos = {x = math.floor(x), y = math.floor(y)}
	self.spd = {x = 2.25, y = 2}
	self.dir = 1
	self.Y = self.pos.y
	self.camp = "HERO"
	self.subType = "HERO_SWORDMAN"

	self.jumpOffset = 0
	
	self.atkSpeed = 1.5

	self.atkMode = "normal" -- or frenzy

	self.hitRecovery = 45
	self.hitTime = 0

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
		["weapon"] = _Weapon.New(),
	}

	for n = 1,_pakNum do
		for k = 1,#_aniName do
			self.pakGrp[_name[n]]:AddAnimation(_path[n] .. _aniName[k],1,_aniName[k])
		end
		self.pakGrp[_name[n]]:SetBaseRate(self.atkSpeed)
	end
	

	self.pakGrp.body:SetFileNum(0001)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/katana/katana0001b.img",1)
	self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/katana/katana0001c.img",2)

	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/katana/katana3201b.img",1)
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/katana/katana3201c.img",2)
	
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lkatana/lkatana0004b.img",1)
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lkatana/lkatana0004c.img",2)

	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lswd/lswd0500b.img",1)
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/lswd/lswd0500c.img",2)

	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd/sswd4200c.img",1)
	-- self.pakGrp.weapon:SetFileNum("character/swordman/equipment/avatar/weapon/sswd/sswd4200c.img",2)
	-- self.pakGrp.weapon:SetSingle(true)
	
	self.FSM = _FSM.New(self,"stay",self.subType)

	self.AttackJudger = _AttackJudger.New(self.subType)

	---- [[test ani file]] 
	
	-- for n = 1,_pakNum do
	-- 	self.pakGrp[_name[n]]:SetPlayNum("summon2",-1)
	-- 	self.pakGrp[_name[n]]:SetAnimation("summon2")
	-- end
	
	----
	self:InitSkillKeyList()
	self.extraEffects = {}
end

function Hero_SwordMan:Update(dt)
	
	if love.timer.getTime() - self.hitTime <= self.hitRecovery / 1000 then -- hit stop effect
		return
	end

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
	
	self.Y = self.pos.y
end

function Hero_SwordMan:Draw()
	
	for n=1,#self.extraEffects do
		if self.extraEffects[n].Draw and self.extraEffects[n].layer == 0 then
			self.extraEffects[n]:Draw()
		end 
	end 
	
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Draw(
			self.drawPos.x ,
			self.drawPos.y + self.jumpOffset
		)
	end

	for k,v in pairs(self.buff) do
		if v.switch then
			v.ani:Draw(
				self.drawPos.x ,
				self.drawPos.y + self.jumpOffset
			)
		end 
	end 

	for n=1,#self.extraEffects do
		if self.extraEffects[n].Draw and self.extraEffects[n].layer == 1 then
			self.extraEffects[n]:Draw()
		end 
	end 
	
	love.graphics.circle("fill", self.drawPos.x, self.drawPos.y, 2.5, 10)

	if self.jumpOffset < 0 then
		-- love.graphics.circle("fill", self.drawPos.x, self.drawPos.y + self.jumpOffset, 2.5, 10)
		-- love.graphics.line(self.pos.x - 200, self.pos.y - 151, self.pos.x + 200, self.pos.y - 151)
	end

	self.AttackJudger:Draw()
	
end

function Hero_SwordMan:UpdateAni()
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Update(dt)
	end
	
end

function Hero_SwordMan:X_Move(offset)
	local _pass
	local _result
	local _next = self.pos.x + offset

	if scene_:IsInMoveableArea(_next, self.pos.y) then
		
		_result = scene_:IsInObstacles(_next, self.pos.y)
		
		if _result[1] then
			self:Y_Move(offset)
			if offset > 0 then
				_next = _result[2]:GetVertex()[1].x - 1
			else
				_next = _result[2]:GetVertex()[2].x + 1
			end
			_pass = false
		else
			_pass = true
		end
	else
		if offset > 0 then
			_next = scene_.map["[virtual movable area]"][1] + scene_.map["[virtual movable area]"][3] - 1
		else
			_next = scene_.map["[virtual movable area]"][1] + 1
		end
		_pass = false
	end

	self.pos.x = _next
	self.drawPos.x = math.floor(self.pos.x)
	scene_:CheckEvent(self.pos.x, self.pos.y)
	
end

function Hero_SwordMan:Y_Move(offset)

	local _result
	local _next = self.pos.y + offset

	if scene_:IsInMoveableArea(self.pos.x, _next) then
		
		_result = scene_:IsInObstacles(self.pos.x, _next)
		
		if _result[1] then
			if offset > 0 then
				_next = _result[2]:GetVertex()[1].y - 1
			elseif offset < 0 then
				_next = _result[2]:GetVertex()[2].y + 1
			end
		end
	
	else
		if offset > 0 then
			_next = scene_.map["[virtual movable area]"][2] + 200 + scene_.map["[virtual movable area]"][4] - 1
		else
			_next = scene_.map["[virtual movable area]"][2] + 200 + 1
		end
	end

	self.pos.y = _next
	self.drawPos.y = math.floor(self.pos.y)
	scene_:CheckEvent(self.pos.x, self.pos.y)

end

function Hero_SwordMan:SetPosition(x,y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.drawPos.x = math.floor(self.pos.x)
	self.drawPos.y = math.floor(self.pos.y)
end

function Hero_SwordMan:SetDir(dir_)
	self.dir = dir_ 
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:SetDir(dir_)
	end
end

function Hero_SwordMan:SetAnimation(ani)
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:SetAnimation(ani)
	end
end

function Hero_SwordMan:NextFrame()
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:NextFrame()
	end
end

function Hero_SwordMan:SetScenePtr(ptr)
	assert(ptr,"Err: SetScenePtr() scene pointer is nil!")
	scene_ = ptr
end

function Hero_SwordMan:SetAttackMode(mode)
	self.atkMode = mode
end

function Hero_SwordMan:SetAtkSpeed(spd)
	self.atkSpeed = spd
	for n = 1,_pakNum do
		self.pakGrp[_name[n]]:SetBaseRate(spd)
	end	
end

function Hero_SwordMan:SetHitTime(time)
	self.hitTime = time
end

function Hero_SwordMan:GetDir()
	return self.dir
end

function Hero_SwordMan:GetPos()
	return self.pos
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

function Hero_SwordMan:GetAttackBox()
	return self.pakGrp["weapon"]:GetAttackBox() or self.pakGrp["body"]:GetAttackBox()
end

function Hero_SwordMan:GetAtkJudger()
	return self.AttackJudger
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
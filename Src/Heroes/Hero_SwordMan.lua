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
local _FSM = require "Src.FSM.FSM_Hero"
local _AttackJudger = require "Src.Game.AttackJudger"
local _KEYBOARD = require "Src.Core.KeyBoard" 
local _Input = require "Src.Input.Input"

-- const
local _aniPath = {
"/Data/character/swordman/animation/",
"/Data/equipment/swordman/weapon/"
}

local _aniName = {"attack1", "attack2", "attack3","frenzy1","frenzy2","frenzy3","frenzy4",
"damage1","damage2","rest", "stay", "dash", "down", "move", "guard", "jump","jumpattack",
"getitem", "gorecross", "grab", "dashattack", "sit","hitback",	"hardattack", "hopsmash",
"hopsmashready","moonlightslash1","moonlightslash2","tripleslash1","tripleslash2","tripleslash3",
"summon1", "summon2", "upperslashafter", "flowmindtwoattack1",
}

local _name = {"body","weapon"}

local _pakNum = 2

local scene_ = {} -- init a null Scene Pointer

function Hero_SwordMan:Ctor(x,y) --initialize
	self:SetType("HERO")
	self.pos = {x = x, y = y, z = 0}
	self.drawPos = {x = math.floor(x), y = math.floor(y), z = 0}
	self.spd = {x = 60 * 2, y = 60 * 2} -- 125 125

	--property
	self.property = require("Data/character/swordman/swordman")


	self.weaponSound = {
		['hsword'] = {"R_SQUARESWDA","SQUARESWDB","R_SQUARESWDA_HIT","SQUARESWDB_HIT",},
		["mswd"] = {"R_MINERALSWDA","MINERALSWDB","R_MINERALSWDA_HIT","MINERAL_SWDB_HIT",},
		["katana"] = {"R_KATANAA","KATANAB","R_KATANAA_HIT","KATANAB_HIT",},
		["bswd"] = {"R_BEAMSWDA","BEAMSWDB","R_BEAMSWDA_HIT","BEAMSWDB_HIT",},
		["stick"] = {"R_STICKA","STICKB_01","R_STICKA_HIT","STICKB_HIT_01",},
	}

	-- ints
	self.dir = 1
	self.Y = self.pos.y
	self.atkSpeed = 1.25
	self.hitRecovery = 65 -- 45
	self.hitTime = 0
	self.actionStop = 170
	self.actionStopTime = 0

	-- string 
	self.camp = "HERO"
	self.subType = "HERO_SWORDMAN"
	self.atkMode = "normal" -- or frenzy

	-- bool
	self.hitStop = false
	-- map
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

	self.AI = false

	self.buff = {
		["frenzy"] = {switch = false, ani = nil},
	}

	self.pakGrp = {
		["body"] = _AniPack.New(),
		["weapon"] = _Weapon.New(self.subType),
	}

	--[[
		"/Data/character/swordman/animation/",
		"/Data/equipment/swordman/weapon/katana/"
	]]
	-- for n = 1,_pakNum do
	-- 	for k = 1,#_aniName do
	-- 		self.pakGrp[_name[n]]:AddAnimation(strcat(_aniPath[n], _aniName[k]), 1, _aniName[k])
	-- 	end
	-- 	self.pakGrp[_name[n]]:SetBaseRate(self.atkSpeed)
	-- end

	self.pakGrp.body:SetFileNum(0001)
	local darkDepth = 50
	-- self.pakGrp.body:SetColor(darkDepth, darkDepth, darkDepth, 255)
	-- self.pakGrp.weapon:SetColor(darkDepth, darkDepth, darkDepth, 255)
	self.pakGrp.weapon:SetRes("lswd", 0100)
	self.pakGrp.weapon:SetType("hsword", "lswd")
	-- katana	0001
	-- katana	3201
	-- lkatana	0004
	-- lswd		0500
	-- sswd		4200c
	-- self.pakGrp.weapon:SetSingle(true)

	for i = 1,#_aniName do
		self.pakGrp.body:AddAnimation(strcat(_aniPath[1], _aniName[i]), 1, _aniName[i])
	end

	local _wpMainTp, _wpSubTp = self.pakGrp.weapon:GetType()
	for i = 1,#_aniName do
		self.pakGrp.weapon:AddAnimation(strcat(_aniPath[2], _wpMainTp, "/", _wpSubTp, "/", _aniName[i]), 1, _aniName[i])
	end
	
	self.pakGrp.body:SetBaseRate(self.atkSpeed)
	self.pakGrp.weapon:SetBaseRate(self.atkSpeed)

	self.input = _Input.New(self)
	self.FSM = _FSM.New(self,"stay",self.subType)

	self.AttackJudger = _AttackJudger.New(self, self.subType)

	--------------- test ani file
	-- for n = 1,_pakNum do
	-- 	self.pakGrp[_name[n]]:SetPlayNum("summon2",-1)
	-- 	self.pakGrp[_name[n]]:SetAnimation("summon2")
	-- end
	-----------------------------
	self:InitSkillKeyList()
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
			self.extraEffects[n] = nil
			table.remove(self.extraEffects,n)
		end 
	end 
	
	self.Y = self.pos.y
end

function Hero_SwordMan:Draw()
	
	for n=1,#self.extraEffects do
		if self.extraEffects[n] and self.extraEffects[n].Draw and self.extraEffects[n].layer == 0 then
			self.extraEffects[n]:Draw()
		end 
	end 
	
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Draw(
			self.drawPos.x ,
			self.drawPos.y + self.drawPos.z
		)
	end

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

	self.AttackJudger:Draw()
	
end

function Hero_SwordMan:UpdateAni()
	for n=1,_pakNum do
		self.pakGrp[_name[n]]:Update(dt)
	end
	
end

function Hero_SwordMan:X_Move(offset)
	offset = offset * love.timer.getDelta()
	local _pass, _result
	local _next = self.pos.x + offset

	if scene_:IsInMoveableArea(_next, self.pos.y) then
		
		_result = scene_:IsInObstacles(_next, self.pos.y)
		
		if _result[1] then
			-- self:Y_Move(offset)
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
	offset = offset * love.timer.getDelta()
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

function Hero_SwordMan:SetZ(z)
	self.pos.z = z or self.pos.z
	self.drawPos.z = math.floor(self.pos.z)
end

function Hero_SwordMan:GetZ()
	return self.pos.z
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

function Hero_SwordMan:GetHitRecovery()
	return self.hitRecovery
end

function Hero_SwordMan:GetProperty(key)
	return self.property[strcat("[", key, "]")]
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
		{"R", "Ashenfork"},
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

function Hero_SwordMan:GetSubType()
	return self.subType
end

function Hero_SwordMan:IsAI()
	return self.AI
end

function Hero_SwordMan:IsHitStop()
	return self.hitStop
end

return Hero_SwordMan
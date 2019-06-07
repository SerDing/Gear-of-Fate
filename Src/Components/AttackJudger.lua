--[[
	Desc: attack judger
	Author: SerDing 
	Since: 2018-02-26 14:36:00 
	Last Modified time: 2019-6-1
	Docs: 
		* Draw() could be used to debug when there is a collision bug
		* Add attack info file before you using this class for new entity
		* Call ClearDamageArr() at the right time when you want to judge attack again
]]

local _AttackJudger = require("Src.Core.Class")()

local _ObjectMgr = require "Src.Scene.ObjectManager"
local _Collider = require "Src.Core.Collider"
local _Rect = require "Src.Core.Rect"
local _AUDIOMGR = require "Src.Audio.AudioManager"
local _EffectMgr = require "Src.Scene.EffectManager"

local _specialList = {"ATK_OBJ",} -- storage some entities with special types that do not need load AtkInfo

function _AttackJudger:Ctor(atker, entityType)
	self.damageArr = {}
	self.atker = atker
	self.Y = 0
	self.box_a = _Rect.New(0,0,1,1)
	self.box_b = _Rect.New(0,0,1,1)
	self.atkInfoArr = {}
	self:LoadAtkInfo(entityType)
	self.debug = false
	-- self.debug = true
end

--- @param atker table 
--- @param enemyType string
--- @param attackName string 
--- @param atkInfo table 
function _AttackJudger:Judge(atker, enemyType, attackName, atkInfo) 
	--[[
		objPointer      atker
		string 	        enemyType
		call example    Judge(hero_, "MONSTER")
	]]
	self.atker = atker
	local objArr =_ObjectMgr.GetObjects()
	local hit = false
	local hitRet = false
	local _atkInfo
	local enemy
	

	for n = 1, #objArr do
		if objArr[n] and objArr[n]:GetType() == enemyType then
			enemy = objArr[n] -- get pointer
			
			-- judge whether the monster is hit
			hit = false
			if not enemy:IsDead() then
				if not self:IsInDamageArr(enemy:GetId()) then
					if atkInfo then
						_atkInfo = atkInfo
					else
						_atkInfo = (self.atkInfoArr[attackName]) and self.atkInfoArr[attackName] or self.atkInfoArr["attack1"]
					end
					
					self.Y = _atkInfo["Y"] or self.atkY["default"]["Y"]
					if self:IsInY(enemy) then
						hit = self:IsHit(atker, enemy)
					end
				end
			end

			-- hit process
			if hit then
				-- print(attackName)
				enemy:Damage(atker.host or atker, _atkInfo)
				-- insert the enemy into hit array
				self.damageArr[#self.damageArr + 1] = enemy:GetId()
				-- set hit time to start hitStop
				atker:SetHitTime(love.timer.getTime())


				local _weaponSoundArr
				local _weaponHitInfo
				
				if atker:GetType() == "HERO" then
					local _WpMainType, _WpSubType = atker:GetWeapon():GetType()
					_weaponSoundArr = atker:GetProperty("weapon wav")
					_weaponSoundArr = _weaponSoundArr[_WpMainType]
					_weaponHitInfo = atker:GetProperty("weapon hit info")
					_weaponHitInfo = _weaponHitInfo[_WpMainType]
				end
				if atker:GetType() == "HERO" then
					local _hitWav = _atkInfo["[hit wav]"]
					if not _hitWav then
						_hitWav = _weaponSoundArr[3]
						if attackName == "dashattack" or attackName == "dashattackmultihit" then
							_hitWav = _weaponSoundArr[4]
						end
						
					end
					_AUDIOMGR.PlaySound(_hitWav)
				end

				local hitType = (_weaponHitInfo ~= nil) and _weaponHitInfo[1] or _atkInfo["[hit info]"]
				local hitDir = _atkInfo["[attack direction]"] or ""
				local animPath = self:GetEffectPath(hitType, hitDir)
				local enemyBodyCenter = {x = 0, y = 0}
				if _weaponHitInfo or _atkInfo["[hit info]"] then
					enemyBodyCenter.x = enemy:GetPos().x
					enemyBodyCenter.y = enemy:GetPos().y + enemy:GetZ() - enemy:GetBody():GetHeight() / 2
					local effect = _EffectMgr.ExtraEffect(animPath, enemy)
					effect:SetPos(enemyBodyCenter.x, enemyBodyCenter.y)
					effect:SetLayer(1)
				end
				
				
			end

			if not hitRet and hit == true then
				hitRet = true
			end

		end
		
	end

	return hitRet

end 

function _AttackJudger:IsHit(atker, enemy)
	
	local _damageBoxs
	local _attackBoxs

	local _atkPos
	local _oppPos
	local _atkScale
	local _oppScale

	-- get boxs data
	_attackBoxs = atker:GetAttackBox()
	_damageBoxs = enemy:GetDamageBox()
	
	if _damageBoxs then
		-- get position scale data of both sides
		_atkPos = atker:GetPos()
		_oppPos = enemy:GetPos()
		_atkScale = atker:GetBody():GetScale()
		_oppScale = enemy:GetBody():GetScale()
		
		-- collision detection
		for q=1, #_attackBoxs, 6 do
			
			self.box_a:SetPos(_atkPos.x + _attackBoxs[q] * atker:GetDir(), _atkPos.y + _atkPos.z + - _attackBoxs[q+2])
			self.box_a:SetSize(_attackBoxs[q+3] * _atkScale.x, -_attackBoxs[q+5] * _atkScale.y)
			self.box_a:SetDir(atker:GetDir())
			
			for w=1, #_damageBoxs, 6 do
				
				self.box_b:SetPos(_oppPos.x + _damageBoxs[w] * enemy:GetDir(),_oppPos.y + - _damageBoxs[w+2] + _oppPos.z)
				self.box_b:SetSize(_damageBoxs[w+3] * _oppScale.x, -_damageBoxs[w+5] * _oppScale.y)
				self.box_b:SetDir(enemy:GetDir())

				if _Collider.Rect_Rect(self.box_a, self.box_b) then
					return true
				end
			end
		end

		return false
	else
		return false
	end
	

end

function _AttackJudger:HitProcess(atker, enemy, ... )

end

function _AttackJudger:Draw() 
	
	if not self.debug then
		return
	end

	self.box_a:Draw()
	self.box_b:Draw()
	local _atkPos = self.atker:GetPos()
	love.graphics.line(_atkPos.x, _atkPos.y, _atkPos.x, _atkPos.y - (self.Y / 2))
	love.graphics.line(_atkPos.x, _atkPos.y, _atkPos.x, _atkPos.y + (self.Y / 2))

end

function _AttackJudger:IsInY(enemy)
	if math.abs( enemy:GetPos().y - self.atker:GetPos().y ) <= self.Y / 2 then
		return true
	end
	return false
end

function _AttackJudger:IsInDamageArr(obj_id, frame)
	for i=1,#self.damageArr do
		if self.damageArr[i] == obj_id then
			return true
		end
	end
	return false
end

function _AttackJudger:ClearDamageArr()
	self.damageArr = {}
end

local function NeedLoadAtkInfo(entityType)
	for i,v in ipairs(_specialList) do
		if entityType == v then
			print(v)
			return true
		end
	end
	return false
end

function _AttackJudger:LoadAtkInfo(entityType)
	
	if NeedLoadAtkInfo(entityType) then
		return
	end

	local _heroJob = ""
	local _filesPath = ""
	local _fileNameArr = {}
	if self.atker:GetType() == "HERO" then
		_heroJob = self.atker.property["[job]"]
		_heroJob = string.sub(_heroJob, 2, string.len(_heroJob) - 1)
		_filesPath = "Data/character/" .. _heroJob .. "/attackinfo/"
		_filesPath2 = "Data/character/" .. _heroJob .. "/attackinfo/"
		_fileNameArr = love.filesystem.getDirectoryItems(_filesPath2)
	end

	local k = ""
	for i,v in ipairs(_fileNameArr) do
		k = string.gsub(v, ".lua", "")
		self.atkInfoArr[k] = dofile(_filesPath .. v)
	end
	
	self.atkY = require(strcat(".Data.AtkJudger.AtkInfo.", entityType))
end

---@param hitType string
---@param hitDir string
function _AttackJudger:GetEffectPath(hitType, hitDir)
	local basePath = "/Data/common/hiteffect/animation/"
	local sizeStr = {"small", "large"}
	local path = ""

	if hitType == "[cut]" then
		if hitDir == "" then
			path = strcat(basePath, "slash", sizeStr[math.random(1, 2)], tostring(math.random(1, 3)), ".lua")
		else
			if hitDir == "[hit lift up]" then
				path = strcat(basePath, "slash", sizeStr[math.random(1, 2)], tostring(1), ".lua")
			elseif hitDir == "[hit horizon]" then
				path = strcat(basePath, "slash", sizeStr[math.random(1, 2)], tostring(2), ".lua")
			elseif hitDir == "[hit down]" then
				path = strcat(basePath, "slash", sizeStr[math.random(1, 2)], tostring(3), ".lua")
			end
		end
	elseif hitType == "[blow]" then
		path = strcat(basePath, "knock", sizeStr[math.random(1, 1)], ".lua") -- math.random(1, 2)
	end

	if path == "" then
		error("GetEffeetPath  hitDir = " .. hitDir)
	end

	return path
end

return _AttackJudger 
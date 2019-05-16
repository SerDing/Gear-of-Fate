--[[
	Desc: attack judger
	Author: Night_Walker 
	Since: 2018-02-26 14:36:00 
	Last Modified time: 2018-02-26 14:36:00 
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

function _AttackJudger:Judge(atker, enemyType, attackName, atkInfo) 
	--[[
		objPointer      atker
		string 	        enemyType
		call example    Judge(hero_,"MONSTER")
	]] 
	self.atker = atker
	local _objArr =_ObjectMgr.GetObjects()
	local _hit = false
	local _hitResult = false
	local _atkInfo
	local _enemy
	local _weaponSoundArr
	local _weaponHitInfo

	if atker:GetType() == "HERO" then
		local _WpMainType, _WpSubType = atker:GetWeapon():GetType()
		_weaponSoundArr = atker:GetProperty("weapon wav")
		_weaponSoundArr = _weaponSoundArr[_WpMainType]
		_weaponHitInfo = atker:GetProperty("weapon hit info")
		_weaponHitInfo = _weaponHitInfo[_WpMainType]
	end

	for n = 1, #_objArr do
		if _objArr[n] and _objArr[n]:GetType() == enemyType then
			_enemy = _objArr[n] -- get pointer
			
			-- judge whether the monster is hit
			_hit = false
			if not _enemy:IsDead() then
				if not self:IsInDamageArr(_enemy:GetId()) then
					if atkInfo then
						_atkInfo = atkInfo
					else
						_atkInfo = (self.atkInfoArr[attackName]) and self.atkInfoArr[attackName] or self.atkInfoArr["attack1"]
					end
					
					self.Y = _atkInfo["Y"] or self.atkY["default"]["Y"]
					if self:IsInY(_enemy) then
						_hit = self:IsHit(atker, _enemy)
					end
				end
			end

			-- hit process
			if _hit then
				-- print(attackName)
				_enemy:Damage(atker.host or atker, _atkInfo)
				self.damageArr[#self.damageArr + 1] = _enemy:GetId() -- insert the enemy into hit array
				atker:SetHitTime(love.timer.getTime()) -- set hit time to start hitStop

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

				local _aniPath = ""
				local _enemyBodyCenter = {x = 0, y = 0}
				local _effect = {}
				if _weaponHitInfo then
					_aniPath = self:RandomEffectPath(_weaponHitInfo[1])
				elseif _atkInfo["[hit info]"] then
					_aniPath = self:RandomEffectPath(_atkInfo["[hit info]"])
				end

				if _weaponHitInfo or _atkInfo["[hit info]"] then
					_enemyBodyCenter.x = _enemy:GetPos().x
					_enemyBodyCenter.y = _enemy:GetPos().y + _enemy:GetZ() - _enemy:GetBody():GetHeight() / 2
					_effect = _EffectMgr.ExtraEffect(_aniPath, _enemyBodyCenter.x, _enemyBodyCenter.y, 1, _enemy:GetDir(), _enemy)
					_effect:SetLayer(1)
				end

				
			end

			if not _hitResult and _hit == true then
				_hitResult = true
			end

		end
		
	end

	return _hitResult

end 

function _AttackJudger:IsHit(atker, _enemy)
	
	local _damageBoxs
	local _attackBoxs

	local _atkPos
	local _oppPos
	local _atkScale
	local _oppScale

	-- get boxs data
	_attackBoxs = atker:GetAttackBox()
	_damageBoxs = _enemy:GetDamageBox()
	
	if _damageBoxs then
		-- get position scale data of both sides
		_atkPos = atker:GetPos()
		_oppPos = _enemy:GetPos()
		_atkScale = atker:GetBody():GetScale()
		_oppScale = _enemy:GetBody():GetScale()
		
		-- collision detection
		for q=1, #_attackBoxs, 6 do
			
			self.box_a:SetPos(_atkPos.x + _attackBoxs[q] * atker:GetDir(), _atkPos.y + _atkPos.z + - _attackBoxs[q+2])
			self.box_a:SetSize(_attackBoxs[q+3] * _atkScale.x, -_attackBoxs[q+5] * _atkScale.y)
			self.box_a:SetDir(atker:GetDir())
			
			for w=1, #_damageBoxs, 6 do
				
				self.box_b:SetPos(_oppPos.x + _damageBoxs[w] * _enemy:GetDir(),_oppPos.y + - _damageBoxs[w+2] + _oppPos.z)
				self.box_b:SetSize(_damageBoxs[w+3] * _oppScale.x, -_damageBoxs[w+5] * _oppScale.y)
				self.box_b:SetDir(_enemy:GetDir())

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

function _AttackJudger:IsInY(_enemy)
	if math.abs( _enemy:GetPos().y - self.atker:GetPos().y ) <= self.Y / 2 then
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

function _AttackJudger:RandomEffectPath(hitType)
	local _path_1 = "/Data/common/hiteffect/animation/"
	local _size = {"small", "large"}
	if hitType == "[cut]" then
		return strcat(_path_1, "slash", _size[math.random(1, 2)], tostring(math.random(1, 3)), ".lua")
	elseif hitType == "[blow]" then 
		return strcat(_path_1, "knock", _size[math.random(1, 1)], ".lua") -- math.random(1, 2)
	end
	
end

return _AttackJudger 
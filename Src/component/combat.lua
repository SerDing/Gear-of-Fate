--[[
	Desc: Combat Component
	Author: SerDing 
	Since: 2018-02-26 14:36:00 
	Last Modified time: 2019-9-27
	Docs: 
		* Draw() could be used to debug when there is a collision bug
		* Add attack info file before you using this class for new entity
		* Call ClearDamageArr() at the right time when you want to judge attack again
]]

local _constEffectPathArr = {
	['[cut]'] = {
		['[hit lift up]'] = {
			"Data/common/hiteffect/animation/slashlarge1.ani",
			"Data/common/hiteffect/animation/slashsmall1.ani",
		},
		['[hit horizon]'] = {
			"Data/common/hiteffect/animation/slashlarge2.ani",
			"Data/common/hiteffect/animation/slashsmall2.ani",
		},
		['[hit down]'] = {
			"Data/common/hiteffect/animation/slashlarge3.ani",
			"Data/common/hiteffect/animation/slashsmall3.ani",
		},
	},
	['[blow]'] = {
		"Data/common/hiteffect/animation/knocklarge.ani",
		"Data/common/hiteffect/animation/knocksmall.ani",
	},
}

---@class Entity.Component.Combat : Entity.Component.Base
local _Combat = require("core.class")()

local _Collider = require "system.collider"
local _Rect = require "engine.graphics.drawable.rect"
local _AUDIOMGR = require "engine.audio"

local _specialList = {"ATK_OBJ",} -- storage some entities with special types that do not need load AtkInfo

function _Combat:Ctor(atker)
	self.enable = true
	self.damageArr = {}
	self.atker = atker
	self.box_a = _Rect.New(0,0,1,1)
	self.box_b = _Rect.New(0,0,1,1)
	self.atkInfoArr = {}
	self.debug = false
end

--- @param atker GameObject
--- @param enemyType string
--- @param attackName string 
--- @param atkInfo table for skill passive object
function _Combat:Judge(atker, enemyType, attackName, atkInfo) 
	
	if not self.enable then
		return false
	end
	
	self.atker = atker
	local entities = _ObjectMgr.GetObjects()
	local hit = false
	local hitRet = false
	local attackInfo
	local e
	
	for n = 1, #entities do
		if entities[n] and entities[n]:GetType() == enemyType then
			e = entities[n]
			
			-- judge whether the enemy is hit
			hit = false
			if not e.identity.dead then
				if not self:IsInDamageArr(e:GetId()) then
					attackInfo = atkInfo or self.atkInfoArr[attackName]
					hit = self:IsHit(atker, e)
				end
			end

			-- hit process
			if hit then
				e:Damage(atker.host or atker, attackInfo)
				self.damageArr[#self.damageArr + 1] = e:GetId()
				-- atker:SetHitTime(love.timer.getTime())
				atker.components.hitstop:Enter(atker.stats.hitstopTime or 80)

				local weaponSoundArr
				local weaponHitInfo
				
				if atker:GetType() == "character" then
					local weapon = atker.equipment:GetCurrentEqu("weapon")
					-- weaponSoundArr = atker.property.weapon_wav
					-- weaponSoundArr = weaponSoundArr[weapon.main_type]
					-- weaponHitInfo = atker.property.weapon_hit_info
					-- weaponHitInfo = weaponHitInfo[weapon.main_type]
				end
				if atker:GetType() == "character" then
					local hitWav = attackInfo["[hit wav]"]
					if not hitWav then
						hitWav = weaponSoundArr[3]
						if attackName == "dashattack" or attackName == "dashattackmultihit" then
							hitWav = weaponSoundArr[4]
						end
						
					end
					_AUDIOMGR.PlaySound(hitWav)
				end

				local hitType = (weaponHitInfo ~= nil) and weaponHitInfo[1] or attackInfo["[hit info]"]
				local hitDir = attackInfo["[attack direction]"]
				local animPath = self:GetEffectPath(hitType, hitDir)
				local enemyBodyCenter = {x = 0, y = 0}
				if weaponHitInfo or attackInfo["[hit info]"] then
					enemyBodyCenter.x = e:GetPos().x
					enemyBodyCenter.y = e:GetPos().y
					enemyBodyCenter.z = e.pos.z - e:GetBody():GetHeight() / 2
					local effect = _EffectMgr.NewEffect(animPath, e, false)
					effect:SetPos(enemyBodyCenter.x, enemyBodyCenter.y, enemyBodyCenter.z)
				end
			end

			if not hitRet and hit == true then
				hitRet = true
			end

		end
		
	end

	return hitRet
end 

function _Combat:IsHit(atker, enemy)
	
	local damageBoxs
	local attackBoxs

	local atkerPos
	local enemyPos
	local atkerScale
	local enemyScale

	-- get boxs data
	attackBoxs = atker:GetAttackBox()
	damageBoxs = enemy:GetDamageBox()
	
	if damageBoxs then
		-- get position scale data of both sides
		atkerPos = atker:GetPos()
		enemyPos = enemy:GetPos()
		atkerScale = atker:GetBody().scale
		enemyScale = enemy:GetBody().scale
		
		-- detect if attack area box collide with enemy damage area box
		for n=1, #attackBoxs, 6 do
			
			self.box_a:SetPosition(atkerPos.x + attackBoxs[n] * atker:GetDir(), atkerPos.y + - attackBoxs[n+1])
			self.box_a:SetSize(attackBoxs[n+3] * atkerScale.x, -attackBoxs[n+4] * atkerScale.y)
			self.box_a:SetDirection(atker:GetDir())
			
			for m=1, #damageBoxs, 6 do
				
				self.box_b:SetPosition(enemyPos.x + damageBoxs[m] * enemy:GetDir(),enemyPos.y + - damageBoxs[m+1])
				self.box_b:SetSize(damageBoxs[m+3] * enemyScale.x, -damageBoxs[m+4] * enemyScale.y)
				self.box_b:SetDirection(enemy:GetDir())

				if not _Collider.Collide(self.box_a, self.box_b) then
					return false
				end
			end
		end

		-- detect if attack side box collide with enemy damage side box
		for n=1, #attackBoxs, 6 do
			
			self.box_a:SetPosition(atkerPos.x + attackBoxs[n] * atker:GetDir(), atkerPos.y + atkerPos.z + - attackBoxs[n+2])
			self.box_a:SetSize(attackBoxs[n+3] * atkerScale.x, -attackBoxs[n+5] * atkerScale.y)
			self.box_a:SetDirection(atker:GetDir())
			
			for m=1, #damageBoxs, 6 do
				
				self.box_b:SetPosition(enemyPos.x + damageBoxs[m] * enemy:GetDir(),enemyPos.y + - damageBoxs[m+2] + enemyPos.z)
				self.box_b:SetSize(damageBoxs[m+3] * enemyScale.x, -damageBoxs[m+5] * enemyScale.y)
				self.box_b:SetDirection(enemy:GetDir())

				if _Collider.Collide(self.box_a, self.box_b) then
					return true
				end
			end
		end

		return false
	else
		return false
	end
	

end

function _Combat:HitProcess(atker, enemy, ...)
end

function _Combat:Draw() 
	if not self.debug then
		return
	end

	self.box_a:Draw(_, "line")
	self.box_b:Draw(_, "line")
end

function _Combat:IsInDamageArr(obj_id, frame)
	for i=1,#self.damageArr do
		if self.damageArr[i] == obj_id then
			return true
		end
	end
	return false
end

function _Combat:ClearDamageArr()
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

---@param atkType string
---@param atkDir string
function _Combat:GetEffectPath(atkType, atkDir)
	local path = ""

	if atkType == "[cut]" then
		path = _constEffectPathArr[atkType][atkDir][math.random(1, 2)]
	elseif atkType == "[blow]" then
		path = _constEffectPathArr[atkType][math.random(1, 2)]
	end

	return path
end

return _Combat 
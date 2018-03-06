--[[
	Desc: attack judger
	Author: Night_Walker 
	Since: 2018-02-26 14:36:00 
	Last Modified time: 2018-02-26 14:36:00 
	Docs: 
		* Write notes here even more 
]]

local _AttackJudger = require("Src.Core.Class")()

local _ObjectMgr = require "Src.Scene.ObjectManager"
local _Collider = require "Src.Core.Collider"
local _Rect = require "Src.Core.Rect"

function _AttackJudger:Ctor(entityType)
	
	self.damageArr = {}

	self.box_a = _Rect.New(0,0,1,1)
	self.box_b = _Rect.New(0,0,1,1)

	self:LoadAtkInfo(entityType)

end 

function _AttackJudger:Judge(attacker, opponent, attackName) 
	--[[
		attacker: a pointer
		opponent: a string
		call example: Judge(hero_,"MONSTER")
	]] 
	


	local _objArr =_ObjectMgr.GetObjects()
	local _hit = false
	local _atkInfo
	local _damageBoxs
	local _attackBoxs
	local _mon

	local _atkPos
	local _oppPos
	local _atkScale
	local _oppScale

	for n=1,#_objArr do
		if _objArr[n] and _objArr[n]:GetType() == opponent then
			-- get pointer
			_mon = _objArr[n]
			
			-- judge whether the monster is hit
			if _mon:IsDead() == false and not self:IsInDamageArr(_mon:GetId(), _frame) then
				-- get boxs data
				_attackBoxs = attacker:GetAttackBox()
				_damageBoxs = _mon:GetDamageBox()
				
				if _damageBoxs then
					-- log("damage boxs exists")

					-- get position scale data of both sides
					_atkPos = attacker:GetPos()
					_oppPos = _mon:GetPos()
					_atkScale = attacker:GetBody():GetScale()
					_oppScale = _mon:GetBody():GetScale()
					
					-- collision detection
					for q=1, #_attackBoxs, 6 do
						
						self.box_a:SetPos(_atkPos.x + _attackBoxs[q] * attacker:GetDir(), _atkPos.y + - _attackBoxs[q+2])
						self.box_a:SetSize(_attackBoxs[q+3] * _atkScale.x, -_attackBoxs[q+5] * _atkScale.y)
						self.box_a:SetDir(attacker:GetDir())
						
						for w=1, #_damageBoxs, 6 do
							
							self.box_b:SetPos(_oppPos.x + _damageBoxs[w] * _mon:GetDir(),_oppPos.y + - _damageBoxs[w+2] + _oppPos.z)
							self.box_b:SetSize(_damageBoxs[w+3] * _oppScale.x, -_damageBoxs[w+5] * _oppScale.y)
							self.box_b:SetDir(_mon:GetDir())

							_hit = _Collider.Rect_Rect(self.box_a, self.box_b)

							if _hit then
								break
							end
						end
						if _hit then
							break
						end
					end
					
				else
					_hit = false
				end
			else
				_hit = false
			end

			-- hit process
			if _hit == true then
				
				-- hit state process
				_atkInfo = (self.atkInfo[attackName]) and self.atkInfo[attackName] or self.atkInfo["default"]
				
				_mon:Damage(
					attacker, 
					_atkInfo["backPower"], 
					_atkInfo["backSpeed"], 
					_atkInfo["float"], 
					_atkInfo["bounce"]
				)
				
				-- insert the opponent into hit array
				self.damageArr[#self.damageArr + 1] = {
					_mon:GetId(), 
					attacker:GetBody():GetCount(), -- key frame
				}

				-- set hit time to start hitStop
				attacker:SetHitTime(love.timer.getTime())
			end


		end

	end
end 

function _AttackJudger:Draw() 
	
	-- self.box_a:Draw()
	-- self.box_b:Draw()

end

function _AttackJudger:IsInDamageArr(obj_id, frame)
	
	for i=1,#self.damageArr do
		if self.damageArr[i][1] == obj_id then
			return true
		else
			return false
		end
	end

end

function _AttackJudger:ClearDamageArr()
	self.damageArr = {}
end

function _AttackJudger:LoadAtkInfo(entityType)
	self.atkInfo = require("Data.AtkJudger.AtkInfo." .. entityType)
end

return _AttackJudger 
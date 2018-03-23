--[[
	Desc: state damage
	Author: Night_Walker 
	Since: 2018-02-26 14:25:46 
	Last Modified time: 2018-02-26 14:25:46 
	Docs: 
		* Write notes here even more 
]]

local _State_Damage = require("Src.Core.Class")()

function _State_Damage:Ctor()
	self.name = "damage"
	self.backPower = 0
	self.backSpeed = 0
	
	self.flyPower = 0
	self.jumpDir = "default"
	self.bounce = false
end 

function _State_Damage:Enter(entity, FSM_, damageInfo)
	
	local _hasDown
	if entity:GetBody():GetAniId() == "[down motion]" and self.jumpDir == "default" then
		_hasDown = true
	end
	
	local _motion = "[damage motion " .. tostring(math.random(1, 2)) .. "]"
	entity:SetAnimation(_motion)
	
	self.hit_recovery = entity.property["hit recovery"] or 1000
	-- self.hit_recovery = 800
	self.timer = 0

	
	self.backSpeed = damageInfo["backSpeed"] or 1
	self.bounce = damageInfo["bounce"] or self.bounce
	self.float = damageInfo["float"] or 6

	if self.float > 0 then
		if self.jumpDir == "up" or self.jumpDir == "down" then
			self.flyPower = self.float * 0.9 -- floating protection
		else
			self.flyPower = self.float
		end
		self.jumpDir = "up"

		entity:SetAnimation("[down motion]")
		self.bounce = true

		if _hasDown then
			self.flyPower = 2
			entity:SetAnimation("[down motion]")
			entity:NextFrame()
			entity:NextFrame()
			self.bounce = false
		end

	else
		self.backPower = damageInfo["backPower"]
		if self.jumpDir == "up" or self.jumpDir == "down" then
			self.flyPower = 2
			self.jumpDir = "up"
			self.backPower = self.backPower / 2
			entity:SetAnimation("[down motion]")
			entity:NextFrame()
		end
	end

end

function _State_Damage:Update(entity, FSM_)
	local _dt = love.timer.getDelta()
	self:BackEffect(entity)
	self:HitFlyEffect(entity, _dt)
	self:HitRecovery(entity, FSM_, _dt)
	
end 

function _State_Damage:Exit(entity)
    --body
end

function _State_Damage:BackEffect(entity)
	if self.backPower > 0 then
		self.backPower = self.backPower - self.backSpeed
		if self.backPower < 0 then
			self.backPower = 0
		end
		entity:X_Move(self.backPower * - entity:GetDir())
	end
end

function _State_Damage:HitFlyEffect(entity, _dt)
	if self.jumpDir == "up" then
		if self.flyPower > 0 then
			self.flyPower = self.flyPower - _dt * 15
			if self.flyPower < 0 then
				self.flyPower = 0
				self.jumpDir = "down"
				if entity:GetBody():GetAniId() ~= "[down motion]" then
					entity:SetAnimation("[down motion]")
				end
			end

			entity:SetZ(entity:GetZ() - self.flyPower * 1.2)
			entity:X_Move( - entity:GetDir() * self.backSpeed)
		end

	elseif self.jumpDir == "down" then
		self.flyPower = self.flyPower + _dt * 18
		if entity:GetZ() < 0 then
			entity:SetZ(entity:GetZ() + self.flyPower * 1.2)
			if entity:GetZ() > 0 then
				entity:SetZ(0)
				if self.bounce then
					self.bounce = false
					self.flyPower = self.flyPower * 0.35
					self.jumpDir = "up"
					self.timer = 0
				else
					self.jumpDir = "default"
					self.flyPower = 0
				end
			end
			entity:X_Move( - entity:GetDir() * self.backSpeed)
		end

	elseif self.jumpDir == "default" and entity:GetBody():GetAniId() == "[down motion]" then
		while entity:GetBody():GetCount() < 4 do
			entity:NextFrame()
			self.timer = 0
		end
	end
end

function _State_Damage:HitRecovery(entity, FSM_, _dt)
	if self.float == 0 then 
		self.timer = self.timer + _dt
		if self.timer >= self.hit_recovery / 1000 then 
			FSM_:SetState(FSM_.oriState, entity)
		end 
	end
end

return _State_Damage 
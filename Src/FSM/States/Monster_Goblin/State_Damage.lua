--[[
	Desc: state damage
	Author: Night_Walker 
	Since: 2018-02-26 14:25:46 
	Last Modified time: 2018-02-26 14:25:46 
	Docs: 
		* Write notes here even more 
]]

local _State_Damage = require("Src.Core.Class")()

local _AUDIOMGR = require "Src.Audio.AudioManager"

function _State_Damage:Ctor()
	self.name = "damage"
	self.push_V = 0
	self.push_A = 0
	self.stableFPS = 60

	self.lift_V = 0
	self.liftPower = 0
	self.dir_Y = "default"
	self.bounce = false
end 

function _State_Damage:Enter(entity, FSM_, damageInfo, obj)
	-- print("monster damage")
	local _hasDown
	if entity:GetBody():GetAniId() == "[down motion]" and self.dir_Y == "default" then
		_hasDown = true
	end
	
	local _motion = strcat("[damage motion ", tostring(math.random(1, 2)), "]")
	entity:SetAnimation(_motion)
	
	self.hit_recovery = entity.property["hit recovery"] or 1000
	self.hit_recovery = 800
	self.timer = 0
	self.timer2 = 0


	local _info = (self.lift_V > 0) and damageInfo["lift"] or damageInfo["push"]

	self.push_A = _info["backSpeed"] or 1
	-- self.bounce = _info["bounce"] or self.bounce
	self.bounce = (_info["float"] > 0) and true or false
	self.liftPower = _info["float"] * self.stableFPS or 0

	if self.liftPower > 0 then
		if self.dir_Y == "up" or self.dir_Y == "down" then
			self.lift_V = self.liftPower * 0.9 -- floating protection
			self.timer2 = 0
		else
			self.lift_V = self.liftPower
		end
		self.dir_Y = "up"

		entity:SetAnimation("[down motion]")
		self.bounce = true

	else -- no float effect
		self.push_V = _info["backPower"] * self.stableFPS
		if self.dir_Y == "up" or self.dir_Y == "down" then -- in air
			self.lift_V = 2
			self.dir_Y = "up"
			self.push_V = self.push_V / 2
			entity:SetAnimation("[down motion]")
			entity:NextFrame()

		end
	end

	if _hasDown then
		self.lift_V = self.liftPower * 0.2
		entity:SetAnimation("[down motion]")
		entity:NextFrame()
		entity:NextFrame()
		self.bounce = false
	end


	-- self.push_A = 5
	-- self.bounce = true

	-- self.liftPower = damageInfo["[lift up]"] or 0
	
	-- if damageInfo["[damage reaction]"] == "[down]" then -- damageInfo["[attack direction]"] == "[hit lift up]"  挑空
	-- 	self.lift_V = self.liftPower -- 无论是在空中 还是 在地面上 都应用真实的浮空力
	-- 	self.timer2 = 0
	-- 	self.dir_Y = "up" -- 强制变更为上升状态
	-- 	entity:SetAnimation("[down motion]") 

	-- else -- 非挑空

	-- 	if self.dir_Y == "up" or self.dir_Y == "down" then -- 只有怪物在空中时才应用真实的浮空力
	-- 		self.dir_Y = "up" -- 强制变更为上升状态
	-- 		self.lift_V = self.liftPower
	-- 		print("entity:GetZ() < 0  apply liftup power", self.lift_V)
	-- 		self.timer2 = 0
	-- 		entity:SetAnimation("[down motion]")
	-- 		entity:NextFrame()
	-- 	-- else
	-- 	-- 	self.lift_V = self.liftPower * 0.2 -- 否则 在地面上时 只给一个微小的浮空力
	-- 	end
	-- end

	-- -- self.bounce = true
	-- if _hasDown then
	-- 	self.lift_V = self.liftPower * 0.2
	-- 	entity:SetAnimation("[down motion]")
	-- 	entity:NextFrame()
	-- 	entity:NextFrame()
	-- 	self.bounce = false
	-- end

	-- self.push_V = damageInfo["[push aside]"] or 0

	-- ------------ X位移加速度计算-----------
	-- local t = 0
	-- local h = 0
	-- if self.dir_Y == "up" or self.dir_Y == "down" then
	-- 	t = self.lift_V / (15 * self.stableFPS) -- t1 = v / a 
	-- 	t = t * 2
	-- 	h = - entity:GetZ()
	-- 	t = t + math.sqrt(2 * h / (15 * self.stableFPS))
	-- 	self.push_A = self.push_V / t  -- a = v / t
	-- end
	
	-- ----------------------------------------
	
	local _damageSound = entity:GetProperty("[damage sound]")
	if _damageSound then
		_AUDIOMGR.PlaySound(_damageSound)
	end

end

function _State_Damage:Update(entity, FSM_)
	local _dt = love.timer.getDelta()

	-- if self.dir_Y == "default" then
	-- 	self:BackEffect(entity, _dt)
	-- end

	self:BackEffect(entity, _dt)
	
	if self.timer2 >= 0.016 * 3 then
		self:HitFlyEffect(entity, _dt)
	else
		self.timer2 = self.timer2 + _dt
	end

	self:HitRecovery(entity, FSM_, _dt)
	
end 

function _State_Damage:BackEffect(entity, _dt)
	if self.push_V > 0 then
		self.push_V = self.push_V - self.push_A * self.stableFPS
		-- self.push_V = self.push_V - self.push_A  * _dt * self.stableFPS
		
		if self.push_V < 0 then
			self.push_V = 0
		end
		-- print("BackEffect() self.push_V", self.push_V, "self.push_V * _dt",self.push_V * _dt)
		-- entity:X_Move(self.push_V * self.stableFPS * - entity:GetDir())
		entity:X_Move(- entity:GetDir() * self.push_V )
	end
end

function _State_Damage:HitFlyEffect(entity, _dt)
	if self.dir_Y == "up" then
		if self.lift_V > 0 then
			self.lift_V = self.lift_V - _dt * 15 * self.stableFPS -- v = v - at
			if self.lift_V < 0 then  -- v < 0
				self.lift_V = 0 -- v = 0
				self.dir_Y = "down"
				if entity:GetBody():GetAniId() ~= "[down motion]" then
					entity:SetAnimation("[down motion]")
				end
			end

			entity:SetZ(entity:GetZ() - self.lift_V * 1.2 * _dt) -- z = z - vt
			entity:X_Move( - entity:GetDir() * self.push_A * self.stableFPS) -- self.push_V  / 30 * self.stableFPS
		end

	elseif self.dir_Y == "down" then
		self.lift_V = self.lift_V + _dt * 15 * self.stableFPS
		if entity:GetZ() < 0 then -- on air
			
			entity:SetZ(entity:GetZ() + self.lift_V * 1.2  * _dt) -- fall down
			if entity:GetZ() >= 0 then -- on land 
				entity:SetZ(0) -- fix z to right boundary
				if self.bounce then -- judge bounce
					self.bounce = false
					self.lift_V = self.lift_V * 0.35
					self.dir_Y = "up"
					self.timer = 0
				else
					self.dir_Y = "default"
					self.lift_V = 0
				end
			end
			entity:X_Move( - entity:GetDir() * self.push_A * self.stableFPS) --* self.push_V / 30 * self.stableFPS 
		else -- has been on land then change entity to lying stage
			self.dir_Y = "default"
			self.lift_V = 0
			-- print("monster damage [dir_Y == down], entity:GetZ() >= 0")
		end

	elseif self.dir_Y == "default" and entity:GetBody():GetAniId() == "[down motion]" then
		while entity:GetBody():GetCount() < 4 do
			entity:NextFrame()
			-- self.timer = 0
		end
	end

	-- print("monster damage dir", self.dir_Y)
end

function _State_Damage:HitRecovery(entity, FSM_, _dt)
	if self.lift_V == 0 and entity:GetBody():GetAniId() ~= "[down motion]" then  --  self.liftPower == 0  
		self.timer = self.timer + _dt
		if self.timer >= self.hit_recovery / 1000 then 
			FSM_:SetState(FSM_.oriState, entity)
		end 
	else
		-- print("HitRecovery()  self.liftPower", self.liftPower)
	end
end

function _State_Damage:Exit(entity)
    --body
end

return _State_Damage 
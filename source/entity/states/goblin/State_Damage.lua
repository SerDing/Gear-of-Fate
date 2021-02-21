--[[
	Desc: state damage
	Author: SerDing 
	Since: 2018-02-26 14:25:46 
	Last Modified time: 2018-02-26 14:25:46 
	Docs: 
		* Write notes here even more 
]]

local _State_Damage = require("core.class")()

local _AUDIO = require "engine.audio"

function _State_Damage:Ctor(FSM, entity)
	self.FSM = FSM
	self._entity = entity
	
	self.name = "damage"
	self.push_V = 0
	self.push_A = 0
	self.stableFPS = 60

	self.up_a = 16 * self.stableFPS -- 14.75
	self.down_a = 16 * self.stableFPS

	self.lift_V = 0
	self.liftPower = 0
	self.dir_Y = "null"
	self.bounce = false

	self.acfactor = 1.1 -- acceleration factor
end 

function _State_Damage:SetDamageAnimR()
	local _motion = "damage" .. tostring(math.random(1, 2))
	self.avatar:Play(_motion)
end

function _State_Damage:Enter(damageInfo, obj)

	--[[
		subaerial(在陆上)
			["[damage reaction]"] == "[down]"
				spd_z = [lift up];  spd_x = [push aside] / 60 (匀速)

			["[damage reaction]"] == "[damage]" or "[hit down]"
				spd_x = [push aside] (匀减速)
 
		aerial(在空中)
			["[damage reaction]"] == "[damage]" or "[down]"
				spd_z = spd_z + [lift up];  spd_x = [push aside] / 60 (匀速)

		damage方法 逻辑整理
		记录是否已倒地
		随机播放[damage motion x]
		读取并存储[hitRecovery]
		重置两个timer = 0
		从damageInfo里获取 [lift](在空中) 和 [push](在地上) 两组数据
		
	]]

	local _hasDown = self:IsDown()
	
	self:SetDamageAnimR(self._entity)
	
	self.hit_recovery = self._entity.property["hit recovery"] or 1000
	self.hit_recovery = 800
	self.timer = 0
	self.timer2 = 0

	local info = (self.lift_V > 0) and damageInfo["lift"] or damageInfo["push"]

	self.push_A = info["backSpeed"]
	-- self.bounce = _info["bounce"] or self.bounce
	self.bounce = (info["float"] > 0) and true or false
	self.liftPower = info["float"] * self.stableFPS * 1.15

	if self.liftPower > 0 then
		if self.dir_Y == "up" or self.dir_Y == "down" then
			self.lift_V = self.liftPower * 0.9 -- floating protection
			self.timer2 = 0
		else
			self.lift_V = self.liftPower
		end
		self.dir_Y = "up"

		self.avatar:Play("down")
		self.bounce = true
		
	else -- no float effect
		self.push_V = info["backPower"] * self.stableFPS
		if self.dir_Y == "up" or self.dir_Y == "down" then -- in air
			self.lift_V = 2
			self.dir_Y = "up"
			-- self.push_V = self.push_V / 2
			self.avatar:Play("down")
			self.avatar:NextFrame()

		end
	end

	if _hasDown then
		self.lift_V = self.liftPower * 0.2
		self.avatar:Play("down")
		self.avatar:NextFrame()
		self.avatar:NextFrame()
		self.bounce = false
	end

	
	--[[
		受击对象站立情况下(subaerial)  是否应用 [lift up] 要看 if [attack direction] == "hit lift up"
		非站立情况下 即 浮空时（aerial）   无视 [attack direction] 直接应用 [lift up] 
		if not self.entity.IsFloat() then -- is on land
			if(damageInfo['[attack direction]'] == 'hit horizen')
			
			end
		end
	]]

	-- ----------------------------------------------------
	-- self.push_A = 5
	-- self.bounce = true

	-- self.liftPower = damageInfo["[lift up]"] or 0
	
	-- if damageInfo["[damage reaction]"] == "[down]" then -- damageInfo["[attack direction]"] == "[hit lift up]"  挑空
	-- 	self.lift_V = self.liftPower -- 无论是在空中 还是 在地面上 都应用真实的浮空力
	-- 	self.timer2 = 0
	-- 	self.dir_Y = "up" -- 强制变更为上升状态
	-- 	self.entity.avatar:Play("down") 

	-- else -- 非挑空

	-- 	if self.dir_Y == "up" or self.dir_Y == "down" then -- 只有怪物在空中时才应用真实的浮空力
	-- 		self.dir_Y = "up" -- 强制变更为上升状态
	-- 		self.lift_V = self.liftPower
	-- 		print("self.entity.pos.z < 0  apply liftup power", self.lift_V)
	-- 		self.timer2 = 0
	-- 		self.entity.avatar:Play("down")
	-- 		self.entity.avatar:NextFrame()
	-- 	-- else
	-- 	-- 	self.lift_V = self.liftPower * 0.2 -- 否则 在地面上时 只给一个微小的浮空力
	-- 	end
	-- end

	-- -- self.bounce = true
	-- if _hasDown then
	-- 	self.lift_V = self.liftPower * 0.2
	-- 	self.entity.avatar:Play("down")
	-- 	self.entity.avatar:NextFrame()
	-- 	self.entity.avatar:NextFrame()
	-- 	self.bounce = false
	-- end

	-- self.push_V = damageInfo["[push aside]"] or 0

	-- ------------ X位移加速度计算-----------
	-- local t = 0
	-- local h = 0
	-- if self.dir_Y == "up" or self.dir_Y == "down" then
	-- 	t = self.lift_V / (15 * self.stableFPS) -- t1 = v / a 
	-- 	t = t * 2
	-- 	h = - self.entity.pos.z
	-- 	t = t + math.sqrt(2 * h / (15 * self.stableFPS))
	-- 	self.push_A = self.push_V / t  -- a = v / t
	-- end
	
	-- ----------------------------------------
	
	local damageSound = self._entity.data.voice.damage
	if damageSound then
		_AUDIO.PlaySound(damageSound)
	end

end

function _State_Damage:Update(dt)
	local _dt = love.timer.getDelta()

	-- if self.dir_Y == "null" then
	-- 	self:BackEffect(self.entity, _dt)
	-- end

	self:BackEffect(_dt)
	
	if self.timer2 >= 0.016 * 3 then
		self:HitFlyEffect(_dt)
	else
		self.timer2 = self.timer2 + _dt
	end

	self:HitRecovery(_dt)

	-- death check
	
	if self.dir_Y == "null" and self._entity.Models["HP"]:GetCur() <= 0 then
		self.FSM:SetState("die", self._entity)
	end


end 

function _State_Damage:BackEffect(_dt)
	if self.push_V > 0 then
		self.push_V = self.push_V - self.push_A * self.stableFPS
		-- self.push_V = self.push_V - self.push_A  * _dt * self.stableFPS
		
		if self.push_V < 0 then
			self.push_V = 0
		end
		-- print("BackEffect() self.push_V", self.push_V, "self.push_V * _dt",self.push_V * _dt)
		-- self.entity:X_Move(self.push_V * self.stableFPS * - self.entity:GetDir())
		self._entity:X_Move(- self._entity:GetDir() * self.push_V )
	end
end

function _State_Damage:HitFlyEffect(_dt)
	if self.dir_Y == "up" then
		if self.lift_V > 0 then
			self.lift_V = self.lift_V - _dt * self.up_a * self.acfactor -- v = v - at
			if self.lift_V <= 0 then  -- v < 0   self.lift_V < 80 / 60
				-- self.lift_V = 0 -- v = 0
				self.lift_V = - self.lift_V
				self.dir_Y = "down"
				if self._entity:GetBody().aniID ~= "down" then
					self.avatar:Play("down")
				end
			end

			self._entity:SetZ(self._entity.pos.z - self.lift_V * 1.2 * _dt) -- z = z - vt
			self._entity:X_Move( - self._entity:GetDir() * self.push_A * self.stableFPS) -- self.push_V  / 30 * self.stableFPS
		end

	elseif self.dir_Y == "down" then
		self.lift_V = self.lift_V + _dt * self.down_a * self.acfactor
		if self._entity.pos.z < 0 then -- on air
			
			self._entity:SetZ(self._entity.pos.z + self.lift_V * 1.2  * _dt) -- fall down
			if self._entity.pos.z >= 0 then -- on land 
				self._entity:SetZ(0) -- fix z to right boundary
				if self.bounce then -- judge bounce
					self.bounce = false
					self.lift_V = self.lift_V * 0.5
					self.dir_Y = "up"
					self.timer = 0
				else
					self.dir_Y = "null"
					self.lift_V = 0
				end
			end
			self._entity:X_Move( - self._entity:GetDir() * self.push_A * self.stableFPS) --* self.push_V / 30 * self.stableFPS 
		else -- has been on land then change self.entity to lying stage
			self.dir_Y = "null"
			self.lift_V = 0
		end

	elseif self.dir_Y == "null" and self._entity.avatar:GetPart().aniID == "down" then
		while self._entity.avatar:GetPart():GetFrame() < 4 do
			self.avatar:NextFrame()
			-- self.timer = 0
		end
	end
end

function _State_Damage:HitRecovery(_dt)
	if self.lift_V == 0 and self._entity:GetBody().aniID ~= "down" then  --  self.liftPower == 0  
		self.timer = self.timer + _dt
		if self.timer >= self.hit_recovery / 1000 then 
			self.FSM:SetState(self.FSM.oriState, self._entity)
		end 
	else
		-- print("HitRecovery()  self.liftPower", self.liftPower)
	end
end

function _State_Damage:IsDown()
	if self._entity:GetBody().aniID == "down" and self.dir_Y == "null" then
		return true
	end
	return false
end

function _State_Damage:Exit()
    --body
end

return _State_Damage 
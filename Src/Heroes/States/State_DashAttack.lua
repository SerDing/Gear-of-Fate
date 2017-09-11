--[[
	Desc: DashAttack state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of DashAttack state in this class
]]

local _State_DashAttack = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard"

function _State_DashAttack:Ctor()
    --body
end 

function _State_DashAttack:Enter(hero_)
    self.name = "dashattack"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
	self.attackCount = 1
end

function _State_DashAttack:Update(hero_,FSM_)
    
	--AttackCheck()
	-- local _bodyAtkBox = _body:GetAttackBox()
	-- if _bodyAtkBox then
	-- 	_ATK_CHECK:CollisionDetection(_bodyAtkBox)
	-- end 
	

	local _body = hero_.pakGrp.body
	local _dt = love.timer.getDelta()

	
	if _body:GetCount() >= 2 and _body:GetCount() <= 4 then
		
		if self.attackCount == 1 then
			hero_:X_Move(hero_.spd.x * 50 * _dt * hero_.dir )
		elseif self.attackCount == 2 then
			hero_:X_Move(hero_.spd.x * 100 * _dt * hero_.dir )
		end 
		
	end 

	if _body:GetCount() > 4 then
		if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and self.attackCount <2 then
			hero_.pakGrp.body:SetFrame(0)
			hero_.pakGrp.weapon:SetFrame(0)
			self.attackCount = self.attackCount + 1
		end 
		
	end 



end 

function _State_DashAttack:Exit(hero_)
    --body
end

return _State_DashAttack 
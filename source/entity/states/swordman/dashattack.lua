--[[
	Desc: DashAttack state 
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of DashAttack state in this class
]]
local _Base  = require "entity.states.base"
local _State_DashAttack = require("core.class")(_Base)

function _State_DashAttack:Ctor(...)
	_Base.Ctor(self, ...)
	self.attackName = {"dashattack","dashattackmultihit"}
end 

function _State_DashAttack:Enter()
	_Base.Enter(self)
	self.name = "dashattack"
	self._process = 1
	
	self.avatar:Play(self.name)
	self.combat:ClearDamageArr()
end

function _State_DashAttack:Update()

	if self.body:GetFrame() >= 2 and self.body:GetFrame() <= 4 then
		if self._process == 1 then
			self.movement:X_Move(self._entity.spd.x * 2 * self._entity.transform.direction )
		elseif self._process == 2 then
			self.movement:X_Move(self._entity.spd.x * 4 * self._entity.transform.direction )
		end 
	end 

	if self.body:GetFrame() > 3 and self.body:GetFrame() < 8 then -- 
		if self.input:IsPressed("ATTACK") and self._process == 1 then
			self.avatar:SetFrame(2)
			self._process = self._process + 1
			self.combat:ClearDamageArr()
		end 
	end 

	if self.body:GetFrame() == 2 and not self.effect[1] and self._process > 1 then
		-- _Base.Effect(self, "dashattackmultihit1.ani")
		-- _Base.Effect(self, "dashattackmultihit2.ani")
	end

	-- if self._entity:GetAttackBox() then
	-- 	self.combat:Judge(self._entity, "MONSTER", self.attackName[self._process])
	-- end
	
end 

function _State_DashAttack:Exit()
	_Base.Exit(self)
end

return _State_DashAttack 
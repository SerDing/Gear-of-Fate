--[[
	Desc: UpperSlash state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of UpperSlash state in this class
]]
local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_UpperSlash = require("Src.Core.Class")(base)

function _State_UpperSlash:Ctor(...)
	base.Ctor(self, ...)
	self.name = "upperslash"
	self.skillID = 46
	self.effect = {}
	self.smooth = 1.2
end 

function _State_UpperSlash:Enter()
	self.hero:Play("hitback")
	self.atkJudger = self.hero:GetAtkJudger()
	self.atkJudger:ClearDamageArr()
	self.movement = self.hero:GetComponent('Movement')
	self.input = self.hero:GetComponent("Input")
	base.Enter(self)
end

function _State_UpperSlash:Update()
    local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()

	local _movable = true

    if (self.input:IsHold("LEFT") and self.hero.dir == 1) or
    (self.input:IsHold("RIGHT") and self.hero.dir == -1) then
        _movable = false
    end

	if _movable then
		if _body:GetCount() >= 2 and _body:GetCount() <=4 then
			self.movement:X_Move(self.hero.spd.x * self.smooth * self.hero.dir )
		end 
		if (self.input:IsHold("LEFT") and self.hero.dir == -1 ) or
		(self.input:IsHold("RIGHT") and self.hero.dir == 1 )   then
			
			self.movement:X_Move(self.hero.spd.x * self.smooth * 0.5 * self.hero.dir )
		end 
		if self.effect[1] then
			--self.effect[1].pos.x = self.effect[1].pos.x + _dt * self.hero.spd.x * self.smooth * self.hero.dir
			self.effect[1]:SetPos(self.hero.pos.x)
		end 
	end

	if _body:GetCount() == 2 and not self.effect[1] then
		self:Effect("upperslash1.lua")
	end 
	
	if self.hero:GetAttackBox() then
		self.atkJudger:Judge(self.hero, "MONSTER", self.name)
	end

end 

function _State_UpperSlash:Exit()
    self.effect[1] = nil
end

return _State_UpperSlash 
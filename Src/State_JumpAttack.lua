--[[
	Desc: JumpAttack state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of JumpAttack state in this class
]]

local _State_JumpAttack = require("Src.Class")()

function _State_JumpAttack:Ctor()
    --body
end 

function _State_JumpAttack:Enter(hero_)
    self.name = "jumpattack"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
	
end

function _State_JumpAttack:Update(hero_,FSM_)
    hero_:Logic_JumpAttack()
end 

function _State_JumpAttack:Exit(hero_)
    --body
end

return _State_JumpAttack 
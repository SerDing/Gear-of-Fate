--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_Tmp = require("Src.Class")()

function _State_Tmp:Ctor()
    --body
end 

function _State_Tmp:Enter(hero_)
    self.name = "tmp"
	hero_:GetBody():SetAnimation(self.name)
	hero_:GetWeapon():SetAnimation(self.name)
	
end

function _State_Tmp:Update(hero_,FSM_)
    --body
end 

function _State_Tmp:Exit(hero_)
    --body
end

return _State_Tmp 
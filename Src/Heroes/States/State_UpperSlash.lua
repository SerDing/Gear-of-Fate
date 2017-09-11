--[[
	Desc: UpperSlash state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of UpperSlash state in this class
]]

local _State_UpperSlash = require("Src.Class")()

function _State_UpperSlash:Ctor()
    --body
end 

function _State_UpperSlash:Enter(hero_)
    self.name = "upperslash"
	hero_.pakGrp.body:SetAnimation("hitback")
	hero_.pakGrp.weapon:SetAnimation("hitback")
	
end

function _State_UpperSlash:Update(hero_,FSM_)
    local _body = hero_.pakGrp.body
	local _dt = love.timer.getDelta()

	if _body:GetCount() >= 2 and _body:GetCount() <=4 then
		hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )
	end 
	
end 

function _State_UpperSlash:Exit(hero_)
    --body
end

return _State_UpperSlash 
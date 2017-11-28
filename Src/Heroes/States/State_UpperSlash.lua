--[[
	Desc: UpperSlash state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of UpperSlash state in this class
]]

local _State_UpperSlash = require("Src.Class")()

local _EffectMgr = require "Src.Scene.EffectManager" 

function _State_UpperSlash:Ctor()
    self.effect = {}
end 

function _State_UpperSlash:Enter(hero_)
    self.name = "upperslash"
	hero_:GetBody():SetAnimation("hitback")
	hero_:GetWeapon():SetAnimation("hitback")
	
end

function _State_UpperSlash:Update(hero_,FSM_)
    local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()

	if _body:GetCount() >= 2 and _body:GetCount() <=4 then
		hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )
	end 

	if _body:GetCount() == 2 and not self.effect[1] then
		self.effect[1] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "upperslash1.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir())	
		self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
		-- self.effect[1]:SetOffset(-180 * hero_:GetDir(),-80)

	end 
	
	if self.effect[1] then
		self.effect[1].pos.x = self.effect[1].pos.x + hero_.spd.x * 20 * _dt * hero_.dir
	end 
	
	
	
end 

function _State_UpperSlash:Exit(hero_)
    self.effect[1] = nil
end

return _State_UpperSlash 
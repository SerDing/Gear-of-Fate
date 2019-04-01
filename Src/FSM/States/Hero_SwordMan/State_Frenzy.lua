--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
]]

local _State_Frenzy = require("Src.Core.Class")()

local _EffectMgr = require "Src.Scene.EffectManager" 
local _BuffMgr = require "Src.Heroes.BuffManager" 
local _AUDIOMGR = require "Src.Audio.AudioManager"

function _State_Frenzy:Ctor()
	self.name = "frenzy"
	self.effect = {}
	self.stateColor = {255,150,0,255}
	self.switch = false
end 

function _State_Frenzy:Enter(hero_,FSM_)
	
	if self.switch then
		
		self.switch = false
		
		hero_:GetBody():SetColor(255, 255, 255, 255)
		-- hero_:GetAvatar():GetWidget("weapon_b1"):SetColor(255, 255, 255, 255)
		-- hero_:GetAvatar():GetWidget("weapon_c1"):SetColor(255, 255, 255, 255)

		_BuffMgr.OffBuff(hero_, "frenzy")
		
		FSM_:SetState(FSM_.oriState, hero_)
		
		hero_:SetAttackMode("normal")

		return 
	end 
	
	hero_:SetAnimation("grab")
	
	hero_:GetBody():SetColor(unpack(self.stateColor))
	-- hero_:GetAvatar():GetWidget("weapon_b1"):SetColor(unpack(self.stateColor))
	-- hero_:GetAvatar():GetWidget("weapon_c1"):SetColor(unpack(self.stateColor))

	self.effect[1] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "frenzy/cast.lua", hero_.pos.x, hero_.pos.y, 1, hero_:GetDir())	
	self.effect[1]:GetAni():SetBaseRate(hero_:GetAtkSpeed())


	self.switch = true
	hero_:SetAttackMode("frenzy")
	_AUDIOMGR.PlaySound("SM_FLENSE")
end

function _State_Frenzy:Update(hero_,FSM_)
	local _body = hero_:GetBody()
	local _dt = love.timer.getDelta()
	
	if not self.effect[2] and _body:GetCount() == 6 then
		self.effect[2] = _EffectMgr.GenerateEffect(_EffectMgr.pathHead["SwordMan"] .. "frenzy/blast.lua",hero_.pos.x,hero_.pos.y,1,hero_:GetDir())	
		self.effect[2]:GetAni():SetBaseRate(hero_:GetAtkSpeed())
	end 

	if _body:GetCount() == 16 then
		_BuffMgr.AddBuff(hero_,"frenzy")
	end 

end 

function _State_Frenzy:Exit(hero_)
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_Frenzy 
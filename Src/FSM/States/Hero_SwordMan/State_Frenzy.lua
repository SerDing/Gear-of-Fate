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

function _State_Frenzy:Ctor(FSM, hero)
	self.FSM = FSM
    self.hero = hero
	self.name = "frenzy"
	self.effect = {}
	self.stateColor = {255,150,0,255}
	self.switch = false
end 

function _State_Frenzy:Enter()
	
	if self.switch then
		
		self.switch = false
		
		self.hero:GetBody():SetColor(255, 255, 255, 255)
		-- self.hero:GetAvatar():GetWidget("weapon_b1"):SetColor(255, 255, 255, 255)
		-- self.hero:GetAvatar():GetWidget("weapon_c1"):SetColor(255, 255, 255, 255)

		_BuffMgr.OffBuff(self.hero, "frenzy")
		
		self.FSM:SetState(self.FSM.oriState, self.hero)
		
		self.hero:SetAttackMode("normal")

		return 
	end 
	
	self.hero:SetAnimation("grab")
	
	self.hero:GetBody():SetColor(unpack(self.stateColor))
	-- self.hero:GetAvatar():GetWidget("weapon_b1"):SetColor(unpack(self.stateColor))
	-- self.hero:GetAvatar():GetWidget("weapon_c1"):SetColor(unpack(self.stateColor))

	self.effect[1] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "frenzy/cast.lua", self.hero)	
	self.effect[1]:GetAni():SetBaseRate(self.hero:GetAtkSpeed())


	self.switch = true
	self.hero:SetAttackMode("frenzy")
	_AUDIOMGR.PlaySound("SM_FLENSE")
end

function _State_Frenzy:Update()
	local _body = self.hero:GetBody()
	local _dt = love.timer.getDelta()
	
	if not self.effect[2] and _body:GetCount() == 6 then
		self.effect[2] = _EffectMgr.ExtraEffect(_EffectMgr.pathHead["SwordMan"] .. "frenzy/blast.lua", self.hero)	
		self.effect[2]:GetAni():SetBaseRate(self.hero:GetAtkSpeed())
	end 

	if _body:GetCount() == 16 then
		_BuffMgr.AddBuff(self.hero,"frenzy")
	end 

end 

function _State_Frenzy:Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
end

return _State_Frenzy 
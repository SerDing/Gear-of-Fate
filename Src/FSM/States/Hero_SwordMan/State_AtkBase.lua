--[[
	Desc: attack base class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* base logic for attack state
]]

--[[
	通用的攻击状态逻辑
	由攻击状态们继承
	通过填写参数达到逻辑量产
	攻击判定部分 独立成类 AttackJudger
	战斗状态基本分为两种：
	* 单帧停止一段时间后切换到下一状态
	* 播放一段动画后切换到下一状态
		到达关键帧时 生成特效和攻击
		有特殊需求时 可放弃继承此类 或 在此基础上加入新的逻辑
]]

local _State_AtkBase = require("Src.Core.Class")()
local _EffectMgr = require "Src.Scene.EffectManager"

function _State_AtkBase:Ctor(FSM, hero)
	self.hero = hero
	self.FSM = FSM
	self.atkBaseInit = true
	self.effect = {}
	self.effectInfo = {}

	self.EffectMgr = require "Src.Scene.EffectManager"
	_EffectMgr = require "Src.Scene.EffectManager"
end 

function _State_AtkBase:Enter()
	self.dt = 0 
	self.heroBody = self.hero:GetBody()
	self.heroType = self.hero:GetSubType()
	self.atkJudger = self.hero:GetAtkJudger()
	self.input = self.hero:GetComponent("Input")
end 

function _State_AtkBase:Update()
	self.dt = love.timer.getDelta()
	-- Add effects by info
	for i=1,#self.effectInfo do
		if self.effectInfo[i].born == false then
			-- print(strcat("atk base effect generate:", self.EffectMgr.pathHead[self.heroType], self.effectInfo[i].subPath))
			self:Effect(self.effectInfo[i].subPath, 1, 1)
			self.effectInfo[i].born = true
		end
	end
end 

function _State_AtkBase:Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
	end 
	for i=1,#self.effectInfo do -- Reset born state of effects
		self.effectInfo[i].born = false
	end
end

function _State_AtkBase:SetEffectKeyFrame(frame, subPath)
    self.effectInfo[#self.effectInfo + 1] = {frame = frame, subPath = subPath, born = false}
end

function _State_AtkBase:Effect(path, layer, num, atkSpdPercent)
	assert(self.hero, "hero ref is nil")
	
	self.effect[#self.effect + 1] = _EffectMgr.ExtraEffect(strcat(_EffectMgr.pathHead[self.heroType], path), self.hero)

	-- print("_State_AtkBase:Effect() --> effect_num:",#self.effect)
	atkSpdPercent = atkSpdPercent or 1.00
	self.effect[#self.effect]:GetAni():SetBaseRate(self.hero:GetAtkSpeed() * atkSpdPercent)
	self.effect[#self.effect]:SetLayer(layer or 1)
end

return _State_AtkBase 
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

function _State_AtkBase:_Init()

	
	self.atkBaseInit = true
	self.effect = {}
	self.effectInfo = {}

	self.EffectMgr = require "Src.Scene.EffectManager"
	-- self.SoundMgr = require "Src.SoundManager"
end 

function _State_AtkBase:_Enter(hero_)
	self.hero_ = hero_
	self.heroBody = hero_:GetBody()
	self.dt = 0 
	self.atkJudger = hero_:GetAtkJudger()
	self.heroType = hero_:GetSubType()
end 

function _State_AtkBase:_Update(FSM_)
	self.dt = love.timer.getDelta()
	-- Add effects by info
	for i=1,#self.effectInfo do
		if self.effectInfo[i].born == false then
			print("atk base effect generate:", self.EffectMgr.pathHead[self.heroType] .. self.effectInfo[i].subPath)
			self:Effect(self.EffectMgr.pathHead[self.heroType] .. self.effectInfo[i].subPath, 1, 1, self.hero_)
			self.effectInfo[i].born = true
		end
	end
end 

function _State_AtkBase:_Exit()
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

function _State_AtkBase:Effect(path, layer, num)
	
	if self.hero_ then
		self.effect[#self.effect + 1] = self.EffectMgr.ExtraEffect(path, 
			self.hero_.pos.x, 
			self.hero_.pos.y, 
			num, 
			self.hero_:GetDir(),
			self.hero_
		)
	else
		error("_State_AtkBase:Effect() hero_ ptr is nil!")
		-- self.effect[#self.effect + 1] = self.EffectMgr.GenerateEffect(path, 
		-- 	self.hero_.pos.x, 
		-- 	self.hero_.pos.y + layer, 
		-- 	num, 
		-- 	self.hero_:GetDir()
		-- )
	end
	
	
	-- print("_State_AtkBase:Effect() --> effect_num:",#self.effect)
	self.effect[#self.effect]:GetAni():SetBaseRate(self.hero_:GetAtkSpeed())
	self.effect[#self.effect]:SetLayer(layer or 1)
end

return _State_AtkBase 
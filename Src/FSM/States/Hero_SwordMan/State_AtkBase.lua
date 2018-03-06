--[[
	Desc: Tmp state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of tmp state in this class
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

function _State_AtkBase:AtkBase_Init()

	-- self.SoundMgr = require "Src.SoundManager"
	self.atkBaseInit = true
	self.effect = {}

	self.EffectMgr = require "Src.Scene.EffectManager"
	
	
end 

function _State_AtkBase:AtkBase_Enter(hero_)
	self.hero_ = hero_
	self.heroBody = hero_:GetBody()
	self.dt = 0 
	self.atkJudger = hero_:GetAtkJudger()
end 

function _State_AtkBase:AtkBase_Update(hero_,FSM_)
    self.dt = love.timer.getDelta()
end 

function _State_AtkBase:AtkBase_Exit()
	for n=1,#self.effect do
		self.effect[n] = nil
    end 
end

function _State_AtkBase:SetEffectKeyFrame()
    -- statements
end

function _State_AtkBase:SetAtkKeyFrame() -- attack judge key frame
    -- statements
end

function _State_AtkBase:Effect(path,layer,num,hero_)
	
	if hero_ then
		self.effect[#self.effect + 1] = self.EffectMgr.ExtraEffect(path, 
			self.hero_.pos.x, 
			self.hero_.pos.y + layer, 
			num, 
			self.hero_:GetDir(),
			hero_
		)
	else
		self.effect[#self.effect + 1] = self.EffectMgr.GenerateEffect(path, 
			self.hero_.pos.x, 
			self.hero_.pos.y + layer, 
			num, 
			self.hero_:GetDir()
		)
	end
	
	
	-- print("AtkBase_Effect() --> effect_num:",#self.effect)
	self.effect[#self.effect]:GetAni():SetBaseRate(self.hero_:GetAtkSpeed())
	self.effect[#self.effect]:SetLayer(layer or 1)
end

return _State_AtkBase 
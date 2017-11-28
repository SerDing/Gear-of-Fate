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

local _State_AtkBase = require("Src.Class")()


function _State_AtkBase:Ctor()
    --body
end 

function _State_AtkBase:AtkBaseInit()
	-- ...
	self.EffectMgr = require "Src.Scene.EffectManager"
	self.SoundMgr = require "Src.SoundManager"  
	self.atkBaseInit = true
end 

function _State_AtkBase:SetEffectKeyFrame()
    -- statements
end

function _State_AtkBase:SetAtkKeyFrame() -- attack judge key frame
    -- statements
end

function _State_AtkBase:AtkBaseLogic()
    -- statements
end

function _State_AtkBase:Enter(hero_)
    -- statements
end

function _State_AtkBase:Update(hero_,FSM_)
    --body
end 

function _State_AtkBase:Exit(hero_)
    --body
end



return _State_AtkBase 
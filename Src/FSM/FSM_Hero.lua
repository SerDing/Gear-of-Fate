--[[
	Desc: FSM for hero
	Author: Night_Walker 
	Since: 2018-04-12 13:19:36 
	Last Modified time: 2018-04-12 13:19:36 
	Docs: 
		* Write notes here even more 
]]
local _FSM = require "Src.FSM.FSM"
local _FSM_Hero = require("Src.Core.Class")(_FSM)

-- 引用SkillSystem

function _FSM_Hero:LateUpdate(entity)
	if self.curState.GetTrans then
		self:Transition(entity)
	end
end 

function _FSM_Hero:Transition(entity)
	local _trans = self.curState:GetTrans()
	if _trans then
		for i=1,#_trans do
			if _trans[i][1] == "NORMAL" then
				self:SwitchState(_trans[i][2], _trans[i][3], entity, _trans[i][4] or nil)
			elseif _trans[i][1] == "SKILL" then
				self:SwitchSkillState(_trans[i][2], _trans[i][3], entity, _trans[i][4] or nil)
			end
		end
	end
end 

function _FSM_Hero:SwitchSkillState(skillName, stateName, hero_, ...)
	self.KEYID[skillName] = hero_:GetSkillKeyID(skillName)
	
	if self.input:IsPressed(hero_.KEY[self.KEYID[skillName]]) then -- IsPressed
		-- 检测技能是否满足释放条件：1.技能是否学习？ 2.冷却是否完成？ 2.heroMP是否足够？
		self:SetState(stateName, hero_, ...)
	end 

	-- self:SwitchState(self.KEYID[skillName], stateName, hero_, ...)
end 

function _FSM_Hero:SwitchState(keyID, stateName, hero_, ...)
    if self.input:IsPressed(hero_.KEY[keyID]) then -- IsPressed
		self:SetState(stateName, hero_, ...)
	end 
end 

return _FSM_Hero 
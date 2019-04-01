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

function _FSM_Hero:OnConstruct()
	self.HotKeyMgr_ = require "Src.Input.HotKeyMgr"
	self.SkillMgr_ = self.entity_:GetComponent('SkillMgr')
end

function _FSM_Hero:LateUpdate(entity_)
	if self.curState.GetTrans then
		self:Transition(entity_)
	end
end 

function _FSM_Hero:Transition(entity_)
	local _trans = self.curState:GetTrans()
	if _trans then
		for i=1,#_trans do
			if _trans[i][1] == "NORMAL" then
				self:SwitchState(_trans[i][2], _trans[i][3], entity_, _trans[i][4] or nil)
			elseif _trans[i][1] == "SKILL" then
				self:SwitchSkillState(_trans[i][2], _trans[i][3], entity_, _trans[i][4] or nil)
			end
		end
	end
end 

function _FSM_Hero:SwitchSkillState(sklID, stateName, hero_, ...)
	--skillID --> abstractKeyName --> realKeyID
	if self.input:IsPressed(self.HotKeyMgr_.GetSkillKey(sklID)) or self.input:IsPressed(self.HotKeyMgr_.GetSkillCMDKey(sklID)) then -- IsPressed
		print("Switch Skill State", sklID)
		if self.SkillMgr_:IsSklUseable(sklID) then
			self:SetState(stateName, hero_, ...)
			self.SkillMgr_:DoSkill(sklID)
		end
	end 
end 

function _FSM_Hero:SwitchState(keyID, stateName, hero_, ...)
	if self.input:IsPressed(self.HotKeyMgr_.KEY[keyID]) then
		self:SetState(stateName, hero_, ...)
	end 
end 

function _FSM_Hero:OnCurStateExit(entity_)
	self:SkillCoolEvents(entity_)
	
end

function _FSM_Hero:OnNewStateEnter(entity_)
	self.SkillMgr_:HandleAvailability(self.curState.trans)
end

function _FSM_Hero:SkillCoolEvents(entity_)
	local coolMsg = self.curState.skillID or nil
	if coolMsg then
		self.SkillMgr_:StartCoolSkl(coolMsg)
	end
end

return _FSM_Hero 
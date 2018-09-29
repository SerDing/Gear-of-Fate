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

local _SkillMgr = require "Src.BattleSystem.SkillManager"

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
		if _SkillMgr.IsSklUseable(hero_, sklID) then
			self:SetState(stateName, hero_, ...)
			_SkillMgr.DoSkill(hero_, sklID)
		end
	end 
end 

function _FSM_Hero:SwitchState(keyID, stateName, hero_, ...)
    if self.input:IsPressed(self.HotKeyMgr_.KEY[keyID]) then
		self:SetState(stateName, hero_, ...)
	end 
end 

function _FSM_Hero:OnConstruct()
    self.HotKeyMgr_ = require "Src.Input.HotKeyMgr"
end

function _FSM_Hero:OnCurStateExit(entity_)
	self:SkillCoolEvents(entity_)
end

function _FSM_Hero:SkillCoolEvents(entity_)
	local coolMsg = self.curState.skillID or nil
	if coolMsg then
		_SkillMgr.StartCoolSkl(entity_, coolMsg)
	end
end

return _FSM_Hero 
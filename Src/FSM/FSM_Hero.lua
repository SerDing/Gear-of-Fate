--[[
	Desc: FSM for hero
	Author: Night_Walker 
	Since: 2018-04-12 13:19:36 
	Last Modified time: 2018-04-12 13:19:36 
	Docs: 
		* 
]]
local _FSM = require "Src.FSM.FSM"
local _FSM_Hero = require("Src.Core.Class")(_FSM)

function _FSM_Hero:OnConstruct(entity)
	self.SkillMgr_ = self.entity:GetComponent('SkillMgr')
	self.input = entity:GetComponent("Input")
end

function _FSM_Hero:LateUpdate()
	if self.curState.GetTrans then
		self:Transition(self.entity)
	end
end 

function _FSM_Hero:Transition()
	local _trans = self.curState:GetTrans()
	if _trans then
		for i=1,#_trans do
			if _trans[i][1] == "NORMAL" then
				self:SwitchState(_trans[i][2], _trans[i][3], _trans[i][4] or nil)
			elseif _trans[i][1] == "SKILL" then
				self:SwitchSkillState(_trans[i][2], _trans[i][3], _trans[i][4] or nil)
			end
		end
	end
end

function _FSM_Hero:SwitchState(action, stateName, ...) -- action, stateName, ...
	if self.input:IsPressed(action) then -- IsActionPressed("attack")
		self:SetState(stateName, ...)
	end
end

---@param sklID number
---@param stateName string
---@param hero_ table
---@param ... any @vararg
function _FSM_Hero:SwitchSkillState(sklID, stateName, ...)
	if self.input:IsPressed(stateName) then -- IsPressed
		if self.SkillMgr_:IsSklUseable(self.states[stateName].skillID) then -- self.SkillMgr_:IsSklUseable(self.states[stateName].skillID)
			self:SetState(stateName, ...)
			self.SkillMgr_:DoSkill(self.states[stateName].skillID)
		end
	end
end

function _FSM_Hero:OnCurStateExit()
	self:SkillCoolEvents()
end

function _FSM_Hero:SkillCoolEvents()
	local coolMsg = self.curState.skillID or nil
	if coolMsg then
		self.SkillMgr_:StartCoolSkl(coolMsg)
	end
end

function _FSM_Hero:OnNewStateEnter()
	self.SkillMgr_:HandleAvailability(self.curState.trans)
end



return _FSM_Hero 
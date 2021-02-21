--[[
	Desc: State component, manage states of entity.
	Author: SerDing 
	Since: 2018-04-12
	Alter: 2018-04-12
]]
local _RESMGR = require("system.resource.resmgr")
local _Fsm = require("utils.fsm")
local _Base = require("entity.component.base")

---@class Entity.Component.State : Utils.FSM
---@field protected _entity Entity
---@field protected _states table<string, State.Base>
local _State = require("core.class")(_Fsm)

function _State.HandleData(data)
	for key, value in pairs(data) do
		if key ~= "class" then
			data[key] = _RESMGR.LoadStateData(value)
		end
	end
end

function _State:Ctor(entity, data, param)
	_Fsm.Ctor(self)
	_Base.Ctor(self, entity)
	self.skills = self._entity.skills
	self.input = self._entity.input
	
	for name, value in pairs(data) do
		if name ~= "class" then
			_Fsm.RegState(self, name, value.class.New(value, name))
		end
	end

	for _, state in pairs(self._states) do
		state:Init(self._entity)
	end
	
	self:SetState(param.firstState or "stay")
end

function _State:Update(dt)
	if self._entity.identity.isPaused or self._entity.fighter.isDead then
		return false
	end
	
	_Fsm.Update(self, dt)
end

function _State:LateUpdate()
	if self.curState.GetTrans then
		self:Transition()
	end
end 

function _State:SetState(name, ...)
	_Fsm.SetState(self, name, ...)
end

function _State:ReloadAnimDatas(part)
	for key, state in pairs(self._states) do
		state:ReloadAnimData(part)
	end
end

--- auto translate state when animation playing end.
---@param nextState string
function _State:AutoTrans(nextState)
	local main = self._entity.render.renderObj:GetPart()
	if main:TickEnd() then
		self:SetState(nextState)
	end
end

function _State:Transition()
	local trans = self.curState:GetTrans()
	if trans then
		for i=1,#trans do
			if trans[i][1] == "NORMAL" then
				self:SwitchState(trans[i][2], trans[i][3], trans[i][4] or nil)
			elseif trans[i][1] == "SKILL" then
				self:SwitchSkillState(trans[i][2], trans[i][3], trans[i][4] or nil)
			end
		end
	end
end

function _State:SwitchState(action, stateName, ...)
	if self.input:IsPressed(action) then -- IsActionPressed("attack")
		self:SetState(stateName, ...)
	end
end

---@param sklID number
---@param stateName string
---@param hero_ table
---@param ... any @vararg
function _State:SwitchSkillState(sklID, stateName, ...)
	if self.input:IsPressed(stateName) then -- IsPressed
		if self.skills:IsSklUseable(self._states[stateName].skillID) then -- self.SkillMgr_:IsSklUseable(self.states[stateName].skillID)
			self:SetState(stateName, ...)
			self.skills:DoSkill(self._states[stateName].skillID)
		end
	end
end

---@return State.Base
function _State:GetCurState()
	return _Fsm.GetCurState(self)
end

function _State:OnCurStateExit()
	self:SkillCoolEvents()
end

function _State:SkillCoolEvents()
	local coolMsg = self.curState.skillID or nil
	if coolMsg then
		self.skills:StartCoolSkl(coolMsg)
	end
end

function _State:OnNewStateEnter()
	self.skills:HandleAvailability(self.curState._trans)
end

return _State
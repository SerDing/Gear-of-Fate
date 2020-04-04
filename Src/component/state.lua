--[[
	Desc: State component, manage states of entity.
	Author: SerDing 
	Since: 2018-04-12
	Alter: 2018-04-12
]]

local _Base = require("utils.fsm")
local _RESMGR = require("system.resource.resmgr")

---@class Entity.Component.State : Utils.FSM
---@field protected _entity Entity
---@field protected states table<string, State.Base>
local _State = require("core.class")(_Base)

function _State.HandleData(data)
	for key, value in pairs(data) do
		if key ~= "class" then
			data[key] = _RESMGR.LoadStateData(value)
		end
	end
end

function _State:Ctor(entity, data, param)
	_Base.Ctor(self)
	self._entity = entity
	self.enable = true
	self.skills = self._entity.skills
	self.input = self._entity.input
	
	for name, value in pairs(data) do
		if name ~= "class" then
			_Base.RegState(self, name, value.class.New(value, name))
		end
	end

	for key, state in pairs(self.states) do
		state:Init(self._entity)
	end
	
	self:SetState(param.firstState)
end

function _State:Update(dt)
	if not self.enable then
		return
	end
	
	_Base.Update(self, dt)
end

function _State:LateUpdate()
	if self.curState.GetTrans then
		self:Transition()
	end
end 

function _State:SetState(name, ...)
	_Base.SetState(self, name, ...)
end

function _State:InitAnimDatas()
	for key, state in pairs(self.states) do
		state:InitAnimData()
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
		if self.skills:IsSklUseable(self.states[stateName].skillID) then -- self.SkillMgr_:IsSklUseable(self.states[stateName].skillID)
			self:SetState(stateName, ...)
			self.skills:DoSkill(self.states[stateName].skillID)
		end
	end
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
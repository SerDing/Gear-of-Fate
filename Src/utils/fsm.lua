--[[
	Desc: Finite State Machine.
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
]]

---@class Utils.FSM
local _FSM = require("core.class")()

---@param entity Entity
---@param stateName string
function _FSM:Ctor()
	self.states = {}
    self.transitions = {}
	self.preState = nil
	self.curState = nil
end

function _FSM:Update(dt)
	self.curState:Update(dt)
	self:LateUpdate()
end

function _FSM:LateUpdate()
end

---@param name string 
function _FSM:SetState(name, ...)
	assert(self.states[name], "_FSM:SetState(), no state: " .. name)
	if self.curState then
		self.preState = self.curState
		self.curState:Exit()
		self:OnCurStateExit()
	end
	self.curState = self.states[name]
	self.curState:Enter(...)
	self:OnNewStateEnter()

	return true
end

---@param name string
---@param state State.Base
function _FSM:RegState(name, state)
	state.STATE = self
	self.states[name] = state
	-- print("_FSM:RegState: ", name, state)
end

function _FSM:GetCurState()
	return self.curState
end

function _FSM:OnCurStateExit(entity)
end

function _FSM:OnNewStateEnter(entity)
end

---@param cond string @condition
---@param source string @source state name
---@param dest string @destination state name
function _FSM:AddTransition(cd, src, d, ...)
    assert(type(cd) == "string", "condition must be string.")
    assert(type(src) == "string", "source state name must be string.")
    assert(type(d) == "string", "destination state name must be string.")
	-- create message pool by cd, if it is not existing.
	if not self.transitions[cd] then
		self.transitions[cd] = {}
	end
	self.transitions[cd][src] = d
end

---@param msg string @message
function _FSM:Transition(msg)
    for i = 1, #self.transitions do
        if self.transitions[i].cond == msg then
            if self.curState.name == self.transitions[i].source then
                self:SetState(self.transitions[i].dest)
            end
        end
    end
end

return _FSM 
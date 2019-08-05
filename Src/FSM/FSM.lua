--[[
	Desc: finite state machine.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* its instance belongs to an entity and it manage states of the entity
]]

local _FSM = require("Src.Core.Class")()

---@param entity table
function _FSM:Ctor(entity, state_name, entityType)
	
	self.entity = entity
	self.states = {}
	self.entityType = entityType
	self:InitStates(entityType)
    self.transitions = {}

	self:OnConstruct(entity)

	self.oriState = state_name
	self.preState = nil
	self.curState = self.states[state_name]
	self.curState:Enter(entity,self)
	
	if self.OnNewStateEnter then
		self:OnNewStateEnter(entity)
	end
end

function _FSM:Update(dt)
	
	self.curState:Update(dt)
	
	self:LateUpdate()

	if self.entity:GetBody().playOver and self.curState ~= "die" then
		if self.entity:GetBody().aniID == "[down motion]" then
			self:SetState("sit", self.entity)
		else
			self:SetState(self.oriState, self.entity)
		end
	end 

end

function _FSM:LateUpdate()
end

---@param state_name string 
---@param entity_ table 
function _FSM:SetState(state_name, ...)
	if self.curState.name ~= "damage" then
		if self.curState.name == state_name then
			return 
		end
	end

	self.preState = self.curState
	self.curState:Exit()
	self:OnCurStateExit()
	self.curState = self.states[state_name]
	self.curState:Enter(...)
	self:OnNewStateEnter()
end

function _FSM:InitStates(entityType)
	
	self.pathHeads = {
		["HERO_SWORDMAN"] = "Src/FSM/States/Hero_SwordMan/",
		["MONSTER_GOBLIN"] = "Src/FSM/States/Monster_Goblin/",
	}

	local statesPath = self.pathHeads[entityType]
	local stateNames = love.filesystem.getDirectoryItems(statesPath)
	local stateName = ""
	local classPath = ""
	for i = 1, #stateNames do
		stateName = string.gsub(stateNames[i], "%.lua", "")
		stateName = string.gsub(stateName, "State_", "")
		stateName = string.lower(stateName)
		classPath = statesPath .. string.gsub(stateNames[i], "%.lua", "")
		self:RegState(stateName, classPath)
	end

end

---@param state_name string 
---@param class_name string 
function _FSM:RegState(state_name, class_path)
	assert(self.states, "state list in FSM was not initialized.")
	local tmpState = require(class_path).New(self, self.entity)
	self.states[state_name] = tmpState
end

function _FSM:SetOriState(state_name)
	self.oriState = state_name
end

function _FSM:GetCurState()
	return self.curState
end

function _FSM:OnCurStateExit(entity_)
end

function _FSM:OnNewStateEnter(entity_)
end

function _FSM:OnConstruct()
end

---@param cond string @condition
---@param source string @source state name
---@param dest string @destination state name
---@param ... any @additional vararg
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
                self:SetState(self.transitions[i].dest, self.entity, unpack(self.transitions[i].vararg))
            end
        end
    end
end

return _FSM 
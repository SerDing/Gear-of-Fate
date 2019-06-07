--[[
	Desc: finite state machine.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* its instance belongs to an entity and it manage states of the entity
]]

local _FSM = require("Src.Core.Class")()

function _FSM:Ctor(entity, state_name, entityType)
	
	self.entity = entity
	self.state = {}
	self.entityType = entityType
	self:InitStates(entityType)

	self.KEYID = {}
	self.input = entity:GetComponent("Input")

	self:OnConstruct()

	self.oriState = state_name
	self.preState = nil
	self.curState = self.state[state_name]
	self.curState:Enter(entity,self)
	
	if self.OnNewStateEnter then
		self:OnNewStateEnter(entity)
	end
end

function _FSM:Update()
	
	self.curState:Update(self.entity, self)
	
	self:LateUpdate(self.entity)

	if self.entity:GetBody():GetCurrentPlayNum() == 0 and self.curState ~= "die" then
		if self.entity:GetBody():GetAniId() == "[down motion]" then
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
function _FSM:SetState(state_name, entity_, ...)
	if self.curState.name ~= "damage" then
		if self.curState.name == state_name then
			return 
		end
	end

	self.preState = self.curState
	self.curState:Exit()
	self:OnCurStateExit()
	self.curState = self.state[state_name]
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
	assert(self.state, "state list in FSM was not initialized.")
	local tmpState = require(class_path).New(self, self.entity)
	self.state[state_name] = tmpState
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

return _FSM 
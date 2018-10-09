--[[
	Desc: finite state machine.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* its instance belongs to an entity and it manage states of the entity
]]

local _FSM = require("Src.Core.Class")()

function _FSM:RegisterState(state_name,class_name)
    
    if not self.state then
        print("Error: state list in FSM was not initialized.")
        return  
    end 

    local _tmpState = require (strcat(self.pathHeads[self.entityType], class_name)).New()
    self.state[state_name] = _tmpState

end

function _FSM:Ctor(entity_,state_name,entityType)
    self.entity_ = entity_
    self.state = {}
    self.entityType = entityType
    self:InitStates(entityType)

    self.oriState = state_name
    self.preState = nil
    self.curState = self.state[state_name]
    self.curState:Enter(entity_,self)
    if self.onNewStateEnter then
        self:onNewStateEnter(entity_)
    end
    self.KEYID = {}
    self.input = entity_:GetInput()
    if self.OnConstruct then
        self:OnConstruct()
    end
end

function _FSM:Update(entity_)
    
    self.curState:Update(entity_,self)
    
    self:LateUpdate(entity_)

    if entity_:GetBody():GetCurrentPlayNum() == 0 and self.curState ~= "die" then
        if entity_:GetBody():GetAniId() == "[down motion]" then
            self:SetState("sit",entity_)
        else
            self:SetState(self.oriState,entity_)
        end
    end 

end

function _FSM:LateUpdate(entity_)
end

function _FSM:SetState(state_name,entity_, ...)

    if self.curState.name ~= "damage" then
        if self.curState.name == state_name then
            return 
        end
    end

    self.preState = self.curState
    self.curState:Exit(entity_)
    if self.OnCurStateExit then
        self:OnCurStateExit(entity_)
    end
    self.curState = self.state[state_name]

    if not self.curState then
        print(strcat("_FSM:SetState() curState ", state_name, " nil", " entity.subType: ", entity.subType))
    end
    self.curState:Enter(entity_, self, ...)
end

function _FSM:InitStates(entityType)
    
    self.pathHeads = {
        ["HERO_SWORDMAN"] = "Src.FSM.States.Hero_SwordMan.",
        ["MONSTER_GOBLIN"] = "Src.FSM.States.Monster_Goblin.",
    }

    self.loadingLst = {
        ["HERO_SWORDMAN"] = {
            -- {state_name, state_file_name},
            {"rest","State_Rest"},
            {"stay","State_Stay"},
            {"move","State_Move"},
            {"dash","State_Dash"},
            {"jump","State_Jump"},
            {"attack","State_Attack"},
            {"dashattack","State_DashAttack"},
            {"upperslash","State_UpperSlash"},
            {"gorecross","State_GoreCross"},
            {"hopsmash","State_HopSmash"},
            {"frenzy","State_Frenzy"},
            {"frenzyattack","State_FrenzyAttack"},
            {"moonslash","State_MoonSlash"},
            {"tripleslash","State_TripleSlash"},
            {"ashenfork","State_Ashenfork"},
        },
        ["MONSTER_GOBLIN"] = {
            {"attack", "State_Attack"},
            {"move", "State_Move"},
            {"waiting", "State_Waiting"},
            {"damage", "State_Damage"},
            {"die", "State_Die"},
            {"sit", "State_Sit"},
        },
        
    }
    
    for i=1,#self.loadingLst[entityType] do
        local v = self.loadingLst[entityType][i]
        self:RegisterState(v[1], v[2])
    end

end

function _FSM:SetOriState(state_name)
    self.oriState = state_name
end

function _FSM:GetCurState()
    return self.curState
end

function _FSM:OnCurStateExit(entity_)
end

function _FSM:OnConstruct()
end

return _FSM 
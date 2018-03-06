--[[
	Desc: finite state machine.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* its instance belongs to an entity and it manage states of the entity
]]


local _FSM = require("Src.Core.Class")()

local _pathHeads = {
    ["HERO_SWORDMAN"] = "Src.FSM.States.Hero_SwordMan.",
    ["MONSTER_GOBLIN"] = "Src.FSM.States.Monster_Goblin.",
}

function _FSM:RegisterState(state_name,class_name)
    
    if not self.state then
        print("Error: state list in FSM was not initialized.")
        return  
    end 

    local _tmpState = require (_pathHeads[self.entityType] .. class_name).New()
    self.state[state_name] = _tmpState

end

function _FSM:Ctor(entity_,state_name,entityType)
    
    self.state = {}
    self.entityType = entityType
    self:InitStates(entityType)

    self.oriState = state_name
    self.preState = nil
    self.curState = self.state[state_name]
    self.curState:Enter(entity_,self)

end

function _FSM:Update(entity_)
   
    self.curState:Update(entity_,self)

    if(entity_:GetBody():GetCurrentPlayNum() == 0)then
        if entity_:GetBody():GetAniId() == "[down motion]" then
            self:SetState("sit",entity_)
        else
            self:SetState(self.oriState,entity_)
        end
    end 

end

function _FSM:SetState(state_name,entity_, ...)

    if self.curState.name ~= "damage" then
        if self.curState.name == state_name then
            return 
        end
    end

    self.preState = self.curState
    self.curState:Exit(entity_)
    self.curState = self.state[state_name]

    if not self.curState then
        log("_FSM:SetState() curState " .. state_name .. " nil" .. " entity.subType: " .. entity.subType)
    end
    self.curState:Enter(entity_,self,...)
    
end

function _FSM:InitStates(entityType)
    self.loadingLst = {
        ["HERO_SWORDMAN"] = {
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
        },
        ["MONSTER_GOBLIN"] = {
            {"attack", "State_Attack"},
            {"move", "State_Move"},
            {"waiting", "State_Waiting"},
            {"damage", "State_Damage"},
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



return _FSM 
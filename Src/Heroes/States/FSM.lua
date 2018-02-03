--[[
	Desc: finite state machine.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* manage states in the hero
]]


local _FSM = require("Src.Core.Class")()

local _pathHead = "Src.Heroes.States."

function _FSM:RegisterState(state_name,class_name)
    if not self.state then
        print("Error: state list in FSM was not initialized.")
        return  
    end 
    local _tmpState = require (_pathHead .. class_name).New()
    self.state[state_name] = _tmpState
end

function _FSM:Ctor(hero_,state_name)
    
    self.state = {}

    self:RegisterState("rest","State_Rest")
    self:RegisterState("stay","State_Stay")
    self:RegisterState("move","State_Move")
    self:RegisterState("dash","State_Dash")
    self:RegisterState("jump","State_Jump")
    self:RegisterState("attack","State_Attack")
    self:RegisterState("dashattack","State_DashAttack")
    self:RegisterState("upperslash","State_UpperSlash")
    self:RegisterState("gorecross","State_GoreCross")
    self:RegisterState("hopsmash","State_HopSmash")
    self:RegisterState("frenzy","State_Frenzy")
    self:RegisterState("frenzyattack","State_FrenzyAttack")
    self:RegisterState("moonslash","State_MoonSlash")
    self:RegisterState("tripleslash","State_TripleSlash")

    self.oriState = "stay"
    self.preState = nil
    self.curState = self.state[state_name]
    self.curState:Enter(hero_,self)

end

function _FSM:Update(hero_)
    self.curState:Update(hero_,self)

    if(hero_:GetBody():GetCurrentPlayNum() == 0)then
        self:SetState(self.oriState,hero_)
	end 

end

function _FSM:SetState(state_name,hero_,...)

    if self.curState.name == state_name then
        return 
    end
 
    self.preState = self.curState
    self.curState:Exit(hero_)
    self.curState = self.state[state_name]
    self.curState:Enter(hero_,self,...)
    hero_:UpdateAni()
    
end



return _FSM 
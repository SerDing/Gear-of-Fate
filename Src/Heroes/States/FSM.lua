--[[
	Desc: finite state machine.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* manage states in the hero
]]


local _FSM = require("Src.Class")()

local _pathHead = "Src.Heroes.States."

local _State_Rest = require (_pathHead .. "State_Rest").New()
local _State_Stay = require (_pathHead .. "State_Stay").New()
local _State_Move = require (_pathHead .. "State_Move").New()
local _State_Dash = require (_pathHead .. "State_Dash").New()
local _State_Jump = require (_pathHead .. "State_Jump").New()

local _State_Attack = require (_pathHead .. "State_Attack").New()

-- const

local state = {
    ["rest"] = _State_Rest,
    ["stay"] = _State_Stay,
    ["move"] = _State_Move,
    ["dash"] = _State_Dash,
    ["jump"] = _State_Jump,
    
    ["attack"] = _State_Attack,


}

function _FSM:Ctor(hero_,state_name)
    
    self.oriState = "stay"
    self.preState = nil
    self.curState = state[state_name]
    self.curState:Enter(hero_,self)

end  

function _FSM:Update(hero_)
    self.curState:Update(hero_,self)

    if(hero_.pakGrp.body.playNum == 0)then
        self:SetState(self.oriState,hero_)
	end 

end

function _FSM:SetState(state_name,hero_)

    if self.curState.name == state_name then
        return 
    end
 
    self.preState = self.curState
    self.curState:Exit(hero_)
    self.curState = state[state_name]
    self.curState:Enter(hero_,self)
    
end

return _FSM 
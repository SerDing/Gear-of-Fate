--[[	
	Desc: base state
	Author: SerDing 	
	Since: 2019-06-08 01:38:07 
	Alter: 2019-06-08 01:38:07 	
	Docs: 
		* 
]]

local _EntityState = require("Src.Core.Class")()

function _EntityState:Ctor(FSM, entity)
    self.FSM = FSM
    self.entity = entity
    self.body = self.entity:GetBody()
end

function _EntityState:Enter()
    
end

function _EntityState:Update()
    
end

---@return table {state_name, ...}
function _EntityState:Transition()
    if self.body.playOver then
        self.FSM:SetState(self.FSM.oriState)
    end
end

function _EntityState:Exit()
    
end

return _EntityState
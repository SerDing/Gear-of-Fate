--[[	
	Desc: base state
	Author: SerDing 	
	Since: 2019-06-08 01:38:07 
	Alter: 2019-06-08 01:38:07 	
	Docs: 
		* 
]]

local _State = require("Src.Core.Class")()

function _State:Ctor(FSM, entity)
    self.FSM = FSM
    self.entity = entity
    self.body = self.entity:GetBody()
end

function _State:Enter()
    
end

function _State:Update()
    
end

---@return stateName string
function _State:Return()
    if self.body:GetCurrentPlayNum() == 0 then
        self.FSM:SetState(self.FSM.oriState, self.entity)
    end
end

function _State:Exit()
    
end

return _State
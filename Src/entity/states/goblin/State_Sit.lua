--[[
	Desc: monster goblin sit state 
	Author: SerDing
	Since: 2018-03-04 18:39:26 
	Last Modified time: 2018-03-04 18:39:26 
	Docs: 
		* Write notes here even more 
]]

local _State_Sit = require("core.class")()

function _State_Sit:Ctor(FSM, entity)
    self.FSM = FSM
    self._entity = entity
end 

function _State_Sit:Enter()
    self.name = "sit"
	self.avatar:Play("sit")
	
end

function _State_Sit:Update(dt)
    --body
end 

function _State_Sit:Exit()
    --body
end

return _State_Sit 
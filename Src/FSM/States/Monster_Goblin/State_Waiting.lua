--[[
	Desc: A new lua class 
	Author: Night_Walker 
	Since: 2018-02-25 01:45:13 
	Last Modified time: 2018-02-25 01:45:13 
	Docs: 
		* Write notes here even more 
]]

local _State_Waiting = require("Src.Core.Class")()

function _State_Waiting:Ctor()
    --body
end 

function _State_Waiting:Enter(entity)
    self.name = "waiting"
	entity.pakArr.body:SetAnimation("[waiting motion]")
	
end

function _State_Waiting:Update(entity,FSM_)
    --body
end 

function _State_Waiting:Exit(entity)
    --body
end

return _State_Waiting 
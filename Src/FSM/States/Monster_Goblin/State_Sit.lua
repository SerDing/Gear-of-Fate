--[[
	Desc: monster goblin sit state 
	Author: Night_Walker 
	Since: 2018-03-04 18:39:26 
	Last Modified time: 2018-03-04 18:39:26 
	Docs: 
		* Write notes here even more 
]]

local _State_Sit = require("Src.Core.Class")()

function _State_Sit:Ctor()
    --body
end 

function _State_Sit:Enter(entity)
    self.name = "sit"
	entity:SetAnimation("[sit motion]")
	
end

function _State_Sit:Update(entity,FSM_)
    --body
end 

function _State_Sit:Exit(entity)
    --body
end

return _State_Sit 
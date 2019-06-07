--[[
	Desc: monster goblin sit state 
	Author: Night_Walker 
	Since: 2018-03-04 18:39:26 
	Last Modified time: 2018-03-04 18:39:26 
	Docs: 
		* Write notes here even more 
]]

local _State_Sit = require("Src.Core.Class")()

function _State_Sit:Ctor(FSM, entity)
    self.FSM = FSM
    self.entity = entity
end 

function _State_Sit:Enter()
    self.name = "sit"
	self.entity:SetAnimation("[sit motion]")
	
end

function _State_Sit:Update()
    --body
end 

function _State_Sit:Exit()
    --body
end

return _State_Sit 
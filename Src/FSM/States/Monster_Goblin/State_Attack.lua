--[[
	Desc: A new lua class 
	Author: Night_Walker 
	Since: 2018-02-26 19:10:43 
	Last Modified time: 2018-02-26 19:10:43 
	Docs: 
		* Write notes here even more 
]]

local _State_Attack = require("Src.Core.Class")()

function _State_Attack:Ctor()
    self.name = "attack"
end 

function _State_Attack:Enter(entity, FSM_, ...)
    entity:SetAnimation("[attack motion 1]")

end

function _State_Attack:Update(entity,FSM_)
    --body
end 

function _State_Attack:Exit(entity)
    --body
end

return _State_Attack 
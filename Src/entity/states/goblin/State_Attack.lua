--[[
	Desc: A new lua class 
	Author: SerDing
	Since: 2018-02-26 19:10:43 
	Last Modified time: 2018-02-26 19:10:43 
	Docs: 
		* Write notes here even more 
]]

local _State_Attack = require("core.class")()

---@param entity GameObject
function _State_Attack:Ctor(FSM, entity)
	self.FSM = FSM
    self._entity = entity ---@type GameObject
    self.name = "attack"
end 

function _State_Attack:Enter(...)
    self.avatar:Play("attack1")
end

function _State_Attack:Update()
    --body
end 

function _State_Attack:Exit(entity)
    --body
end

return _State_Attack 
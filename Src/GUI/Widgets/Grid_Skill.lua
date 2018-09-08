--[[
	Desc: Grid Skills
	Author: SerDing 
	Since: 2018-08-29 15:11:16 
	Last Modified time: 2018-08-29 15:11:16 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Grid_Skill = require("Src.Core.Class")(_Widget)



function _Grid_Skill:Ctor(id, fixed)
    self.skillID = 0

    self.fixed = fixed or false
    self.skillRef = _SkillMgr.GetSkillById()
end 

function _Grid_Skill:Update(dt)
    --body
end 

function _Grid_Skill:Draw(x,y)
    --body
end

return _Grid_Skill 
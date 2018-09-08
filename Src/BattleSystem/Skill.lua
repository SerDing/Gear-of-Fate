--[[
	Desc: Skill Object
	Author: SerDing 
	Since: 2018-08-21 02:16:12 
	Last Modified time: 2018-08-21 02:16:12 
	Docs: 
		* Write more details here 
]]

local _Skill = require("Src.Core.Class")()

local _Sprite = require("Src.Core.Sprite")

function _Skill:Ctor(path, id)
	self.property = require(string.gsub(path,".skl",""))
	self.id = id
	self.iconPath = {
		_RESMGR.pathHead .. self.property["[icon]"][1] .. self.property["[icon]"][2],
		_RESMGR.pathHead .. self.property["[icon]"][3] .. self.property["[icon]"][4],
	}
end 

function _Skill:Update(dt)
    --body
end 

function _Skill:Draw(x,y)
    --body
end

return _Skill 
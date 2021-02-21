--[[
	Desc: Skill Object
	Author: SerDing 
	Since: 2018-08-21 02:16:12 
	Last Modified time: 2018-08-21 02:16:12 

]]
local _RESOURCE = require("engine.resource")

---@class Skill
local _Skill = require("core.class")()

function _Skill:Ctor(path, id)
	self.property = _RESOURCE.LoadData(path)
	self.id = id
	self.iconPath = {
		self.property["[icon]"][1] .. "/" .. self.property["[icon]"][2] .. "",
		self.property["[icon]"][3] .. "/" .. self.property["[icon]"][4] .. "",
	}
	self.leared = false
	self.state = 1 -- 1.useable  2.unusable
	self.name = self.property['[name]']
	local _coolTimeTable = self.property["[cool time]"] or self.property["[dungeon]"]['[cool time]']
	self.coolTime = _coolTimeTable[1] / 1000
	self.coolTimer = 0
end 

function _Skill:WasLearned()
	return self.leared
end 

function _Skill:Learn()
	self.leared = true
end 

function _Skill:Done() -- start cool
	self.coolTimer = self.coolTime
	self.state = 2
end 

function _Skill:IsUseable() 
	return self.state == 1
end 

function _Skill:SetState(s)
	self.state = s
end

function _Skill:GetState(s)
	return self.state
end

return _Skill 
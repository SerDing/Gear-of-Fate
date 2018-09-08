--[[
	Desc: Skill Manager
	Author: SerDing 
	Since: 2018-08-20 18:55:49 
	Last Modified time: 2018-08-20 18:55:49 
	Docs: 
		* This module will load all skills'path and use them to create skill objects 
]]

local _SkillMgr = {}

local _Skill = require "Src.BattleSystem.Skill"

function _SkillMgr.Ctor()
    _SkillMgr.pathHead = "/Data/skill/"
	_SkillMgr.sklPathArr = {}
	_SkillMgr.skillList = LoadFile("/Data/skill/swordmanskill.lst")
	_SkillMgr.skillList = CutText(_SkillMgr.skillList,"\n")
	
	for i = 2, #_SkillMgr.skillList do
		local _data = split(_SkillMgr.skillList[i], "\t")
		_data[2] = string.gsub(string.lower(_data[2]), "`", "")
		_SkillMgr.sklPathArr[tonumber(_data[1])] = strcat(_SkillMgr.pathHead, _data[2])
	end

	self.skills = {}
	for i,v in ipairs(_SkillMgr.sklPathArr) do
		self.skills[i] = _Skill.New(v, i)
	end
end 

function _SkillMgr.Update(dt)
    --body
end 

function _SkillMgr.GetSkillById(id)
	local skl = self.skills[id]
	assert(skl, "_SkillMgr.GetSkillById()  no skill:" .. id)
	return skl
end

return _SkillMgr 
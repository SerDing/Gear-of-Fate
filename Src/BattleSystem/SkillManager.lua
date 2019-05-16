--[[
	Desc: Skill Manager for actor
	Author: SerDing 
	Since: 2018-08-20 18:55:49 
	Last Modified time: 2018-08-20 18:55:49 
	Docs: 
		* this is a component for actor 
		* main feature: load all skills'path and use them to create skill objects 
		* it will help cooldown skills and decide whether they can be used by actor
]]

local _SkillMgr = require("Src.Core.Class")()

local _Skill = require "Src.BattleSystem.Skill"
local _fileExists = love.filesystem.exists

function _SkillMgr:Ctor(actor, skills)
	self.pathHead = "/Data/skill/"
	self.actor = actor
	self:InitData(self.actor:GetProperty('job'))
	if skills then
		self:LearnSkills(skills)
	end
	self.debug = true
	-- self.debug = false
end 

function _SkillMgr:InitData(job)
	job = string.gsub(job,'%[', "") -- delete "["
	job = string.gsub(job,'%]', "") -- delete "]"
	self.sklPathArr = {} -- < id, path >
	self.skills = {} -- < id, skillObj >
	self.skillList = require("/Data/skill/" .. job .. "skill") -- load skill list file
	
	-- Construct skill file path list
	local pathSplit = ""
	for id, path in pairs(self.skillList) do
		pathSplit = split(path, "/") -- separate path by '/', the second part is skill's name
		self.sklPathArr[id] = strcat(self.pathHead, string.lower(path))
	end

	-- Create skill objects
	self.skills = {}
	for k,v in pairs(self.sklPathArr) do
		if love.filesystem.exists(v .. ".lua") then -- only create skills which has a real file
			self.skills[k] = _Skill.New(v, k)
		end 
	end 
end 

function _SkillMgr:Update(dt)
	-- cool down skills
	for k, v in pairs(self.skills) do
		if v.coolTimer > 0 then
			v.coolTimer = v.coolTimer - dt
			if v.coolTimer < 0 then
				v.coolTimer = 0
				self:HandleAvailability(self.actor:GetComponent("FSM"):GetCurState().trans)
			end
		end 
	end 
end 

-- set whether skills can be used
function _SkillMgr:HandleAvailability(stateTransList)
	-- assume that all skills cannot be used
	for k, skill in pairs(self.skills) do 
		skill:SetState(2)
	end

	-- Check whether the skill cool down finished by transition list
	local skill
	if stateTransList then 
		for i,v in ipairs(stateTransList) do
			if v[1] == "SKILL" then -- v[1] = stateType, v[2] = skillID v[3] = stateName
				skill = self:GetSkillById(v[2])
				if skill.coolTimer <= 0 then
					skill:SetState(1)
				end
			end
		end
	end

	-- Check whether the mp of actor is enough to use skill
	local consume_mp = 0
	local mp = self.actor:GetModel('MP'):GetCur()
	for k, skill in pairs(self.skills) do
		consume_mp = skill.property['[consume MP]'] or skill.property['[dungeon]']['[consume MP]']
		if skill:GetState() == 1 then -- the skill has been available state 
			if skill:WasLearned() and skill.coolTimer <= 0 and mp >= consume_mp[1] then
				skill:SetState(1)
			else
				skill:SetState(2)
			end
		end
	end	
end

function _SkillMgr:IsSklUseable(sklID) 
	if self.debug then
		return true
	end

	local skill = self.skills[sklID]
	return skill:IsUseable()
end 

function _SkillMgr:DoSkill(sklID)
	if self.debug then
		return
	end

	local skill = self.skills[sklID]
	local consume_mp = skill.property['[consume MP]'] or skill.property['[dungeon]']['[consume MP]']
	self.actor:GetModel('MP'):Decrease(consume_mp[1])
end

function _SkillMgr:StartCoolSkl(sklID)
	assert(self.skills[sklID], "skill not exist: " .. sklID)
	self.skills[sklID]:Done()
end

function _SkillMgr:GetSkillById(id)
	local skl = self.skills[id]
	assert(skl, "_SkillMgr.GetSkillById()  no skill:" .. id)
	return skl
end

function _SkillMgr:LearnSkill(id)
	print("learn skill", self.actor:GetProperty('job'), id)
	self.skills[id]:Learn()
end

function _SkillMgr:LearnSkills(ids)
	for i,v in ipairs(ids) do
		self:LearnSkill(v)
	end
end

return _SkillMgr
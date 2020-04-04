--[[
	Desc: Skill Manager for actor
	Author: SerDing 
	Since: 2018-08-20 18:55:49 
	Last Modified time: 2018-08-20 18:55:49 
	Docs: 
		* main feature: load all skills'path and use them to create skill objects 
		* it will help cooldown skills and set their are usable state.
]]
local _STRING = require("engine.string")
local _Skill = require("component.skills.skill")
local _Base = require("component.base")

---@class Entity.Component.Skills : Entity.Component.Base
local _Skills = require("core.class")(_Base)

local _fileExists = love.filesystem.exists

function _Skills:Ctor(entity, data)
	_Base.Ctor(self, entity)
	self.pathHead = "Data/entity/skill/"
	self:InitData(data.job)
	if data.skills then 
		self:LearnSkills(data.skills)
	end
	self.debug = false
end 

function _Skills:InitSkills(data)
	
end

function _Skills:InitData(job)
	self.skillPathList = {} --- @type table<number, string> @map<id, path>
	self.skillNameList = {} --- @type table<number, string> @map<id, name>
	self.skills = {} ---@type table<number, Skill> @map<id, skillObj>
	self.skillList = require("Data/entity/skill/" .. job .. "skill") -- load skill list file
	
	-- Construct skill file path list and skill name list
	local pathSplit = {}
	for id, path in pairs(self.skillList) do
		pathSplit = _STRING.split(path, "/") -- separate path by '/', the second part is skill's name
		self.skillNameList[id] = string.lower(pathSplit[2])
		self.skillPathList[id] = self.pathHead .. string.lower(path)
	end

	-- Create skill objects
	self.skills = {}
	for k,v in pairs(self.skillPathList) do
		if love.filesystem.exists(v .. ".lua") then -- only create skills which has a real file
			self.skills[k] = _Skill.New(v, k)
		end 
	end 
end 

function _Skills:Update(dt)
	-- cool down skills
	for k, v in pairs(self.skills) do
		if v.coolTimer > 0 then
			v.coolTimer = v.coolTimer - dt
			if v.coolTimer < 0 then
				v.coolTimer = 0
				self:HandleAvailability(self._entity.state:GetCurState()._trans)
			end
		end 
	end 
end 

-- set whether skills can be used
function _Skills:HandleAvailability(stateTransList)
	-- assume that all skills cannot be used
	for k, skill in pairs(self.skills) do 
		skill:SetState(2)
	end

	-- Check whether the skill cool down finished via transition list
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
	local mp = self._entity.stats.mp:GetCur()
	for _, skill in pairs(self.skills) do
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

function _Skills:IsSklUseable(sklID) 
	if self.debug == true then
		return true
	end

	local skill = self.skills[sklID]
	return skill:IsUseable()
end 

function _Skills:DoSkill(sklID)
	if self.debug == true then 
		return
	end

	local skill = self.skills[sklID]
	local consume_mp = skill.property['[consume MP]'] or skill.property['[dungeon]']['[consume MP]']
	self._entity.stats.mp:Change(-consume_mp[1])
end

function _Skills:StartCoolSkl(id)
	assert(self.skills[id], "skill not found: " .. id)
	self.skills[id]:Done()
end

function _Skills:GetSkillById(id)
	assert(self.skills[id], "skill not found:" .. id)
	return self.skills[id]
end

function _Skills:GetSkillNameByID(id)
	assert(self.skillNameList[id], "skill not found:" .. id)
	return self.skillNameList[id]
end

---@return number
function _Skills:GetSkillIDByName(name)
	for id, skillName in pairs(self.skillNameList) do
		if skillName == name then
			return id
		end
	end
	return 0
end

function _Skills:LearnSkill(id)
	self.skills[id]:Learn()
end

function _Skills:LearnSkills(ids)
	for _,v in ipairs(ids) do
		self:LearnSkill(v)
	end
end

return _Skills
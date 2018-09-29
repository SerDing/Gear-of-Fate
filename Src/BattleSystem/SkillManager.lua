--[[
	Desc: Skill Manager
	Author: SerDing 
	Since: 2018-08-20 18:55:49 
	Last Modified time: 2018-08-20 18:55:49 
	Docs: 
		* main function: load all skills'path and use them to create skill objects 
		* it will help cooldown skills and decide whether they can be used by some actors
]]

local _SkillMgr = {}
local this = _SkillMgr
local _Skill = require "Src.BattleSystem.Skill"
local _fileExists = love.filesystem.exists

function _SkillMgr.Ctor()
	this.pathHead = "/Data/skill/"
	this.actors = {}
	this.InitData("[swordman]")
end 

function _SkillMgr.InitData(job)
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	this.sklPathArr = {} -- map < id, path >
	this.nameIdList = {} -- list < sklName, sklID >
	this.skills = {} -- map < id, skillObj >
	this.skillList = require("/Data/skill/" .. job .. "skill")
	local pathSplit = ""
	for id, path in pairs(this.skillList) do
		pathSplit = split(path, "/") -- separate path by '/', the second part is skill's name
		this.sklPathArr[id] = strcat(this.pathHead, string.lower(path))
		this.nameIdList[string.lower(pathSplit[2])] = id
		-- print("nameIdList ", pathSplit[2], id)
	end

	this.skills[job] = {}
	local _pool = this.skills[job]
	for k,v in pairs(this.sklPathArr) do
		if love.filesystem.exists(v .. ".lua") then -- only create skills which has a real file
			-- print(v)
			_pool[k] = _Skill.New(v, k)
		end 
	end 
end 

function _SkillMgr.Update(dt)
	-- cool down skills
	for k, _pool in pairs(this.skills) do
		for k,v in pairs(_pool) do 
			if v.coolTimer > 0 then
				v.coolTimer = v.coolTimer - dt
				if v.coolTimer < 0 then
					v.coolTimer = 0
				end
			end 
		end 
	end 

	-- set whether skills can be used
	for i,actor in ipairs(this.actors) do
		this.HandleAvailability(actor)
	end
end 

function _SkillMgr.HandleAvailability(actor)
	local _stateTransList = actor.FSM.curState.trans
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	for job, skills in pairs(this.skills) do
		
		for k, skill in pairs(skills) do -- assume that all skills cannot be used
			skill:SetState(2)
		end

		local skill
		if _stateTransList then -- set some skills to be available by transition list
			for i,v in ipairs(_stateTransList) do
				if v[1] == "SKILL" then -- v[1] = stateType, v[2] = skillID v[3] = stateName
					skill = this.GetSkillById(actor, v[2])
					if skill.coolTimer <= 0 then
						skill:SetState(1)
					end
				end
			end
		end

		local consume_mp = 0
		local mp = actor:GetModel('MP'):GetCur()
		for k, skill in pairs(skills) do
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
end

function _SkillMgr.IsSklUseable(actor, sklID) 
	--[[
		only useable for hero/APC now
		this method need ref 'actor' to know which job it needs to check avalability
	]]
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	-- local sklID = this.nameIdList[name]
	local skill = this.skills[job][sklID]
	return skill:IsUseable()
end 

function _SkillMgr.DoSkill(actor, sklID)
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	-- local sklID = this.GetSklIDByName(string.lower(name))
	local skill = this.skills[job][sklID]
	
	local consume_mp = skill.property['[consume MP]'] or skill.property['[dungeon]']['[consume MP]']
	actor:GetModel('MP'):Decrease(consume_mp[1])
end

function _SkillMgr.StartCoolSkl(actor, sklID)
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	-- local sklID = this.GetSklIDByName(name)
	local skill = this.skills[job][sklID]

	skill:Done()
end

function _SkillMgr.GetSklIDByName(name)
	assert(this.nameIdList[name], "_SkillMgr.GetSklIDByName(name) no id for: " .. name)
	return this.nameIdList[name]
end

function _SkillMgr.GetSkillById(actor, id)
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	local skl = this.skills[job][id]
	assert(skl, "_SkillMgr.GetSkillById()  no skill:" .. id)
	return skl
end

function _SkillMgr.RegActor(actor)
	this.actors[#this.actors + 1] = actor
end

function _SkillMgr.LearnSkill(actor, id)
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	print("learn skill", job, id)
	this.skills[job][id]:Learn()
end

function _SkillMgr.LearnSkills(actor, ids)
	for i,v in ipairs(ids) do
		this.LearnSkill(actor, v)
	end
end

return _SkillMgr 
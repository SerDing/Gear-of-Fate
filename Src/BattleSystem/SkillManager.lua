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
	this.skillList = LoadFile("/Data/skill/" .. job .. "skill.lst")
	this.skillList = split(this.skillList,"\n")
	this.skillList = split(this.skillList[2],"\t")

	this.nameIdList = {} -- list < sklName, sklID >
	this.skills = {} -- map < id, skillObj >

	for i=1, #this.skillList do
		if i % 2 ~= 0 and this.skillList[i + 1] then
			local path = string.gsub(string.lower(this.skillList[i + 1]), "`", "")
			path = string.gsub(path, ".skl", "")
			local pathSplit = split(path, "/") -- separate path by '/', the second part is skill's name
			this.sklPathArr[tonumber(this.skillList[i])] = strcat(this.pathHead, path)
			this.nameIdList[pathSplit[2]] = tonumber(this.skillList[i])
			this.sklPathArr[tonumber(this.skillList[i])] = this.pathHead .. path
		end
	end

	this.skills[job] = {}
	local _pool = this.skills[job]
	for k,v in pairs(this.sklPathArr) do	
		if love.filesystem.exists(v .. ".lua") then -- only create skills which has a real file
			print(v)
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
		for k, skill in pairs(skills) do
			local mp = actor:GetModel('MP'):GetCur()
			local consume_mp = skill.property['[consume MP]'] or skill.property['[dungeon]']['[consume MP]']
			if skill:WasLearned() and skill.coolTimer <= 0 and mp >= consume_mp[1] then
				skill:SetState(1)
			else
				skill:SetState(2)
			end
		end
		for k, skill in pairs(skills) do -- assume that all skills cannot be used
			skill:SetState(2)
		end
		local skill
		if _stateTransList then -- set some skills to be available by transition list
			for i,v in ipairs(_stateTransList) do
				if v[1] == "SKILL" then -- v[1] = stateType, v[2] = skillName v[3] = stateName
					print(this.GetSklIDByName(string.lower(v[2])), v[2])
					skill = this.GetSkillById(actor, this.GetSklIDByName(string.lower(v[2])))
					if skill.coolTimer <= 0 then
						skill:SetState(1)
					end
				end
			end
		end
	end
end

function _SkillMgr.IsSklUseable(actor, name) 
	--[[
		only useable for hero/APC now
		this method need ref 'actor' to know which job it needs to check avalability
	]]

	name = string.lower(name)
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	local sklID = this.nameIdList[name]
	local skill = this.skills[job][sklID]
	return skill:IsUseable()
end 

function _SkillMgr.StartCoolSkl(actor, name)
	local job = actor:GetProperty('job')
	job = string.gsub(job,'%[', "")
	job = string.gsub(job,'%]', "")
	local sklID = this.GetSklIDByName(name)
	local skill = this.skills[job][sklID]
	skill:Done()
end

function _SkillMgr.GetSklIDByName(name)
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
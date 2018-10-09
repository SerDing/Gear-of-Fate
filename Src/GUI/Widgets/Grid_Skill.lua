--[[
	Desc: Grid for Skill
	Author: SerDing 
	Since: 2018-08-29 15:11:16 
	Last Modified time: 2018-08-29 15:11:16 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Grid_Skill = require("Src.Core.Class")(_Widget)

local _SkillMgr = require "Src.BattleSystem.SkillManager"
local _RESMGR = require "Src.Resource.ResManager"
local _Sprite = require "Src.Core.Sprite"
local _SCENEMGR = require "Src.Scene.GameSceneMgr"
local hero_ = _SCENEMGR.GetHero_()

function _Grid_Skill:Ctor(id, x, y, skillid, absKey,origin)
	self.type = "SkillGrid"
	self.id = id or nil
	self.x = x or 0
	self.y = y or 0
	self.skillID = 0
	self.absKey = absKey
	self.origin = origin or false
	self:SetSkill(skillid)
	self.coolPercent = 1.00
end 

function _Grid_Skill:Draw(x,y)
	if self.skillID ~= 0 then
		self.sprites[self.skill.state]:Draw(self.x + 1, self.y + 1)
		if self.skill.coolTimer > 0 then
			self.coolPercent = self.skill.coolTimer / self.skill.coolTime
			self.coolPercent = math.abs(self.coolPercent)
			self.sprites[3]:SetDrawArea(0, 0, self.sprites[3]:GetWidth(), self.sprites[3]:GetHeight() * self.coolPercent)
			self.sprites[3]:Draw(self.x + 1, self.y + 1)
		end
	end
end 

function _Grid_Skill:SetSkill(id)
	self.skillID = id
	if id == 0 then
		return 
	end
	self.skill = _SkillMgr.GetSkillById(hero_, self.skillID)
	self.sprites = {
		_Sprite.New(_RESMGR.pathHead .. self.skill.iconPath[1]), -- useable
		_Sprite.New(_RESMGR.pathHead .. self.skill.iconPath[2]), -- cool
	}
	self.sprites[3] = _Sprite.New(love.graphics.newImage(love.image.newImageData(self.sprites[1]:GetWidth(), self.sprites[1]:GetHeight()))) -- black mask
	self.sprites[3]:SetColorEx(0, 0, 0, 122)
end 

function _Grid_Skill:MessageEvent(msg)
	
end 

return _Grid_Skill 
--[[
	Desc: Grid for Skill
	Author: SerDing 
	Since: 2018-08-29 15:11:16 
	Last Modified time: 2018-08-29 15:11:16
]]

local _RESMGR = require "system.resource.resmgr"
local _Sprite = require "engine.graphics.drawable.sprite"
local _FACTORY = require "system.entityfactory"
local _GRAPHICS = require("engine.graphics.graphics")
local _Widget = require("system.gui.widgets.widget")

---@class GUI.Widgets.SkillShortcut : GUI.Widgets.Base
local _SkillShortcut = require("core.class")(_Widget)

function _SkillShortcut.NewWithData(data)
    return _SkillShortcut.New(data.name, data.x, data.y, data.is_origin, data.img_path)
end

function _SkillShortcut:Ctor(name, x, y, isOrigin, imgPath)
	_Widget.Ctor(self, name, x, y)
	self._isOrigin = isOrigin or false
	self._coolPercent = 1.00
	self._slot = _Sprite.New()
	self._slot:SetImage(imgPath)
	self._sprites = {
		_Sprite.New(), -- useable
		_Sprite.New(), -- cool
	}
end 

function _SkillShortcut:Draw()
	self._slot:SetRenderValue("position", self.x, self.y)
	self._slot:Draw()
	if self._skill then
		self._sprites[self._skill.state]:SetRenderValue("position", self.x + 1, self.y + 1)
		self._sprites[self._skill.state]:Draw()
		if self._skill.coolTimer > 0 then
			self._coolPercent = self._skill.coolTimer / self._skill.coolTime
			self._coolPercent = math.abs(self._coolPercent)

			_GRAPHICS.SetColor(0, 0, 0, 122)
			_GRAPHICS.DrawRect("fill", self.x + 1, self.y + 1, self._sprites[1]:GetWidth(), self._sprites[1]:GetHeight() * self._coolPercent)
			_GRAPHICS.ResetColor()
		end
	end
end 

function _SkillShortcut:SetSkill(skill)
	assert(skill, "skill is nil")
	self._skill = skill
	self._sprites[1]:SetImage(string.lower(self._skill.iconPath[1]))
	self._sprites[2]:SetImage(string.lower(self._skill.iconPath[2]))
end 

function _SkillShortcut:HandleEvent(msg, x, y)
	
end

return _SkillShortcut
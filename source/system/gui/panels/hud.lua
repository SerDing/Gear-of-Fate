--[[	
	Desc: HUD panel
	Author: SerDing 
	Since: 2019-08-10 18:26
	Alter: 2020-11-06
]]
local _PLAYERMGR = require("system.playermgr")
local _Panel = require("system.gui.panels.panel")
local _HpController = require("system.gui.controller.hpcontroller")

---@class GUI.Panel.HUD : GUI.Panel
local _HUD = require("core.class")(_Panel)

function _HUD:Ctor()
    _Panel.Ctor(self,"HUD")
    self:LoadLayout("layout/hud")

    self._entity = nil ---@type Entity

    self.hpView = self:GetWidgetById("hp_bar")
    self.mpView = self:GetWidgetById("mp_bar")
    self.hpController = _HpController.New() ---@type GUI.Widgets.HpController
    self.mpController = _HpController.New() ---@type GUI.Widgets.HpController
    self.hpController:SetView(self.hpView)
    self.mpController:SetView(self.mpView)

    self:SetEntity(_PLAYERMGR._localPlayer)
end

---@param entity Entity
function _HUD:SetEntity(entity)
    self._entity = entity
    self:BindSkillModels()
    self:SetMVC()
end

function _HUD:BindSkillModels()
    local map = self._entity.input.skillInputMap
    local skills = self._entity.skills ---@type Entity.Component.Skills

    local shortcut ---@type GUI.Widgets.SkillShortcut
    local id = ""
    local skillID = 0
    -- set simple skill shortcuts
    for x = 1, 6 do
        id = "skill_shortcut_" .. tostring(x)
        shortcut = self:GetWidgetById(id)
        if map[string.upper(id)] then
            skillID = skills:GetSkillIDByName(map[string.upper(id)])
            shortcut:SetSkill(skills:GetSkillById(skillID))
        end
    end
    -- set extended skill shortcuts
    for x = 1, 6 do
        id = "skill_shortcut_ex_" .. tostring(x)
        shortcut = self:GetWidgetById(id)
        if map[string.upper(id)] then
            skillID = skills:GetSkillIDByName(map[string.upper(id)])
            shortcut:SetSkill(skills:GetSkillById(skillID))
        end
    end
end

function _HUD:SetMVC()
    self.hpController:SetModel(self._entity.stats.hp)
    self.mpController:SetModel(self._entity.stats.mp)
end

return _HUD
--[[	
	Desc: HUD panel
	Author: SerDing 	
	Since: 2019-08-10 18:26
	Alter: 2019-12-08 
]]
local _ENTITYMGR = require("system.entitymgr") 
local _Panel = require("system.gui.panels.panel")
local _HUD = require("core.class")(_Panel) ---@class HUD : Panel

local _HpController = require("system.gui.controller.hpcontroller")

---@param entity Swordman
function _HUD:Ctor()
    _Panel.Ctor(self,"HUD")
    self:LoadLayout("Data/ui/layout/hud")

    self._entity = nil ---@type Swordman

    self.hpView = self:GetWidgetById("hp_bar")
    self.mpView = self:GetWidgetById("mp_bar")
    self.hpController = _HpController.New() ---@type HpController
    self.mpController = _HpController.New() ---@type HpController
    self.hpController:SetView(self.hpView)
    self.mpController:SetView(self.mpView)

    self:SetEntity(_ENTITYMGR.player)
end

---@param entity Entity
function _HUD:SetEntity(entity)
    self._entity = entity
    self:SetSkillShortcutsInfo()
    self:SetHmpMVC()
end

function _HUD:SetSkillShortcutsInfo()
    local map = self._entity.input.skillInputMap
    local skills = self._entity.skills ---@type SkillComponent

    local shortcut = nil ---@type SkillShortcut
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

function _HUD:SetHmpMVC()
    self.hpController:SetModel(self._entity.stats.hp)
    self.mpController:SetModel(self._entity.stats.mp)
end

return _HUD
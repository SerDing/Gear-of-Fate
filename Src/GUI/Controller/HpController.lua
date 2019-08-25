--[[
	Desc: HP Controller
	Author: SerDing
	Since: 2019-08-13
	Last Modified time: 2018-08-13 15:05:57
	Docs:
		*
]]

local _HpController = require("Src.Core.Class")() ---@class HpController

function _HpController:Ctor()
    self.model = nil ---@type HP
    self.view = nil ---@type HMP_Bar
end

---@param model HP
function _HpController:SetModel(model)
    if self.model then
        self.model.changeEvent:DelListener(self, self.OnHpChange)
    end
    self.model = model
    self.model.changeEvent:AddListener(self, self.OnHpChange)
    if self.view then
        self:RefreshViewInfo()
    end
end

function _HpController:SetView(view)
    self.view = view
    if self.model then
        self:RefreshViewInfo()
    end
end

function _HpController:RefreshViewInfo()
    self.view.max = self.model.max
    self.view.cur = self.model.cur
end

---@param type string @ the changing type
---@param change number @ the changed value
function _HpController:OnHpChange(type, change)
    self.view:OnHpChanged(type, change)
end

return _HpController
--[[
	Desc: HP Controller
	Author: SerDing
	Since: 2019-08-13
	Alter: 2019-12-08
]]

---@class HpController
---@field public model Utils.Value
---@field public view HMP_Bar
local _HpController = require("core.class")()

function _HpController:Ctor()
    self.model = nil 
    self.view = nil 
end

function _HpController:SetModel(model)
    if self.model then
        self.model.changeEvent:DelListener(self, self.OnHpChange)
    end
    self.model = model
    self.model.changeEvent:AddListener(self, self.OnHpChange)
    if self.view then
        self:RefreshView()
    end
end

function _HpController:SetView(view)
    self.view = view
    if self.model then
        self:RefreshView()
    end
end

function _HpController:RefreshView()
    self.view.max = self.model:GetMax()
    self.view.cur = self.model:GetCur()
end

---@param type string @ the changing type
---@param change number @ the changed value
function _HpController:OnHpChange(type, change)
    self.view:OnHpChanged(type, change)
end

return _HpController
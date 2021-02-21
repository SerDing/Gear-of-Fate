--[[
	Desc: HP Controller
	Author: SerDing
	Since: 2019-08-13
	Alter: 2019-12-08
]]

---@class GUI.Widgets.HpController
---@field public _model Utils.PositiveValue
---@field public _view GUI.Widgets.HMP_Bar
local _HpController = require("core.class")()

function _HpController:Ctor()
    self._model = nil 
    self._view = nil 
end

function _HpController:SetModel(model)
    if self._model then
        self._model.onValueChange:DelListener(self, self.OnHpChange)
    end
    self._model = model
    self._model.onValueChange:AddListener(self, self.OnHpChange)
    if self._view then
        self:RefreshView()
    end
end

function _HpController:SetView(view)
    self._view = view
    if self._model then
        self:RefreshView()
    end
end

function _HpController:RefreshView()
    self._view._max = self._model:GetMax()
    self._view._cur = self._model:GetCur()
end

---@param type string @ the changing type
---@param change number @ the changed value
function _HpController:OnHpChange(type, change)
    self._view:OnHpChanged(type, change)
end

return _HpController
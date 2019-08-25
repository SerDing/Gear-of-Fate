--[[
	Desc: HP/MP Bar inherit from ProgressBar
	Author: Night_Walker 
	Since: 2018-08-17 18:08:53 
	Alter: 2018-8-18 01:31:44
	Docs: 
		* Write more details here 
]]
local _ProgressBar = require("Src.GUI.Widgets.ProgressBar")
local _HMP_Bar = require("Src.Core.Class")(_ProgressBar) ---@class HMP_Bar : ProgressBar

function _HMP_Bar:Ctor(name, x, y, stylePath)
    _ProgressBar.Ctor(self, name, x, y, stylePath)
    self.max = 100
    self.cur = 100
    self.percent = self.cur / self.max
end 

function _HMP_Bar:Draw(px, py)
    self:SetTranslate(px, py)

    if self.bottomLayer then
        self.bottomLayer:Draw(self.x, self.y)
    end
    local ux, uy = self:CalcUpperLayerPos(self.upperLayer, self.bottomLayer)
    self.upperLayer:SetDrawArea(
            0, 0, self.upperLayer:GetWidth() * self.percent, self.upperLayer:GetHeight(),
            self.translate.x,
            self.translate.y
    )
    self.upperLayer:Draw(ux, uy)
end

---@param type string @ the changing type
---@param change number @ the changed value
function _HMP_Bar:OnHpChanged(type, change)
    if type == "increase" then
        self.cur = self.cur + change
        --TODO:increase animation
    elseif type == "decrease" then
        self.cur = self.cur - change
        --TODO:decrease animation
    end

    self.percent = self.cur / self.max
end

function _HMP_Bar:SetPos(x, y)
    self.x, self.y = x, y
end

function _HMP_Bar:GetWidth()
    return self.bottomLayer:GetWidth() or self.upperLayer:GetWidth()
end

function _HMP_Bar:GetHeight()
    return self.bottomLayer:GetHeight() or self.upperLayer:GetHeight()
end

function _HMP_Bar:CalcUpperLayerPos(upper, bottom)
    return self.x + (bottom:GetWidth() - upper:GetWidth()) / 2, self.y + (bottom:GetHeight() - upper:GetHeight()) / 2
end

return _HMP_Bar 
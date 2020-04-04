--[[
	Desc: HP/MP Bar inherit from ProgressBar
	Author: SerDing 
	Since: 2018-08-17 18:08:53 
	Alter: 2018-8-18 01:31:44
]]

local _ProgressBar = require("system.gui.widgets.progressBar")

---@class GUI.Widgets.HMP_Bar : GUI.Widgets.ProgressBar
local _HMP_Bar = require("core.class")(_ProgressBar)

function _HMP_Bar.NewWithData(data)
    return _HMP_Bar.New(data.name, data.x, data.y, data.style_path)
end

function _HMP_Bar:Ctor(name, x, y, stylePath)
    _ProgressBar.Ctor(self, name, x, y, stylePath)
    self.max = 100
    self.cur = 100
    self.percent = self.cur / self.max
end 

function _HMP_Bar:Draw(px, py)
    _ProgressBar.Draw(self, px, py)
end

---@param type string
---@param value number
function _HMP_Bar:OnHpChanged(type, value)
    self.cur = self.cur + value
    if type == "increase" then
        if self.cur >= self.max then
            self.cur = self.max
        end
        --TODO:increase animation
    elseif type == "decrease" then
        if self.cur <= 0 then
            self.cur = 0
        end
        --TODO:decrease animation
    end
    
    self.percent = self.cur / self.max
end

return _HMP_Bar 
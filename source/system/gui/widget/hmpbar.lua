--[[
	Desc: HP/MP Bar inherit from ProgressBar
	Author: SerDing 
	Since: 2018-08-17 18:08:53 
	Alter: 2018-8-18 01:31:44
]]

local _ProgressBar = require("system.gui.widget.progressBar")

---@class GUI.Widgets.HMP_Bar : GUI.Widgets.ProgressBar
local _HMP_Bar = require("core.class")(_ProgressBar)

function _HMP_Bar.NewWithData(data)
    return _HMP_Bar.New(data.name, data.x, data.y, data.style_path)
end

function _HMP_Bar:Ctor(name, x, y, stylePath)
    _ProgressBar.Ctor(self, name, x, y, stylePath)
    self._max = 100
    self._cur = 100
    self._percent = self._cur / self._max
end 

function _HMP_Bar:_OnDraw()
    _ProgressBar._OnDraw(self)
end

---@param type string
---@param delte number
function _HMP_Bar:OnHpChanged(type, delte)
    self._cur = self._cur + delte
    if type == "increase" then
        if self._cur >= self._max then
            self._cur = self._max
        end
        --TODO:increase animation
    elseif type == "decrease" then
        if self._cur <= 0 then
            self._cur = 0
        end
        --TODO:decrease animation
    end
    
    self._percent = self._cur / self._max
end

return _HMP_Bar 
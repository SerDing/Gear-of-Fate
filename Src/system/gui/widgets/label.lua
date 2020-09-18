--[[
	Desc: Label widget in GUI
	Author: SerDing
	Since: 2018-08-16 02:59:49 
	Last Modified time: 2018-08-16 02:59:49 

]]
local _GRAPHICS = require("engine.graphics.graphics") 
local _Widget = require("system.gui.widgets.widget")

local _Label = require("core.class")(_Widget)

function _Label:Ctor(text, x, y, rotation, sx, sy)
	self.text = text
	self.x = x or 0
    self.y = y or 0
    self.rotation = rotation or 0
    self.sx = sx or 1
    self.sy = sy or 1
end 

function _Label:Draw()
    _GRAPHICS.Print(self.text, self.x, self.y, self.rotation, self.sx, self.sy)
end

return _Label 
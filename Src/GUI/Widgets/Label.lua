--[[
	Desc: Label widget in GUI
	Author: Night_Walker 
	Since: 2018-08-16 02:59:49 
	Last Modified time: 2018-08-16 02:59:49 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Label = require("Src.Core.Class")(_Widget)

local _GPrint = love.graphics.print

function _Label:Ctor(text, x, y, rotation, sx, sy)
	self.text = text
	self.x = x or 0
    self.y = y or 0
    self.rotation = rotation or 0
    self.sx = sx or 1
    self.sy = sy or 1
end 

function _Label:Draw()
    _GPrint(self.text, self.x, self.y, self.rotation, self.sx, self.sy)
end

return _Label 
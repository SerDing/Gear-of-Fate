--[[
	Desc: Label widget in GUI
	Author: SerDing
	Since: 2018-08-16 02:59:49 
	Last Modified time: 2018-08-16 02:59:49 

]]
local _GRAPHICS = require("engine.graphics.graphics") 
local _Widget = require("system.gui.widget.widget")

---@class GUI.Widget.Label : Engine.Graphics.Drawable.Base
local _Label = require("core.class")(_Widget)

---@param stroke boolean
function _Label:Ctor(name, x, y, text, stroke)
	_Widget.Ctor(self, name, x, y)
	self._text = text
	self._stroke = stroke
end 

function _Label:_OnDraw()
	local x, y = _Widget.GetRenderValue(self, "position")
	local sx, sy = _Widget.GetRenderValue(self, "scale")
	local _, _, _, a = self:GetRenderValue("color")
	local offset = 1.5
	_GRAPHICS.SetColor(0, 0, 0, a)
	if self._stroke then
		_GRAPHICS.Print(self._text, x - offset, y, 0, sx, sy)
		_GRAPHICS.Print(self._text, x + offset, y, 0, sx, sy)
		_GRAPHICS.Print(self._text, x, y - offset, 0, sx, sy)
		_GRAPHICS.Print(self._text, x, y + offset, 0, sx, sy)
	end
	_GRAPHICS.ResetColor()
	_GRAPHICS.Print(self._text, x, y, 0, sx, sy)
end

return _Label 
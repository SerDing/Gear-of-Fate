--[[
	Desc: Label widget in GUI
	Author: SerDing
	Since: 2018-08-16 02:59:49 
	Last Modified time: 2018-08-16 02:59:49 

]]
local _UIMGR = require("system.gui.uimgr")
local _GRAPHICS = require("engine.graphics")
local _Widget = require("system.gui.widget.widget")
local _Vector2 = require("utils.vector2")

---@class GUI.Widget.Label : GUI.Widgets.Base
local _Label = require("core.class")(_Widget)

function _Label.NewWithData(data)
	return _Label.New(data.name, data.x, data.y, data.text, data.stroke)
end

---@param stroke boolean
function _Label:Ctor(name, x, y, text, stroke)
	_Widget.Ctor(self, name, x, y)
	self._text = text
	self._stroke = stroke
	self._gdRatio = _Vector2.New()
end

function _Label:SetToCenter(x, y, w, h)
	local font = love.graphics.getFont()
	local ratio = 1 / (_UIMGR._scale.x)
	x = x + math.floor((w  - font:getWidth(self._text) * (ratio)) / 2)
	y = y + (h - font:getHeight() * (ratio)) / 2 - _UIMGR._scale.x * 0.5
	--x = x + ((w  - font:getWidth(self._text)) / 2)
	--y = y + ((h - font:getHeight()) / 2)
	self:SetRenderValue("position", x, y)
end

function _Label:_OnDraw()
	local x, y = _Widget.GetRenderValue(self, "position")
	local sx, sy = _Widget.GetRenderValue(self, "scale")
	local _, _, _, a = self:GetRenderValue("color")
	local offset = 1.5
	_GRAPHICS.Push()
	_GRAPHICS.Scale(1 / _UIMGR._scale.x, 1 / _UIMGR._scale.y)
	self._gdRatio = _GRAPHICS.GetDimensionRatio()
	x = x * self._gdRatio.x
	y = y * self._gdRatio.y
	_GRAPHICS.SetColor(0, 0, 0, a)
	if self._stroke then
		_GRAPHICS.Print(self._text, x - offset, y, 0, sx, sy)
		_GRAPHICS.Print(self._text, x + offset, y, 0, sx, sy)
		_GRAPHICS.Print(self._text, x, y - offset, 0, sx, sy)
		_GRAPHICS.Print(self._text, x, y + offset, 0, sx, sy)
	end
	_GRAPHICS.ResetColor()
	_GRAPHICS.Print(self._text, x, y, 0, sx, sy)
	_GRAPHICS.Pop()

	--_GRAPHICS.DrawRect("line", self.x, self.y, self:GetSize())
end

function _Label:GetSize()
	local font = love.graphics.getFont()
	local ratio = 1 / (_UIMGR._scale.x)
	return font:getWidth(self._text) * ratio, font:getHeight() * ratio
end

return _Label 
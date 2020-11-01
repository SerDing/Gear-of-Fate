--[[
	Desc: Image widget in GUI
	Author: SerDing
	Since: 2018-08-16 03:08:33 
	Last Modified time: 2018-08-16 03:08:33 

]]
local _Sprite = require("engine.graphics.drawable.sprite")
local _Widget = require("system.gui.widgets.widget")

---@class GUI.Widgets.Image : GUI.Widgets.Base
local _Image = require("core.class")(_Widget)

function _Image.NewWithData(data)
    return _Image.New(data.name, data.img_path, data.x, data.y, data.r or 0, data.sx or 1, data.sy or 1)
end

function _Image:Ctor(name, path, x, y, rotation, sx, sy)
    _Widget.Ctor(self, name, x, y)
    self._sprite = _Sprite.New()
    self._sprite:SetImage(path)
    self._angle = rotation or 0
    self._sx = sx or 1
    self._sy = sy or 1
    self.area = { x = 0, y = 0, w = self._sprite:GetWidth(), h = self._sprite:GetHeight()}
end

---@param px number parent x
---@param py number parent y
function _Image:Draw()
    self._sprite:SetRenderValue("position", self.x, self.y)
    self._sprite:SetRenderValue("radian", self._angle)
    self._sprite:SetRenderValue("scale", self._sx, self._sy)
    self._sprite:Draw()
end

---@param x number parent x
---@param y number parent y
function _Image:SetDrawArea(x, y, w, h)
    self._sprite:SetQuad(x, y, w, h)
end

return _Image 
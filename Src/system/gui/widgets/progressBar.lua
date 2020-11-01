--[[
	Desc: ProgressBar widget
	Author: SerDing 
	Since: 2018-08-17 17:29:59 
	Last Modified time: 2018-08-17 17:29:59 
]]
local _RESOURCE = require("engine.resource")
local _Sprite = require("engine.graphics.drawable.sprite")
local _Widget = require("system.gui.widgets.widget")

---@class GUI.Widgets.ProgressBar : GUI.Widgets.Base
local _ProgressBar = require("core.class")(_Widget)

function _ProgressBar:Ctor(name, x, y, stylePath)
    _Widget.Ctor(self, name, x, y)
    self._style = _RESOURCE.ReadData(stylePath)
    assert(self._style, "style table is null!")
    self._upper = _Sprite.New()
    self._bottom = _Sprite.New()
    self._upper:SetImage(self._style[1])
    self._bottom:SetImage(self._style[2])
    self._percent = 1
    self._dragging = false
    self._dragOffset = {x = 0, y = 0}
end 

function _ProgressBar:Draw(px, py)
    if self._bottom then
        self._bottom:SetRenderValue("position", self.x, self.y)
        self._bottom:Draw()
    end
    local ux, uy = self:_CalcUpperLayerPos(self._upper, self._bottom)
    self._upper:SetQuad(0, 0, self._upper:GetWidth() * self._percent, self._upper:GetHeight())
    self._upper:SetRenderValue("position", ux, uy)
    self._upper:Draw()
end

function _ProgressBar:HandleEvent(msg, x, y)
    if msg == "MOUSE_MOVED" then
        
    end
end

function _ProgressBar:GetWidth()
    return self._bottom:GetWidth() or self._upper:GetWidth()
end

function _ProgressBar:GetHeight()
    return self._bottom:GetHeight() or self._upper:GetHeight()
end

function _ProgressBar:_CalcUpperLayerPos(upper, bottom)
    return self.x + (bottom:GetWidth() - upper:GetWidth()) / 2, self.y + (bottom:GetHeight() - upper:GetHeight()) / 2
end

return _ProgressBar 
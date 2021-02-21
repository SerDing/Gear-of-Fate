--[[
	Desc: ProgressBar widget
	Author: SerDing 
	Since: 2018-08-17 17:29:59 
	Last Modified time: 2018-08-17 17:29:59 
]]
local _RESOURCE = require("engine.resource")
local _Sprite = require("engine.graphics.drawable.sprite")
local _Widget = require("system.gui.widget.widget")

---@class GUI.Widgets.ProgressBar : GUI.Widgets.Base
local _ProgressBar = require("core.class")(_Widget)

function _ProgressBar:Ctor(name, x, y, stylePath)
    _Widget.Ctor(self, name, x, y)
    self._style = _RESOURCE.LoadUiData(stylePath)
    self._upper = _Sprite.New()
    self._bottom = _Sprite.New()
    self._upper:SetImage(self._style[1])
    self._bottom:SetImage(self._style[2])
    
    self:AddChild(self._upper)
    self:AddChild(self._bottom)
    local ox = (self._bottom:GetWidth() - self._upper:GetWidth()) / 2
    local oy = (self._bottom:GetHeight() - self._upper:GetHeight()) / 2
    self._upper:SetRenderValue("position", ox, oy, 0)

    self._percent = 1
    self._dragging = false
    self._dragOffset = {x = 0, y = 0}
end 

function _ProgressBar:_OnDraw()
    if self._bottom then 
        self._bottom:Draw()
    end
    self._upper:SetQuad(0, 0, self._upper:GetWidth() * self._percent, self._upper:GetHeight())
    self._upper:Draw()
end

function _ProgressBar:GetWidth()
    return self._bottom:GetWidth() or self._upper:GetWidth()
end

function _ProgressBar:GetHeight()
    return self._bottom:GetHeight() or self._upper:GetHeight()
end

return _ProgressBar 
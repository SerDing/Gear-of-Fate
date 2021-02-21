--[[
	Desc: Frame widget
	Author: SerDing
	Since: 2018-08-15 02:15:08 
	Last Modified time: 2018-08-15 02:15:08
]]
local _RESOURCE = require("engine.resource")
local _GRAPHICS = require("engine.graphics.graphics")
local _Sprite = require("engine.graphics.drawable.sprite")
local _Widget = require("system.gui.widget.widget")

---@class GUI.Widgets.Frame : GUI.Widgets.Base
local _Frame = require("core.class")(_Widget) 

function _Frame.NewWithData(data)
    return _Frame.New(data.name, data.x, data.y, data.w, data.h, data.style_path)
end

function _Frame:Ctor(name, x, y, w, h, stylePath)
    _Widget.Ctor(self, name, x, y)
    self.wtype = "container"
    self._width = w or 0
    self._height = h or 0
    self._style = _RESOURCE.LoadUiData(stylePath)
    self._sprites = {}
    for i = 1, 9 do
        self._sprites[i] = _Sprite.New()
        self._sprites[i]:SetImage(self._style[i])
    end
    self._formCanvas = self:_DrawFormCanvas()
    self._formSprite = _Sprite.New()
    self._formSprite:SetImage(self._formCanvas)
    self:AddChild(self._formSprite)

    self._quad = _GRAPHICS.NewQuad(0, 0, self._width, self._height, self._width, self._height)
    self:SetQuad(self._quad)
end

function _Frame:_OnDraw()
    self._formSprite:_OnDraw()

    _GRAPHICS.SetScissor(unpack(self._area))
    _Widget.DrawChildren(self)
    _GRAPHICS.SetScissor()
end

---@return Canvas
function _Frame:_DrawFormCanvas()
    local canvas = _GRAPHICS.NewCanvas(self._width, self._height)
    local x, y = 0, 0
    local w1, w2 = self._sprites[1]:GetWidth(), self._sprites[2]:GetWidth()
    local h1, h4, h7 = self._sprites[1]:GetHeight(), self._sprites[4]:GetHeight(), self._sprites[7]:GetHeight()
    local bodyWidth = self._width - w1 * 2
    local bodyHeight = self._height - h1 - h7
    self._sprites[1]:SetRenderValue("position", x, y) -- upper-left corner
    self._sprites[2]:SetRenderValue("position", x + w1, y) -- top side
    self._sprites[2]:SetRenderValue("scale", bodyWidth / w2, 1)
    self._sprites[3]:SetRenderValue("position", x + w1 + bodyWidth, y) -- upper-right corner
    self._sprites[4]:SetRenderValue("position", x, y + h1) -- left side
    self._sprites[4]:SetRenderValue("scale", 1, bodyHeight / h4)
    self._sprites[5]:SetRenderValue("position", x + w1, y + h1) -- center blocks
    self._sprites[5]:SetRenderValue("scale", bodyWidth / w2, bodyHeight / h4)
    self._sprites[6]:SetRenderValue("position", x + w1 + bodyWidth, y + h1) -- right side
    self._sprites[6]:SetRenderValue("scale", 1, bodyHeight / h4)
    self._sprites[7]:SetRenderValue("position", x, y + h1 + bodyHeight) -- bottom-left corner
    self._sprites[8]:SetRenderValue("position", x + w1, y + h1 + bodyHeight) -- bottom side
    self._sprites[8]:SetRenderValue("scale", bodyWidth / w2, 1)
    self._sprites[9]:SetRenderValue("position", x + w1 + bodyWidth, y + h1 + bodyHeight) -- bottom-right corner

    _GRAPHICS.SetCanvas(canvas)
    for i = 1, #self._sprites do
        self._sprites[i]:Draw()
    end
    _GRAPHICS.SetCanvas()

    return canvas
end

function _Frame:RefreshPosition()
    _Widget.RefreshPosition(self)
    local sx0, _ = self._sprites[1]:GetRenderValue("scale")
    local _, sy1 = self._sprites[2]:GetRenderValue("scale")
    local sx5, _ = self._sprites[6]:GetRenderValue("scale")
    local _, sy7 = self._sprites[8]:GetRenderValue("scale")
    local ratio = 0.2
    local ratio2 = 0.2
    self._area = {
        self.x + self._sprites[1]:GetWidth() * ratio * sx0,
        self.y + self._sprites[2]:GetHeight() * ratio * sy1,
        self._width - 2*self._sprites[6]:GetWidth() * ratio2 * sx5,
        self._height - 2*self._sprites[8]:GetHeight() * ratio2 * sy7,
    }
end

return _Frame 
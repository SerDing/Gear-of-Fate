--[[
	Desc: a popup frame, like bubble.
	Author: SerDing
	Since: 2018-08-15 21:33:28 
	Alter: 2020-04-04 23:53:28

]]
local _RESMGR = require("system.resource.resmgr")
local _Sprite = require("engine.graphics.drawable.sprite")

---@class GUI.Widgets.Pop : GUI.Widgets.Base
---@field protected _sprites table<number, Engine.Graphics.Drawable.Sprite>
local _Pop = require("core.class")()

function _Pop:Ctor(w, h, stylePath)
    self._width = w or 0
    self._height = h or 0
    self._style = require(stylePath)
    assert(self._style, "style table is null!")
    self._sprites = {}
    for i = 0, 8 do
        self._sprites[i] = _Sprite.New()
        self._sprites[i]:SetImage(self._style[i + 1])
    end
    self._width = self._width - self._sprites[0]:GetWidth() * 2
    self._height = self._height - self._sprites[0]:GetHeight() * 2
end 

function _Pop:Draw(x, y)
    -- upper-left corner
    self._sprites[0]:SetRenderValue("position", x, y)
    
    -- top side
    self._sprites[1]:SetRenderValue("position", x + self._sprites[0]:GetWidth(), y)
    self._sprites[1]:SetRenderValue("scale", self._width / self._sprites[1]:GetWidth(), 1)

    -- upper-right corner
    self._sprites[2]:SetRenderValue("position", x + self._sprites[0]:GetWidth() + self._width, y)
    
    -- left side
    self._sprites[3]:SetRenderValue("position", x, y + self._sprites[0]:GetHeight())
    self._sprites[3]:SetRenderValue("scale", 1, self._height / self._sprites[3]:GetHeight())
    
    -- center blocks
    self._sprites[4]:SetRenderValue("position", x + self._sprites[0]:GetWidth(), y + self._sprites[0]:GetHeight())
    self._sprites[4]:SetRenderValue("scale", self._width / self._sprites[4]:GetWidth(), self._height / self._sprites[4]:GetHeight())
    
    -- right side
    self._sprites[5]:SetRenderValue("position", x + self._sprites[0]:GetWidth() + self._width, y + self._sprites[2]:GetHeight())
    self._sprites[5]:SetRenderValue("scale", 1, self._height / self._sprites[5]:GetHeight())
    
    -- bottom-left corner
    self._sprites[6]:SetRenderValue("position", x, y + self._sprites[0]:GetHeight() + self._height)
    
    -- bottom side
    self._sprites[7]:SetRenderValue("position", x + self._sprites[0]:GetWidth(), y + self._sprites[0]:GetHeight() + self._height)
    self._sprites[7]:SetRenderValue("scale", self._width / self._sprites[1]:GetWidth(), 1)
    
    -- bottom-right corner
    self._sprites[8]:SetRenderValue("position", x + self._sprites[0]:GetWidth() + self._width, y + self._sprites[0]:GetHeight() + self._height)

    for _, sprite in pairs(self._sprites) do
        sprite:Draw()
    end
    -- self._sprites[0]:Draw()
    -- self._sprites[1]:Draw()
    -- self._sprites[2]:Draw()
    -- self._sprites[3]:Draw()
    -- self._sprites[4]:Draw()
    -- self._sprites[5]:Draw()
    -- self._sprites[6]:Draw()
    -- self._sprites[7]:Draw()
    -- self._sprites[8]:Draw()
end

return _Pop 
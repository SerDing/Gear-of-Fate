--[[
	Desc: Button widget
	Author: SerDing 
	Since: 2018-08-14 02:03:40 
	Last Modified time: 2018-08-14 02:03:40 
]]

local _GRAPHICS = require("engine.graphics.graphics") 
local _Color = require("engine.graphics.config.color")
local _Sprite = require("engine.graphics.drawable.sprite")
local _RESMGR = require("system.resource.resmgr")
local _Event = require("core.event")
local _Widget = require("system.gui.widgets.widget")

---@class GUI.Widgets.Button : GUI.Widgets.Base
---@field protected _color Engine.Graphics.Config.Color
---@field protected _sprites table<string, Engine.Graphics.Drawable.Sprite>
local _Button = require("core.class")(_Widget)

function _Button.NewWithData(data)
    return _Button.New(data.name, data.text, data.x, data.y, data.style_path)
end

function _Button:Ctor(name, text, x, y, stylePath)
    _Widget.Ctor(self, name, x, y)

    self._text = text
    self._style = require(stylePath)
    self._state = "normal"
    self._sprites = {
        normal = _Sprite.New(),
        light = _Sprite.New(),
        pressed = _Sprite.New(), 
    }
    self._sprites.normal:SetImage(self._style[1])
    self._sprites.light:SetImage(self._style[2])
    self._sprites.pressed:SetImage(self._style[3])

    if self._style[4] then -- disable image
        self._sprites.disable = _Sprite.New()
        self._sprites.disable:SetImage(self._style[4])
    end

    if self._style[5] then -- flash image
        self._sprites.flash = _Sprite.New()
        self._sprites.flash:SetImage(self._style[5])
    end

    self._flash = {alpha = 255, v = 5}
    self._color = _Color.New(250, 179, 0, 255)

    self.eventClick = _Event.New()

    self._dragging = false
    self._dragOffset = {x = 0, y = 0}
end 

function _Button:Draw()
    self._sprites[self._state]:SetRenderValue("position", self.x, self.y)
    self._sprites[self._state]:Draw()
    if self._text then
        self._color:Apply()
        local x = math.floor(self.x + (self._sprites.normal:GetWidth() - love.graphics.getFont():getWidth(self._text)) / 2) 
        local y = math.floor(self.y + (self._sprites.normal:GetHeight()- love.graphics.getFont():getHeight()) / 2) 
        _GRAPHICS.Print(self._text, x, y)
        self._color:Reset()
    end
    if self._sprites.flash then
        if self._flash.alpha >= 255 or self._flash.alpha <= 0 then
            self._flash.v = - self._flash.v
        end
        self._flash.alpha = self._flash.alpha + self._flash.v
        self._sprites.flash:SetRenderValue("color", 255, 255, 255, self._flash.alpha)
        self._sprites.flash:SetRenderValue("position", self.x, self.y)
        self._sprites.flash:Draw()
    end
end

function _Button:HandleEvent(msg, x, y)
    if msg == "MOUSE_MOVED" then
        if self._state == "pressed" then
            return
        end
        if self._sprites[self._state]:GetRect():CheckPoint(x, y) then
            self:SetState("light")
        else 
            self:SetState("normal")
        end
    elseif msg == "MOUSE_LEFT_PRESSED" then
        if self._sprites[self._state]:GetRect():CheckPoint(x, y) then
            self:SetState("pressed")
        end
    elseif msg == "MOUSE_LEFT_RELEASED" then
        if self._sprites[self._state]:GetRect():CheckPoint(x, y) then
            self:SetState("light")
            self.eventClick:Notify()
        else
            self:SetState("normal")
        end
    end
    
end 

function _Button:SetState(state)
    self._state = state or self._state
end

function _Button:Disable()
    if not self._sprites.disable then
        error("_Button:Disable()  the button does not have disable state image!")
    end
    self:SetState("disable")
end

return _Button 
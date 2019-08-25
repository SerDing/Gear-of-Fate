--[[
	Desc: Button widget
	Author: Night_Walker 
	Since: 2018-08-14 02:03:40 
	Last Modified time: 2018-08-14 02:03:40 
	Docs: 
		* Write more details here
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Button = require("Src.Core.Class")(_Widget) ---@class Button : Widget

local _RESMGR = require("Src.Resource.ResManager")
local _Sprite = require("Src.Core.Sprite")
local _ENUM = require("Src.GUI.ENUM")

function _Button:Ctor(name, text, x, y, stylePath)
    _Widget.Ctor(self, name, x, y)

    self.text = text
    self.styleTable = require(stylePath)
    assert(self.styleTable, "style table is null!")
    assert(_ENUM, "_Button:Ctor()  _ENUM is nil!")
    self.state = _ENUM.BUTTON_NORMAL
    self.spriteArr = {
        [_ENUM.BUTTON_NORMAL] = _Sprite.New(_RESMGR.pathHead .. self.styleTable[1]),
        [_ENUM.BUTTON_LIGHT] = _Sprite.New(_RESMGR.pathHead .. self.styleTable[2]),
        [_ENUM.BUTTON_PRESSED] = _Sprite.New(_RESMGR.pathHead .. self.styleTable[3]),
    }

    if self.styleTable[4] then -- disable image
        self.spriteArr[_ENUM.BUTTON_DISABLE] = _Sprite.New(_RESMGR.pathHead .. self.styleTable[4])
    end

    if self.styleTable[5] then -- flash image
        self.spriteArr["flash"] = _Sprite.New(_RESMGR.pathHead .. self.styleTable[5])
    end

    self.flash = {alpha = 255, v = 5}
    self.ClickEvent = function( ... ) end ---@type function
end 

function _Button:Draw()
    self.spriteArr[self.state]:Draw(self.x, self.y)
    if self.text then
        -- love.graphics.setColor(250, 179, 0, 255)
        local _x = math.floor(self.x + (self.spriteArr[_ENUM.BUTTON_NORMAL]:GetWidth() - love.graphics.getFont():getWidth(self.text)) / 2) 
        local _y = math.floor(self.y + (self.spriteArr[_ENUM.BUTTON_NORMAL]:GetHeight()- love.graphics.getFont():getHeight()) / 2) 
        love.graphics.print(self.text, _x, _y)
    end
    if self.spriteArr["flash"] then
        if self.flash.alpha >= 255 or self.flash.alpha <= 0 then
            self.flash.v = - self.flash.v
        end
        self.flash.alpha = self.flash.alpha + self.flash.v
        self.spriteArr["flash"]:SetColor(255, 255, 255, self.flash.alpha)
        self.spriteArr["flash"]:Draw(self.x, self.y)
    end
end

function _Button:HandleEvent(msg, x, y)
    print("_Button:HandleEvent(msg, x, y)", msg, x, y)
    if msg == "MOUSE_MOVED" then
        if love.mouse.isDown(1) and self.state == _ENUM.BUTTON_PRESSED then
            self.x, self.y = love.mouse.getPosition()
        end

        if self.state == _ENUM.BUTTON_PRESSED then
            return
        end
        if self.spriteArr[self.state]:GetRect():CheckPoint(x, y) then
            self:SetState(_ENUM.BUTTON_LIGHT)
        else 
            self:SetState(_ENUM.BUTTON_NORMAL)
        end
    elseif msg == "MOUSE_LEFT_PRESSED" then
        if self.spriteArr[self.state]:GetRect():CheckPoint(x, y) then
            self:SetState(_ENUM.BUTTON_PRESSED)
        end
    elseif msg == "MOUSE_LEFT_RELEASED" then
        if self.spriteArr[self.state]:GetRect():CheckPoint(x, y) then
            self:SetState(_ENUM.BUTTON_LIGHT)
            self.ClickEvent(self)
        else
            self:SetState(_ENUM.BUTTON_NORMAL)
        end
    end
    
end 

function _Button:SetState(s)
    self.state = s or self.state
end

function _Button:Disable()
    if not self.spriteArr[_ENUM.BUTTON_DISABLE] then
        error("_Button:Disable()  the button does not have disable state image!")
    end
    self:SetState(_ENUM.BUTTON_DISABLE)
end

function _Button:SetClickEvent(e)
    self.ClickEvent = e
end

return _Button 
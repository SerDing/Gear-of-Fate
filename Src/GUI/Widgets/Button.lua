--[[
	Desc: Button widget
	Author: Night_Walker 
	Since: 2018-08-14 02:03:40 
	Last Modified time: 2018-08-14 02:03:40 
	Docs: 
		* Write more details here
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Button = require("Src.Core.Class")(_Widget)

local _RESMGR = require("Src.Resource.ResManager")
local _Sprite = require("Src.Core.Sprite")
local _ENUM = require("Src.GUI.ENUM")

function _Button:Ctor(text, x, y, imageInfo, callback)
    self.text = text
    self.x = x or 0
    self.y = y or 0
    assert(imageInfo, "_Button:Ctor()  imageInfo is nil!")
    assert(_ENUM, "_Button:Ctor()  _ENUM is nil!")
    self.state = _ENUM.BUTTON_NORMAL
    self.spriteArr = {
        [_ENUM.BUTTON_NORMAL] = _Sprite.New(_RESMGR.pathHead .. imageInfo[1]),
        [_ENUM.BUTTON_LIGGHT] = _Sprite.New(_RESMGR.pathHead .. imageInfo[2]),
        [_ENUM.BUTTON_PRESSED] = _Sprite.New(_RESMGR.pathHead .. imageInfo[3]),
    }

    if imageInfo[4] then -- exists a disable image
        self.spriteArr[_ENUM.BUTTON_DISABLE] = _Sprite.New(_RESMGR.pathHead .. imageInfo[4])
    end

    if imageInfo[5] then -- exists a flash image
        self.spriteArr["flash"] = _Sprite.New(_RESMGR.pathHead .. imageInfo[5])
    end

    self.flash = {alpha = 255, v = 5}
    self.ClickEvent = callback or function( ... ) end
end 

function _Button:Draw()
    self.spriteArr[self.state]:Draw(self.x, self.y)
    if self.text then

        -- local r, g, b, a = love.graphics.getColor()
        -- love.graphics.setColor(250, 179, 0, 255)
        
        local _x = math.floor(self.x + (self.spriteArr[_ENUM.BUTTON_NORMAL]:GetWidth() - love.graphics.getFont():getWidth(self.text)) / 2) 
        local _y = math.floor(self.y + (self.spriteArr[_ENUM.BUTTON_NORMAL]:GetHeight()- love.graphics.getFont():getHeight()) / 2) 
        love.graphics.print(self.text, _x, _y)

        -- love.graphics.setColor(r, g, b, a)
    end
    if self.spriteArr["flash"] then
        if self.flash.alpha >= 255 or self.flash.alpha <= 0 then
            self.flash.v = - self.flash.v
        end
        self.flash.alpha = self.flash.alpha + self.flash.v
        self.spriteArr["flash"]:SetColor(255, 255, 255, self.flash.alpha)
        self.spriteArr["flash"]:Draw(x, y)
    end
end

function _Button:MessageEvent(msg, x, y)
    -- print("_Button:MessageEvent(msg, x, y)", msg, x, y)
    if msg == "MOUSE_MOVED" then
        if love.mouse.isDown(1) and self.state == _ENUM.BUTTON_PRESSED then
            self.x, self.y = love.mouse.getPosition()
        end

        if self.state == _ENUM.BUTTON_PRESSED then
            return
        end
        if self.spriteArr[self.state]:GetRect():CheckPoint(x, y) then
            self:SetState(_ENUM.BUTTON_LIGGHT)
        else 
            self:SetState(_ENUM.BUTTON_NORMAL)
        end
    elseif msg == "MOUSE_LEFT_PRESSED" then
        if self.spriteArr[self.state]:GetRect():CheckPoint(x, y) then
            self:SetState(_ENUM.BUTTON_PRESSED)
        end
    elseif msg == "MOUSE_LEFT_RELEASED" then
        if self.spriteArr[self.state]:GetRect():CheckPoint(x, y) then
            self:SetState(_ENUM.BUTTON_LIGGHT)
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
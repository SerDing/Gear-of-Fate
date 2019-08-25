--[[
	Desc: Frame widget
	Author: Night_Walker 
	Since: 2018-08-15 02:15:08 
	Last Modified time: 2018-08-15 02:15:08 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Frame = require("Src.Core.Class")(_Widget) ---@class Frame : Widget

local _Pop = require("Src.GUI.Widgets.Pop")

function _Frame:Ctor(name, x, y, w, h, stylePath)
    _Widget.Ctor(self, name, x, y)
    self.w = w or 0
    self.h = h or 0
    assert(stylePath, "_Frame:Ctor()  imageInfo is nil!")
    self.pop = _Pop.New(w, h, stylePath)
    self.area = {
        self.x + self.pop.spriteArr[0]:GetWidth() * 0.4, 
        self.y + self.pop.spriteArr[1]:GetHeight() * 0.35, 
        self.w + self.pop.spriteArr[5]:GetWidth() * 0.4, 
        self.h + self.pop.spriteArr[7]:GetHeight() * 0.55,
    }
end 

function _Frame:Draw()
    self.pop:Draw(self.x, self.y)
    -- love.graphics.setScissor(unpack(self.area))
    _Widget.Draw(self)
    -- love.graphics.setScissor()
end

function _Frame:HandleEvent(msg, x, y)
    _Widget.HandleEvent(self, msg, x, y)
end

return _Frame 
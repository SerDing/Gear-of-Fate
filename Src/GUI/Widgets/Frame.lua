--[[
	Desc: Frame widget
	Author: Night_Walker 
	Since: 2018-08-15 02:15:08 
	Last Modified time: 2018-08-15 02:15:08 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Frame = require("Src.Core.Class")(_Widget)


local _Pop = require("Src.GUI.Widgets.Pop")

function _Frame:Ctor(x, y, w, h, imageInfo)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
    assert(imageInfo, "_Frame:Ctor()  imageInfo is nil!")
    self.pop = _Pop.New(w, h, imageInfo)
    self.widgets = {}
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
    for i,v in ipairs(self.widgets) do
        v:Draw()
    end
    -- love.graphics.setScissor()
end

function _Frame:DispatchMessage(msg, x, y)
    for i,v in ipairs(self.widgets) do
        v:MessageEvent(msg, x, y)
    end
end

function _Frame:AddWidget(w)
    self.widgets[#self.widgets + 1] = w
end

return _Frame 
--[[
	Desc: Frame widget
	Author: SerDing
	Since: 2018-08-15 02:15:08 
	Last Modified time: 2018-08-15 02:15:08 

]]
local _Pop = require("system.gui.widgets.pop")
local _Widget = require("system.gui.widgets.widget")

---@class GUI.Widgets.Frame : GUI.Widgets.Base
local _Frame = require("core.class")(_Widget) 

function _Frame.NewWithData(data)
    return _Frame.New(data.name, data.x, data.y, data.w, data.h, data.style_path)
end

function _Frame:Ctor(name, x, y, w, h, stylePath)
    _Widget.Ctor(self, name, x, y)
    self.w = w or 0
    self.h = h or 0
    assert(stylePath, "_Frame:Ctor()  imageInfo is nil!")
    self.pop = _Pop.New(w, h, stylePath)
    self.area = {
        self.x + self.pop._sprites[0]:GetWidth() * 0.4, 
        self.y + self.pop._sprites[1]:GetHeight() * 0.35, 
        self.w + self.pop._sprites[5]:GetWidth() * 0.4, 
        self.h + self.pop._sprites[7]:GetHeight() * 0.55,
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
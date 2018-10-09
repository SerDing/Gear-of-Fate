--[[
	Desc: UI interface
	Author: Night_Walker 
	Since: 2018-08-14 16:36:24 
	Last Modified time: 2018-08-14 16:36:24 
	Docs: 
		* the unit consists of many widgets
]]

local _UI_Interface = require("Src.Core.Class")()

local _Button = require("Src.GUI.Widgets.Button")
local _Frame = require("Src.GUI.Widgets.Frame")

function _UI_Interface:Ctor(index, tag, layout)
    self.index = index
    self.tag = tag
    self.widgets = {}
    self.frames = {}
    if layout then
        for k,v in pairs(layout) do
            if k == "frames" then
                for i,f in ipairs(v) do
                    self:AddFrame(_Frame.New(unpack(f)))
                end
            elseif k == "buttons" then
                for i,b in ipairs(v) do
                    self:AddWidget(_Button.New(unpack(b)))
                end
            end
        end
    end
end 

function _UI_Interface:Draw(x, y)
    for i,v in ipairs(self.frames) do
        v:Draw()
    end
    for i,v in ipairs(self.widgets) do
        v:Draw()
    end
end

function _UI_Interface:DispatchMessage(msg, x, y)
    for i,v in ipairs(self.frames) do
        v:DispatchMessage(msg, x, y)
    end
    for i,v in ipairs(self.widgets) do
        v:MessageEvent(msg, x, y)
    end
end

function _UI_Interface:AddWidget(w)
    self.widgets[#self.widgets + 1] = w
end

function _UI_Interface:AddFrame(f)
    self.frames[#self.frames + 1] = f
end

function _UI_Interface:SetIndex(index)
    self.index = index
end

function _UI_Interface:GetWidgetById(id)
    for k,v in pairs(self.widgets) do
        if v.id and v.id == id then
            return v
        end
    end
end

return _UI_Interface 
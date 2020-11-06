--[[
	Desc: UI Panel
	Author: SerDing
	Since: 2018-08-14 16:36:24 
	Last Modified time: 2018-08-14 16:36:24 
	Docs: 
		* load and draw layouts as a tree structure on root widget
]]
---@class GUI.Panel
local _Panel = require("core.class")()

local _Queue = require("core.queue")
local _Widget = require("system.gui.widgets.widget")
local _LayoutMgr = require("system.gui.layoutmgr")

function _Panel:Ctor(name)
    self.name = name
    self.subjects = {}
    self.root = _Widget.New("root", 0, 0) ---@type Widget
end

---@param path string
function _Panel:LoadLayout(path)
    _LayoutMgr.LoadLayout(self, path)
end

function _Panel:Draw(x, y)
    self.root:Draw(x, y)
end

function _Panel:DispatchMessage(msg, x, y)
    self.root:HandleEvent(msg, x, y)
end

function _Panel:AddSubject(subject)
    self.subjects[#self.subjects + 1] = subject
end

function _Panel:GetWidgetById(id)
    local queue = _Queue.New(64)
    queue:Enqueue(self.root)
    while not queue:IsEmpty() do
        local w = queue:Dequeue()
        if w.name == id then
            return w
        end

        if w.subjects then
            for i = 1, #w.subjects do
                queue:Enqueue(w.subjects[i])
            end
        end
    end

    return nil
end

return _Panel
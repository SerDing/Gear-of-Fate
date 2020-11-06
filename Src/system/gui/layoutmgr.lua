--[[
	Desc: Layout manager for loading layout of panel
	Author: SerDing 
	Since: 2018-08-19 17:17:52 
	Alter: 2020-04-03 14:07
	Docs: 
		* layout is a tree structure for multiple widgets
]]
local _RESOURCE = require("engine.resource")

---@class GUI.LayoutManager
local _LayoutMgr = {}

---@param panel GUI.Panel
---@param path string @layout file path
function _LayoutMgr.LoadLayout(panel, path)
    local layout = _RESOURCE.ReadData("resource/data/ui/" .. path)
    assert(panel, "panel is null")
    assert(layout, "layout is null")
    _LayoutMgr._ApplyLayout(panel.root, layout) -- load start from root view
end

---@param parent GUI.Panel|Widget
---@param data table
function _LayoutMgr._ApplyLayout(parent, data)
    local widget = nil ---@type Widget

    for i = 1, #data do
        widget = _LayoutMgr.CreateWidget(data[i])
        parent:AddSubject(widget)
        if data[i].subjects and #data[i].subjects > 0 then
            _LayoutMgr._ApplyLayout(widget, data[i].subjects)
        end
    end
end

---@param data table
function _LayoutMgr.CreateWidget(data)
    local widget = require("system.gui.widgets." .. data.script).NewWithData(data)

    return widget
end

return _LayoutMgr 
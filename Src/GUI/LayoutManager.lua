--[[
	Desc: Layout manager for loading layout of interface
	Author: SerDing 
	Since: 2018-08-19 17:17:52 
	Last Modified time: 2018-08-19 17:17:52 
	Docs: 
		* layout is a tree structure for multiple widgets
]]

local _LayoutMgr = {}
local this = _LayoutMgr

local _Frame = require("Src.GUI.Widgets.Frame")
local _Button = require("Src.GUI.Widgets.Button")
local _Image = require("Src.GUI.Widgets.Image")
local _Label = require("Src.GUI.Widgets.Label")
local _HMP_Bar = require("Src.GUI.Widgets.HMP_Bar")
local _SkillShortcut = require("Src.GUI.Widgets.SkillShortcut")

function _LayoutMgr.Ctor()
    this.layoutPool = {}
end

---@param panel Panel
---@param path string @layout file path
function _LayoutMgr.LoadLayout(panel, path)
    local layout = require(path)
    assert(panel, "panel is null")
    assert(layout, "layout is null")
    this._LoadLayout(panel.root, layout) -- load start from root view
end

---@param parent Panel|Widget
---@param data table
function _LayoutMgr._LoadLayout(parent, data)
    local widget = nil ---@type Widget

    for i = 1, #data do
        widget = this.CreateWidget(data[i])
        parent:AddSubject(widget)
        if data[i].subjects and #data[i].subjects > 0 then
            this._LoadLayout(widget, data[i].subjects)
        end
    end
end

---@param wdata table
function _LayoutMgr.CreateWidget(wdata)
    assert(wdata.script, "widget data is null")
    local w = nil ---@type Widget

    if wdata.script == "frame" then
        w = _Frame.New(wdata.name, wdata.x, wdata.y, wdata.w, wdata.h, wdata.style_path)
    elseif wdata.script == "image" then
        w = _Image.New(wdata.name, wdata.img_path, wdata.x, wdata.y, wdata.r or 0, wdata.sx or 1, wdata.sy or 1)
    elseif wdata.script == "button" then
        w = _Button.New(wdata.name, wdata.text, wdata.x, wdata.y, wdata.style_path)
    elseif wdata.script == "hmp_bar" then
        w = _HMP_Bar.New(wdata.name, wdata.x, wdata.y, wdata.style_path)
    elseif wdata.script == "skill_shortcut" then
        w = _SkillShortcut.New(wdata.name, wdata.x, wdata.y, wdata.is_origin, wdata.img_path)
    end

    return w
end

return _LayoutMgr 
--[[
	Desc: UI Panel
	Author: SerDing
	Since: 2018-08-14 16:36:24 
	Last Modified time: 2018-08-14 16:36:24 
	Docs: 
		* load and draw layout as a tree structure on root widget
]]
local _Queue = require("core.queue")
local _Stack = require("core.stack")
local _GRAPHICS = require("engine.graphics")
local _RESOURCE = require("engine.resource")
local _Widget = require("system.gui.widget.widget")

---@class GUI.Panel
---@field public name string
---@field public root GUI.Widgets.Base
---@field protected _setToCenterOnEnable boolean
local _Panel = require("core.class")()

function _Panel:Ctor(name)
    self.name = name
    self.root = _Widget.New("root", 0, 0)
    self.root.wtype = "container"
    self._width = 0
    self._height = 0
    self._setToCenterOnEnable = true
end

function _Panel:OnEnable()
    local w, h = _GRAPHICS.GetOriginDimension()

    if self._setToCenterOnEnable then
        self.root:SetPosition((w - self._width) / 2, (h - self._height) / 2)
    end
end

---@param path string @layout file path
function _Panel:LoadLayout(path)
	local layout = _RESOURCE.LoadUiData(path)
    assert(layout, "layout is null")

    ---@param data table
    ---@return GUI.Widgets.Base
    local function _CreateWidget(data)
        local widget = require("system.gui.widget." .. data.script).NewWithData(data)

        return widget
    end
	-- create widgets by data (a variant of depth-first-search)
    local parentStack = _Stack.New(10)
    local dataStack = _Stack.New(50)
    local parent = self.root
    local emptyTable = {}
    for i = #layout, 1, -1 do
        dataStack:Push(layout[i])
    end
    while not dataStack:IsEmpty() do
        local data = dataStack:Pop()
        local widget ---@type GUI.Widgets.Base
        if data == emptyTable then -- emptyTable means switch to previous parent widget
            parent = parentStack:Pop()
        else
            widget = _CreateWidget(data)
            parent:AddChild(widget)
            widget:Init()
            widget:SetParent(parent) --set parent to get upperRenderValue
        end

        -- process data of sub widgets
        if data.subjects and #data.subjects > 0 then
            parentStack:Push(parent)
            parent = widget
            dataStack:Push(emptyTable) -- push emptyTable as mark for switching parent widget
            for i = #data.subjects, 1, -1 do
                dataStack:Push(data.subjects[i])
            end
        end
    end

    self._width, self._height = self.root:GetChild(1):GetSize()
end

function _Panel:Draw()
    self.root:DrawChildren()
end

function _Panel:OnDisable()

end

function _Panel:GetWidgetById(id)
    local widget = nil
    
    ---@param w GUI.Widgets.Base
    local function GetWidget(w)
        if not widget and w.name == id then
            widget = w
            return true
        end
    end
    _Panel.DoForWidgets(self, GetWidget)

    return widget
end

---@alias opfunc fun(w:GUI.Widgets.Base, ...:any)
---@param func opfunc
---@param ... any
function _Panel:DoForWidgets(func, ...)
	local queue = _Queue.New(64)
    queue:Enqueue(self.root)
    while not queue:IsEmpty() do
        local w = queue:Dequeue() ---@type GUI.Widgets.Base
        local finish = func(w, ...)
        if finish then
            break
        end

        if w.wtype == "container" and w._children then
            for i = 1, #w._children do
                local child = w._children[i]
                if child.wtype then
                    queue:Enqueue(child)
                end
            end
        end
    end
end

return _Panel
--[[
    Desc: Panel of inventory.
    Author: SerDing
    Since: 2019-08-11T23:52:49.403Z+08:00
    Alter: 2020-11-06T20:29:56.423Z+08:00
]]

local _Panel = require("system.gui.panels.panel")

---@class GUI.Panel.Inventory : GUI.Panel
---@field protected _button GUI.Widgets.Button
local _Inventory = require("core.class")(_Panel) 


function _Inventory:Ctor()
    _Panel.Ctor(self, "inventory")
    self:LoadLayout("layout/inventory")
    self._button = self:GetWidgetById("button1")
    self._button.onClick:AddListener(nil, function() print("inventory button pressed.") end)
end

function _Inventory:Draw(x, y)
    _Panel.Draw(self, x, y)
end

function _Inventory:DispatchMessage(msg, x, y)
    _Panel.DispatchMessage(self, msg, x, y)
end

return _Inventory

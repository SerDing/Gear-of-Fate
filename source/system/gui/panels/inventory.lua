--[[
    Desc: Panel of inventory.
    Author: SerDing
    Since: 2019-08-11T23:52:49.403Z+08:00
    Alter: 2020-11-06T20:29:56.423Z+08:00
]]
local _GAME = require("game")
local _Panel = require("system.gui.panels.panel")

---@class GUI.Panel.Inventory : GUI.Panel
---@field protected _button GUI.Widgets.Button
local _Inventory = require("core.class")(_Panel) 

local function _OnFinBtnClick()
    _GAME.Quit()
end

function _Inventory:Ctor()
    _Panel.Ctor(self, "inventory")
    _Panel.LoadLayout(self, "layout/inventory")
end

function _Inventory:OnEnable()
    _Panel.OnEnable(self)
    self._button = self:GetWidgetById("button1")
    self._button.onClick:AddListener(nil, _OnFinBtnClick)
end

function _Inventory:Draw(x, y)
    _Panel.Draw(self, x, y)
end

function _Inventory:OnDisable()
    _Panel.OnDisable(self)
    self._button.onClick:DelListener(nil, _OnFinBtnClick)
end

return _Inventory

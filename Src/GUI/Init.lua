--[[
	Desc: Initialization for GUI
	Author: Night_Walker 
	Since: 2018-08-14 18:00:44 
	Last Modified time: 2018-08-14 18:00:44 
	Docs: 
        * Each interface has a private function to init and return the reference of self finally
        * InitGUI() add every interface to _UIMGR as a member
]]

local _UIMGR = require "Src.GUI.UI_Manager"

local _LayoutMgr = require "Src.GUI.LayoutManager"

local _Interface = require("Src.GUI.UI_Interface")
local _Frame = require("Src.GUI.Widgets.Frame")
local _Button = require("Src.GUI.Widgets.Button")
local _Image = require("Src.GUI.Widgets.Image")
local _Label = require("Src.GUI.Widgets.Label")
local _HMP_Bar = require("Src.GUI.Widgets.HMP_Bar")

local _ENUM = require "Src.GUI.ENUM"

local function InitInterface_HUD()
    local _Interface_HUD = _Interface.New(_ENUM.INDEX_HUD, "HUD")
    _LayoutMgr.InitLayout(_Interface_HUD, "HUD")
    return _Interface_HUD
end

local function InitInterface_Loading()
    local _Interface_Loading = _Interface.New(_ENUM.INDEX_LOADING, "loading")
    local _button = _Button.New("button", 100, 100, require("Data/ui/buttons/small"))
    
    _Interface_Loading:AddWidget(_button)

    return _Interface_Loading
end

local function InitGUI()
    love.graphics.setFont(love.graphics.newFont("Font/simsun_bitmap_fnt/simsun12.fnt"))
    _UIMGR.Ctor()
    _LayoutMgr.Ctor()
    _UIMGR.AddInterface(InitInterface_HUD())
    
end

InitGUI()



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
local _Grid_Skill = require("Src.GUI.Widgets.Grid_Skill")
local _ENUM = require "Src.GUI.ENUM"

local function InitInterface_HUD()
    local _key = "HUD"
    local _Interface_HUD = _Interface.New(_ENUM.INDEX_HUD, "HUD")
    _LayoutMgr.InitLayout(_Interface_HUD, "HUD")

    --[[ skill_id  skl_file_path
		8	`Swordman/TripleSlash.skl`
		16	`Swordman/AshenFork.skl`
		40	`Swordman/Reckless.skl`
		46	`Swordman/UpperSlash.skl`
		58	`Swordman/VaneSlash.skl`
		64	`Swordman/GoreCross.skl`
		65	`Swordman/HopSmash.skl`
		76	`Swordman/Frenzy.skl`
		77	`Swordman/MoonlightSlash.skl`
		169	`Swordman/BackStep.skl`
    ]]
    
    local _sklGUIData = {
        [1] = {
            [1] = 46,   -- Q
            [2] = 0,    -- W
            [3] = 77,   -- E
            [4] = 16,   -- R
            [5] = 0,    -- T
            [6] = 169,  -- Y
        },
        [2] = {
            [1] = 65,   -- A
            [2] = 64,   -- S
            [3] = 0,    -- D
            [4] = 8,    -- F
            [5] = 0,    -- G
            [6] = 76,   -- H
        },
        -- {46, 0, 77, 16, 0, 169},
        -- {65, 64, 0, 8, 0, 76},
    }
    
    local _skillGrid -- temp skill grid ref
    for y = 1, 2 do
        for x = 1, 6 do
            _skillGrid = _Interface_HUD:GetWidgetById("skill_grid_" .. tostring(y) .. tostring(x))
            _skillGrid:SetSkill(_sklGUIData[y][x])
        end
    end

    return _key, _Interface_HUD
end

local function InitInterface_Loading()
    local _key = "Loading"
    local _Interface_Loading = _Interface.New(_ENUM.INDEX_LOADING, "Loading")
    _LayoutMgr.InitLayout(_Interface_HUD, "Loading")
    
    return _key, _Interface_Loading
end

local function InitInterface_Inventory()
    local _key = "Inventory"
    local _Panel_Inventory = _Interface.New(_ENUM.INDEX_LOADING, "Inventory")
    _LayoutMgr.InitLayout(_Panel_Inventory, "Inventory")
    local _button = _Button.New("学习技能", 690, 40, require("Data/ui/buttons/small"))
    _Panel_Inventory:AddWidget(_button)

    return _key, _Panel_Inventory
end

local function InitGUI()
    love.graphics.setFont(love.graphics.newFont("Font/simsun_bitmap_fnt/simsun12.fnt"))
    _UIMGR.Ctor()
    _LayoutMgr.Ctor()
    _UIMGR.AddInterface(InitInterface_HUD())
    _UIMGR.AddInterface(InitInterface_Inventory())
end

return InitGUI
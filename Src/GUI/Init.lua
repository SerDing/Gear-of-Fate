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
    local _Interface_HUD = _Interface.New(_ENUM.INDEX_HUD, "HUD")
    _LayoutMgr.InitLayout(_Interface_HUD, "HUD")


    
    local _Grid_Skill_Grp = {{}, {}}
    for y = 1, 2 do
        for x = 1, 6 do
            _Grid_Skill_Grp[y][x] = _Grid_Skill.New(19 + (30 + 3) * (x - 1), 62 + (30 + 4) * (y - 1), 0, false)
        end
    end


    --[[
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
    

    local _skillSet = {
        {x = 4, y = 2, id = 8}, 
        {x = 4, y = 1, id = 16}, 
        {x = 1, y = 1, id = 46}, 
        {x = 2, y = 2, id = 64}, 
        {x = 1, y = 2, id = 65}, 
        {x = 6, y = 2, id = 76}, 
        {x = 3, y = 1, id = 77}, 
        {x = 6, y = 1, id = 169}, 
    }
    for k,v in pairs(_skillSet) do
        _Grid_Skill_Grp[v.y][v.x]:SetSkill(v.id)
    end
    

    for y = 1, 2 do
        for x = 1, 6 do
            _Interface_HUD.frames[1]:AddWidget(_Grid_Skill_Grp[y][x])
        end
    end

    return _Interface_HUD
end

local function InitInterface_Loading()
    local _Interface_Loading = _Interface.New(_ENUM.INDEX_LOADING, "loading")
    -- local _button = _Button.New("button", 100, 100, require("Data/ui/buttons/small"))
    -- _Interface_Loading:AddWidget(_button)

    return _Interface_Loading
end

local function InitGUI()
    love.graphics.setFont(love.graphics.newFont("Font/simsun_bitmap_fnt/simsun12.fnt"))
    _UIMGR.Ctor()
    _LayoutMgr.Ctor()
    _UIMGR.AddInterface(InitInterface_HUD()) 
end

InitGUI()



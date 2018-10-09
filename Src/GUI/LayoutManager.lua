--[[
	Desc: Layout manager for loading layout of interface
	Author: SerDing 
	Since: 2018-08-19 17:17:52 
	Last Modified time: 2018-08-19 17:17:52 
	Docs: 
		* Write more details here 
]]

local _LayoutMgr = {}
local this = _LayoutMgr

local _Frame = require("Src.GUI.Widgets.Frame")
local _Button = require("Src.GUI.Widgets.Button")
local _Image = require("Src.GUI.Widgets.Image")
local _Label = require("Src.GUI.Widgets.Label")
local _HMP_Bar = require("Src.GUI.Widgets.HMP_Bar")
local _Grid_Skill = require("Src.GUI.Widgets.Grid_Skill")
local _SCENEMGR = require "Src.Scene.GameSceneMgr" 

local function InitFrames(interface, frames)
    --[[
        ['frames'] = {
            {20, 50, 100, 70, require("Data/ui/popup/normal")},
        },
    ]]
    for i,v in ipairs(frames) do
        local _f = _Frame.New(unpack(v))
        interface:AddFrame(_f)
    end
end

local function InitHMP_Bars(interface, HMP_Bars)
    --[[
        ['HMP_Bars'] = {
            -- {frameIndex, x, y, imageInfo, model, controller, isDraw(是否即刻显示)}
            {1, 70, 25, require("Data/ui/progressbar/hp"), "Hero/Model/HP", nil, false},
            {1, 70, 25, require("Data/ui/progressbar/mp"), "Hero/Model/MP", nil, false},
        },
    ]]
    for i,v in ipairs(HMP_Bars) do
        local _model = nil
        local _controller = nil
        local hero_ = nil
        local _tmpArr = split(v[5], "/")

        if _tmpArr[1] == "Hero" and _tmpArr[2] == "Model" then
            hero_ = _SCENEMGR.GetHero_()
            print("LayoutMgr is getting hero's model:", _tmpArr[3])
            _model = hero_:GetModel(_tmpArr[3])
        end

        if v[6] then -- it exists a controller info
            _tmpArr = split(v[6], "/")
            _controller = require(this.ctrllerPath .. _tmpArr[1])[_tmpArr[2]]
        end
        
        local _b = _HMP_Bar.New(v[2], v[3], v[4], _model, _controller, v[7])
        -- interface.frames[v[1]]:AddWidget(_b)
        interface:AddWidget(_b)
    end
end

local function InitImages(interface, Images)
    --[[
        ['Images'] = {
            -- {frameIndex, "single", path, x, y},
            -- {frameIndex, "batch", path, x, y, blank_x, blank_y, num_x, num_y},
            {1, "batch","interface/windowcommon.img/57.png", 19, 62, 3, 4, 6, 2},
        },
    ]]
    for i,v in ipairs(Images) do
        local _image
        local _batch = {}
        local _tmpImage = _Image.New(v[3], 0, 0) -- temp image widget to get dimentsion info
        local _w = _tmpImage.spr:GetWidth()
        local _h = _tmpImage.spr:GetHeight()
        if v[2] == "batch" then
            for i = 1, v[9] do
                for k = 1, v[8] do
                    if not _batch[i] then
                        _batch[i] = {}
                    end
                    _batch[i][k] = _Image.New(v[3], v[4] + (_w + v[6]) * (k - 1), v[5] + (_h + v[7]) * (i - 1))
                end
            end
            -- add all images in _batch
            for i = 1, v[9] do
                for k = 1, v[8] do
                    -- interface.frames[v[1]]:AddWidget(_batch[i][k])
                    interface:AddWidget(_batch[i][k])
                end
            end

        elseif v[2] == "single" then
            print("GUI_Init.InitImages() single image path:", v[3])
            _image = _Image.New(v[3], v[4], v[5], v[6], v[7], v[8])
            -- interface.frames[v[1]]:AddWidget(_image)
            interface:AddWidget(_image)
        else
            error("_LayoutMgr.InitImages()  the type of one image item is unknown.")
        end
        
    end
end

local function Init_SkillGrids(interface, data)
    --[[
        -- x, y, id, absKey, origin
        ['Grid_Skill'] = {
            -- {frameIndex, "single", x, y, id, absKey, origin},
            -- {frameIndex, "batch", x, y, id, absKey, origin, blank_x, blank_y, num_x, num_y},
            {"skill_grid_11", "single", 19 , 62, 0, "SKL_Q", false},
            ...
        },
    ]]

    for i,v in ipairs(data) do
        local _grid
        local _group = {}
        local _w = 30
        local _h = 30
        if v[2] == "group" then
            for i = 1, v[11] do
                for k = 1, v[10] do
                    if not _group[i] then
                        _group[i] = {}
                    end
                    _group[i][k] = _Grid_Skill.New(v[3], v[4] + (_w + v[8]) * (k - 1), v[5] + (_h + v[9]) * (i - 1), v[6], v[7])
                end
            end
            -- add all grids in _group
            for i = 1, v[11] do
                for k = 1, v[10] do
                    -- interface.frames[v[1]]:AddWidget(_group[i][k])
                    interface:AddWidget(_group[i][k])
                end
            end

        elseif v[2] == "single" then
            _grid = _Grid_Skill.New(v[1], v[3], v[4], v[5], v[6], v[7])
            -- interface.frames[v[1]]:AddWidget(_grid)
            interface:AddWidget(_grid)
        else
            error("_LayoutMgr.Init_SkillGrids()  the type of one image item is unknown.")
        end
    end
end

function _LayoutMgr.Ctor()
    this.pathHead = "Data/ui/layout/"
    this.ctrllerPath = "Src/GUI/Controller/"
    this.funcsMap = {
        -- {key, func},
        {'frames', InitFrames},
        {'HMP_Bars', InitHMP_Bars},
        {'Images', InitImages},
        {'SkillGrids', Init_SkillGrids},
        
    }
    this.layoutPool = {}
end 

function _LayoutMgr.InitLayout(interface, fileName)
    local _layout = require(this.pathHead .. fileName)
    for i,v in ipairs(this.funcsMap) do
        if _layout[v[1]] then
            v[2](interface, _layout[v[1]])
        end
    end
end 

-- function _LayoutMgr.Insert(layoutRef)
--     this.layoutPool[#this.layoutPool + 1] = layoutRef
-- end

return _LayoutMgr 
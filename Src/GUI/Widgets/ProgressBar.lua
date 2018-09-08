--[[
	Desc: ProgressBar widget
	Author: Night_Walker 
	Since: 2018-08-17 17:29:59 
	Last Modified time: 2018-08-17 17:29:59 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _ProgressBar = require("Src.Core.Class")(_Widget)

local _RESMGR = require("Src.Resource.ResManager")
local _Sprite = require("Src.Core.Sprite")

function _ProgressBar:Ctor(x, y, imageInfo, model, controller)
    self.x = x or 0
    self.y = y or 0
    assert(imageInfo, "_ProgressBar:Ctor()  imageInfo is nil!")
    self.upperLayer = _Sprite.New(_RESMGR.pathHead .. imageInfo[1])
    if imageInfo[2] then
        self.bottomLayer = _Sprite.New(_RESMGR.pathHead .. imageInfo[2])
    end

    self.model = model
    self.controller = controller
    self.percent = 1
    self.draggable = false
end 

function _ProgressBar:Draw()
    if self.bottomLayer then
        self.bottomLayer:Draw(self.x, self.y)
    end
    self.upperLayer:SetDrawArea(0, 0, self.upperLayer:GetWidth() * self.percent, self.upperLayer:GetHeight())
    self.upperLayer:Draw(self.x, self.y)
end

function _ProgressBar:Sync()
    self.cur = self.model:GetCur()
    self.max = self.model:GetMax()
    self.percent = self.cur / self.max
end

function _ProgressBar:SetPercent(v)
    self.percent = v
end

function _ProgressBar:MessageEvent(msg, x, y)
    -- print("_Button:MessageEvent(msg, x, y)", msg, x, y)
    if msg == "MOUSE_MOVED" then
        if love.mouse.isDown(1) and self.draggable then
            self.x, self.y = love.mouse.getPosition()
        end
    elseif msg == "MOUSE_LEFT_PRESSED" then
        if self.upperLayer:GetRect():CheckPoint(x, y) then
            self.draggable = true
        else
            self.draggable = false
        end
    end
    
end 

return _ProgressBar 
--[[
	Desc: ProgressBar widget
	Author: Night_Walker 
	Since: 2018-08-17 17:29:59 
	Last Modified time: 2018-08-17 17:29:59 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _ProgressBar = require("Src.Core.Class")(_Widget) ---@class ProgressBar : Widget

local _RESMGR = require("Src.Resource.ResManager")
local _Sprite = require("Src.Core.Sprite")

function _ProgressBar:Ctor(name, x, y, stylePath)
    _Widget.Ctor(self, name, x, y)
    self.styleTable = require(stylePath)
    assert(self.styleTable, "style table is null!")
    self.upperLayer = _Sprite.New(_RESMGR.pathHead .. self.styleTable[1]) ---@type Sprite
    if self.styleTable[2] then
        self.bottomLayer = _Sprite.New(_RESMGR.pathHead .. self.styleTable[2])
    end

    self.percent = 1
    self.draggable = false
    self.dragOffset = {x = 0, y = 0}
end 

function _ProgressBar:Draw()
    if self.bottomLayer then
        self.bottomLayer:Draw(self.x, self.y)
    end
    self.upperLayer:SetDrawArea(
            0, 0, self.upperLayer:GetWidth() * self.percent, self.upperLayer:GetHeight(),
            self.translate.x,
            self.translate.y
    )
    self.upperLayer:Draw(self.x, self.y)
end

function _ProgressBar:HandleEvent(msg, x, y)
    if msg == "MOUSE_MOVED" then
        if love.mouse.isDown(1) and self.draggable then
            self.x = x - self.dragOffset.x
            self.y = y - self.dragOffset.y
        end
    elseif msg == "MOUSE_LEFT_PRESSED" then
        if self.upperLayer:GetRect():CheckPoint(x, y) then
            self.draggable = true
            self.dragOffset.x = x - self.x
            self.dragOffset.y = y - self.y
        else
            self.draggable = false
        end
    end
    
end



return _ProgressBar 
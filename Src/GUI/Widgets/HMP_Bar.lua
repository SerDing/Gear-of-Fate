--[[
	Desc: HP/MP Bar inherit from ProgressBar
	Author: Night_Walker 
	Since: 2018-08-17 18:08:53 
	Alter: 2018-8-18 01:31:44
	Docs: 
		* Write more details here 
]]
local _ProgressBar = require("Src.GUI.Widgets.ProgressBar")
local _HMP_Bar = require("Src.Core.Class")(_ProgressBar)

local _Sprite = require("Src.Core.Sprite")
local _RESMGR = require("Src.Resource.ResManager")

function _HMP_Bar:Ctor(x, y, imageInfo, model, controller, drawAble)
    _ProgressBar.Ctor(self, x, y, imageInfo, model, controller)
    self.max = 100
    self.cur = 100
    self.percent = self.cur / self.max
    self.drawable = drawAble
end 

function _HMP_Bar:Draw(x, y, cam_x, cam_y)
    if x and y then
        self:SetPos(x, y)
    end
    if self.drawable then
        self:Sync()
        if self.bottomLayer then
            self.bottomLayer:Draw(self.x, self.y)
        end
        local _x, _y = self:CalcPos(self.upperLayer, self.bottomLayer)
        self.upperLayer:SetDrawArea(0, 0, self.upperLayer:GetWidth() * self.percent, self.upperLayer:GetHeight(), cam_x, cam_y)
        self.upperLayer:Draw(_x, _y)
    end
end

function _HMP_Bar:SetPos(x, y)
    self.x, self.y = x, y
end

function _HMP_Bar:GetWidth()
    return self.bottomLayer:GetWidth() or self.upperLayer:GetWidth()
end

function _HMP_Bar:GetHeight()
    return self.bottomLayer:GetHeight() or self.upperLayer:GetHeight()
end

function _HMP_Bar:CalcPos(upper, bottom)
    return self.x + (bottom:GetWidth() - upper:GetWidth()) / 2, self.y + (bottom:GetHeight() - upper:GetHeight()) / 2
end

return _HMP_Bar 
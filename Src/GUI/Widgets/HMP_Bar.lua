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

function _HMP_Bar:Draw()
    if self.drawable then
        self:Sync()
        if self.bottomLayer then
            self.bottomLayer:Draw(self.x, self.y)
        end
        self.upperLayer:SetDrawArea(0, 0, self.upperLayer:GetWidth() * self.percent, self.upperLayer:GetHeight())
        self.upperLayer:Draw(self.x, self.y)
    end
end

return _HMP_Bar 
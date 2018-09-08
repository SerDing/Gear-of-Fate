--[[
	Desc: Image widget in GUI
	Author: Night_Walker 
	Since: 2018-08-16 03:08:33 
	Last Modified time: 2018-08-16 03:08:33 
	Docs: 
		* Write more details here 
]]
local _Widget = require("Src.GUI.Widgets.Widget")
local _Image = require("Src.Core.Class")(_Widget)

local _Sprite = require("Src.Core.Sprite")
local _RESMGR = require("Src.Resource.ResManager")

function _Image:Ctor(path, x, y, rotation, sx, sy)
    self.spr = _Sprite.New(_RESMGR.pathHead .. path)
    self.x = x or 0
    self.y = y or 0
    self.rotation = rotation or 0
    self.sx = sx or 1
    self.sy = sy or 1
    self.area = {x = 0, y = 0, w = self.spr:GetWidth(), h = self.spr:GetHeight()}
end 

function _Image:Draw()
    self.spr:Draw(self.x - self.area.x, self.y - self.area.y, self.rotation, self.sx, self.sy)
end

function _Image:SetDrawArea(x, y, w, h)
    self.spr:SetDrawArea(x, y, w, h)
end

return _Image 
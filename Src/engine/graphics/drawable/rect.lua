--[[
	Desc: Rectangle
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2020-09-11 11:37:50
]]
local _Base = require("engine.graphics.drawable.base")
local _Color = require("engine.graphics.config.color")
local _GRAPHICS = require("engine.graphics.graphics")
local _Vector2 = require("utils.vector2")

---@class Engine.Graphics.Drawable.Rect
local _Rect = require("core.class")()

function _Rect:Ctor(x, y, w, h)
	self._x = x or 0
	self._y = y or 0
	self._xw = 0
	self._yh = 0
	self._width = w or 1
	self._height = h or 1
	self._scale = _Vector2.New(1, 1)
	self._center = _Vector2.New(0, 0)
	
	self:Update()
end

function _Rect:Update()
	self._xw = self._x + self._width
	self._yh = self._y + self._height
end

---@param color Engine.Graphics.Config.Color
function _Rect:Draw(color, style)
	if color then
		_GRAPHICS.SetColor(color:Get())
	end

	_GRAPHICS.DrawRect(style, self._x, self._y, self._width, self._height)

	if color then
		_GRAPHICS.ResetColor()
	end
end

function _Rect:SetDrawData(x, y, w, h)
	self._x = x or 0
	self._y = y or 0
	self._width = w or self._width
	self._height = h or self._height
	self:Update()
end

function _Rect:SetPosition(x, y)
	self._x = x or 0
	self._y = y or 0
	self:Update()
end

function _Rect:SetSize(w, h)
	self._width = w or self._width
	self._height = h or self._height
	self:Update()
end

function _Rect:CheckPoint(x, y)
	self:Update()

	if x >= self._x and x <= self._xw  then
		if y >= self._y and y <= self._yh then
			return true
		end 
	end 
	
	return false 
end

---@param rect Engine.Graphics.Drawable.Rect
function _Rect:CheckRect(rect)
	local lx = self._x
	local lxw = self._xw
	local ly = self._y
	local lyh = self._yh
	local rx = rect:Get("x")
	local rxw = rect:Get("xw")
	local ry = rect:Get("y")
	local ryh = rect:Get("yh")
	local bx, by = math.max(lx, rx), math.max(ly, ry)
	local cx, cy = bx + (math.min(lxw, rxw) - bx) / 2, by + (math.min(lyh, ryh) - by) / 2
	return lx <= rxw and lxw >= rx and ly <= ryh and lyh >= ry, cx, cy
end

function _Rect:Get(field)
	if field then
		return self["_" .. field]
	end
end

function _Rect:GetWidth()
	return self._width
end

function _Rect:GetHeight()
	return self._height
end

return _Rect
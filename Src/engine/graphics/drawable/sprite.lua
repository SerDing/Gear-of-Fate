--[[
	Desc: Sprite class
 	Author: SerDing
	Since: 2017-07-26 23:41:15
	Alter: 2020-02-10 02:11:12
]]

local _Vector2 = require("utils.vector2")
local _GRAPHICS = require("engine.graphics.graphics")
local _RESOURCE = require('engine.resource')
local _Rect = require("core.rect")
local _Color = require("engine.graphics.config.color")
local _Base = require("engine.graphics.drawable.base") 

---@class Engine.Graphics.Drawable.Sprite:Engine.Graphics.Drawable.Base 
local _Sprite = require("core.class")(_Base)

---@class Engine.Graphics.Drawable.SpriteData
---@field public image string | Image
---@field public ox float
---@field public oy float
---@field public sx float
---@field public sy float
---@field public blendMode string
--[[
	---@field public angle float 
	---@field public color Engine.Graphics.Config.Color
]]
local _SpriteData = require("core.class")()

local _emptyTable = {}

---@param data Engine.Graphics.Drawable.SpriteData
function _Sprite:Ctor(data)
	_Base.Ctor(self)
	self._quad = love.graphics.newQuad(0, 0, 1, 1, 1,1)
	self.rect = _Rect.New(0, 0, 1, 1)
	self.rect:SetColor(255, 255, 255, 150)
	self.rect:SetDrawType("line")

	if data then
		self:SetData(data)
	end
end

function _Sprite:_OnDraw()
	_Base.DrawObj(self, self.image)
	
	self.rect:SetPos(self._actualValues.position:Get())
	self.rect:SetScale(self._actualValues.scale:Get())
	if gDebug then
		self.rect:Draw()
	end
end

---@param data Engine.Graphics.Drawable.SpriteData
function _Sprite:SetData(data)
	data = data or _emptyTable
	self._data = data
	
	local ox = data.ox or 0
	local oy = data.oy or 0
	local sx = data.sx or 1
	local sy = data.sy or 1
	local angle = data.angle or 0
	local blendmode = data.blendmode or "alpha"

	self:SetImage(data.image)
	self:SetRenderValue("blendmode", blendmode)
	self:SetRenderValue("origin", ox, oy)
	self.rect:SetOrigin(ox, oy)
	self:SetRenderValue("scale", sx, sy)
	self:SetRenderValue("radian", angle)
end

function _Sprite:SetImage(image)
	if image == nil then
		self.image = _RESOURCE.nullImg
	else
		if image == self.image then
			return
		end
		if type(image) == "string" then
			self.image = _RESOURCE.LoadImage(image)
		else
			self.image = image
		end
	end
	self:SetQuad(0, 0, self.image:getDimensions())
	self.rect:SetSize(self.image:getDimensions())
end

---@param x number @ drawing area x
---@param y number @ drawing area y
---@param w number @ drawing area w
---@param h number @ drawing area h
function _Sprite:SetQuad(x, y, w, h)
	self._quad:setViewport(x, y, w, h, self.image:getDimensions())
	self.rect:SetSize(w, h)
end

function _Sprite:SetOrigin(x, y)
	self:SetRenderValue("origin", x, y)
	self.rect:SetOrigin(x, y)
end

function _Sprite:GetImage()
	return self.image
end

function _Sprite:GetRect()
	return self.rect
end

function _Sprite:GetWidth()
	return self.image:getWidth()
end

function _Sprite:GetHeight()
	return self.image:getHeight()
end

return _Sprite
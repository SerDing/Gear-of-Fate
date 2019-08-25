--[[
	Desc: Rectangle (basic 2d shape)
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 11:37:50
	Docs:
		*Write notes here even more
]]


local _Rect = require("Src.Core.Class")() ---@class Rect

function _Rect:Ctor(x, y, w, h) --initialize
	self.pos = {x = 0.0, y = 0.0}
	self.size = {w = 0, h = 0}
	self.scale = {x = 1, y = 1}
	self.cenPos = {x = 0.0, y = 0.0}
	self.vertex = {
		[1] = {x = 0, y = 0},
		[2] = {x = 0, y = 0},
	}
	
	self.pos.x = x or 0.0
	self.pos.y = y or 0.0
	self.size.w = w or 0
	self.size.h = h or 0

	self.dir = 1
	
	self:Update()

	self.color = {
	r = 0,
	g = 0,
	b = 255,
	a = 180
	}
	
	self.drawTypes = {
		[0] = "fill",
		[1] = "line",
	}
	self:SetDrawType(0)
	self:Update()
end

function _Rect:Update()
	self.x1 = self.pos.x - self.cenPos.x * self.scale.x * self.dir
	self.y1 = self.pos.y - self.cenPos.y * self.scale.y
	self.x2 = self.x1 + self.size.w * self.scale.x * self.dir
	self.y2 = self.y1 + self.size.h * self.scale.y
end

function _Rect:Draw()
	
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	
	self:Update()

	love.graphics.rectangle( self.type,
		self.x1,
		self.y1,
		self.size.w * self.scale.x * self.dir ,
		self.size.h * self.scale.y 
	)

	love.graphics.setColor(r,g,b,a)

end

function _Rect:SetPos(x, y)
	self.pos.x = x
	self.pos.y = y
	self:Update()
end

function _Rect:SetSize(w, h)
	self.size.w = w or 0
	self.size.h = h or 0
	self:Update()
end

function _Rect:SetScale(x, y)
	self.scale.x = x or self.scale.x
	self.scale.y = y or self.scale.y
	self:Update()
end

function _Rect:SetCenter(x, y)
	self.cenPos.x = x or self.cenPos.x
	self.cenPos.y = y or self.cenPos.y
	self:Update()
end

function _Rect:SetDir(dir)
	self.dir = dir or self.dir
	self:Update()
end

function _Rect:SetColor(r, g, b, a)
	self.color = {
		r = r,
		g = g,
		b = b,
		a = a
	}
end
--- type: 0 --> fill  1 --> line
function _Rect:SetDrawType(type)
	self.type = self.drawTypes[type]
end

function _Rect:GetVertex()

	local _vertex = {{x, y}, {x, y}}

	_vertex[1].x = (self.x1 < self.x2) and self.x1 or self.x2
	_vertex[1].y = (self.y1 < self.y2) and self.y1 or self.y2
	_vertex[2].x = (self.x1 < self.x2) and self.x2 or self.x1
	_vertex[2].y = (self.y1 < self.y2) and self.y2 or self.y1

	return _vertex
end

function _Rect:GetWidth()
	return self.size.w
end

function _Rect:GetHeight()
	return self.size.h
end

function _Rect:CheckPoint(x, y)
	
	self:Update()

	--print("__rect check point:", self.x1, self.x2, self.y1, self.y2)

	if x >= self.x1 and x <= self.x2  then
		if y >= self.y1 and y <= self.y2 then
			return true
		end 
	end 
	
	return false 
end

function _Rect:Destroy()
	self.pos = nil
	self.size = nil
	self.cenPos = nil
	self.color = nil
	self.dir = nil
end

return _Rect
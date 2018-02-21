--[[
	Desc: An class used to check the hitting result
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 11:37:50
	Docs:
		*Write notes here even more
]]


local _Rect = require("Src.Core.Class")()

function _Rect:Ctor(x,y,w,h) --initialize
	self.position = {x = 0.0, y = 0.0}
	self.size = {w = 0, h = 0}
	self.scale = {x = 1, y = 1}
	self.centerPos = {x = 0.0, y = 0.0}
	self.vertex = {
		[1] = {x = 0, y = 0},
		[2] = {x = 0, y = 0},
	}
	
	self.position.x = x or 0.0
	self.position.y = y or 0.0
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
	self.vertex = {
		[1] = {
			x = self.position.x - self.centerPos.x * self.scale.x * self.dir,
			y = self.position.y - self.centerPos.y * self.scale.y,
		},
		[2] = {
			x = self.position.x - self.centerPos.x * self.scale.x * self.dir + self.size.w * self.scale.x * self.dir,
			y = self.position.y - self.centerPos.y * self.scale.y + self.size.h * self.scale.y,
		},
	}
end

function _Rect:Draw()
	
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	
	self:Update()

	love.graphics.rectangle( self.type,
		self.vertex[1].x,
		self.vertex[1].y,
		self.size.w * self.scale.x * self.dir ,
		self.size.h * self.scale.y 
	)

	love.graphics.setColor(r,g,b,a)

end

function _Rect:SetPos(x,y)
	self.position.x = x
	self.position.y = y
	self:Update()
end

function _Rect:SetSize(w,h)
	self.size.w = w or 0
	self.size.h = h or 0
	self:Update()
end

function _Rect:SetScale(x, y)
	self.scale.x = x or self.scale.x
	self.scale.y = y or self.scale.y
	self:Update()
end

function _Rect:SetCenter(x,y)
	self.centerPos.x = x or self.centerPos.x
	self.centerPos.y = y or self.centerPos.y
	self:Update()
end

function _Rect:SetDir(dir)
	self.dir = dir or self.dir
	self:Update()
end

function _Rect:SetColor(r,g,b,a)
	self.color = {
		r = r,
		g = g,
		b = b,
		a = a
	}
end

function _Rect:SetDrawType(_type) -- _type: 0 --> fill  1 --> line
	self.type = self.drawTypes[_type]
end

function _Rect:GetVertex()
	return self.vertex
end

function _Rect:CheckPoint(x,y)
	
	self:Update()

	if x >= self.vertex[1].x and x <= self.vertex[2].x  then
		if y >= self.vertex[1].y and y <= self.vertex[2].y then
			return true
		end 
	end 
	return false 
end

function _Rect:Destroy(x,y)
	
	self.position = nil
	self.size = nil
	self.centerPos = nil
	self.color = nil
	self.dir = nil
	
	_Rect = nil
end

return _Rect
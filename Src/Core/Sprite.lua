--[[
	Desc: A simple sprite class
 	Author: Night_Walker
	Since: 2017-07-26 23:41:15
	Alter: 2017-07-31 22:57:40
	Docs:
		* when do Ctor() you should give it a null texture or a file path
]]


local _Sprite = require("Src.Class")()

local _Rect = require "Src.Core.Rect"

function _Sprite:Ctor(path,x,y,w,h) --initialize

	local tp = type(path)

	if (tp == "string") then
	    self.texture = love.graphics.newImage(path)
	else -- path为空纹理时
	   self.texture = path
	end


	self.rect = _Rect.New(x,y,w,h)

	self.x = x or 0
	self.y = y or 0
	self.size = {}
	self.center = {}
	self.pos = {}
	self.size.w = w or 1
	self.size.h = h or 1
	self.center.x = 0
	self.center.y = 0
	self.color = {
	r = 0,
	g = 0,
	b = 0,
	a = 255
	}

	local tmpWidth = self.texture:getWidth()
	local tmpHeight = self.texture:getHeight()

	self.rect:SetSize(tmpWidth,tmpHeight)
end


function _Sprite:Draw(x,y,r,sx,sy)

	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y

	-- local r, g, b, a = love.graphics.getColor()

	-- love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)

	love.graphics.draw(self.texture,
		self.pos.x,
		self.pos.y,
		r, 		-- rotation 旋转参数
		sx,
		sy,
		self.center.x,
		self.center.y)

	-- love.graphics.setColor(r,g,b,a)

	self.rect:SetDir(sx)
	self.rect:SetPos(self.pos.x,self.pos.y)

	-- self.rect:Draw()

end

function _Sprite:SetTexture(tex)

	if (not tex) then
	    print("Error:_Sprite:SetTexture() --> tex get nil")
	    return
	else
		self.texture = tex
	end

	self.rect:SetSize(self.texture:getWidth(), self.texture:getHeight())
end

function _Sprite:SetCenter(x,y)
	self.center.x = x or 0
	self.center.y = y or 0
	self.rect:SetCenter(x,y)
end

function _Sprite:SetColor(r,g,b,a)
	self.color = {
	r = r,
	g = g,
	b = b,
	a = a
	}
end

function _Sprite:GetRect()
	return self.rect
end

function _Sprite:GetWidth()
	return self.texture:getWidth()
end

function _Sprite:GetHeight()
	return self.texture:getHeight()
end

return _Sprite
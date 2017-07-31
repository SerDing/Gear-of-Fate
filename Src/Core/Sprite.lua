--[[
	Desc: A simple sprite class
 	Author: Night_Walker
	Since: 2017-07-26 23:41:15
	Alter: 2017-07-31 22:57:40
	Docs:
		*Write notes here even more
]]


local _Sprite = class()

local _Rect = require "Src.Rect"

function _Sprite:Ctor(path,x,y,w,h) --initialize

	self.texture = love.graphics.newImage(path)

	self.rect = _Rect.New(x,y,w,h)

	self.x = x or 0
	self.y = y or 0
	self.size.w = w or 1
	self.size.h = h or 1
	self.center.x = 0
	self.center.y = 0

	local tmpWidth = self.texture:getWidth()
	local tmpHeight = self.texture:getHeight()

	self.rect:SetSize(tmpWidth,tmpHeight)

end



function _Sprite:Draw(x,y,r,sx,sy)

	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y



	love.graphics.draw(self.texture,
		self.pos.x,
		self.pos.y,
		r, 		-- rotation 旋转参数
		sx,
		sy,
		self.center.x,
		self.center.y)

	self.rect:SetPos(x,y)


	self.rect:Draw()

end

function _Sprite:GetRect() --取回包围盒

	return self.rect

end
function _Sprite:SetCenter(x,y) --取回包围盒

	self.center.x = x or 0
	self.center.y = y or 0


end


return _Sprite
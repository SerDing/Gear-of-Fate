--[[
	Desc: An class used to check the hitting result
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 11:37:50
	Docs:
		*Write notes here even more
]]


local _Rect = require("Src.Class")()

function _Rect:Ctor(x,y,w,h) --initialize
	self.position = {x = 0, y = 0}
	self.size = {w = 0, h = 0}
	self.centerPos = {x = 0, y = 0}

	self.position.x = x or 0
	self.position.y = y or 0
	self.size.w = w or 0
	self.size.h = h or 0

	self.color = {
	r = 0,
	g = 0,
	b = 255,
	a = 255
	}

end

function _Rect:Draw()

	-- print(self.position.x,self.position.y)


	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)

	love.graphics.rectangle( "line",
		self.position.x - self.centerPos.x,
		self.position.y - self.centerPos.y,
		self.size.w,
		self.size.h )

	love.graphics.setColor(r,g,b,a)

	--[[

	旧的 可用的 实验代码

	love.graphics._Rectangle( mode, x, y, width, height )


	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0,0,255,255)

	love.graphics._Rectangle( "line",
		self.temp_position.x - self.centre_point.x,
		self.temp_position.y - self.centre_point.y,
		self.pak_info[self.playing_num].texture:getWidth(),
		self.pak_info[self.playing_num].texture:getHeight() )

	love.graphics.setColor(r,g,b,a)

	]]


end


function _Rect:SetPos(x,y)
	self.position.x = x
	self.position.y = y
end

function _Rect:SetCenter(x,y)
	self.centerPos.x = x or self.centerPos.x
	self.centerPos.y = y or self.centerPos.y
end

function _Rect:SetSize(w,h)
	self.size.w = w or 0
	self.size.h = h or 0
end

function _Rect:SetColor(r,g,b,a)
	self.color = {
	r = r,
	g = g,
	b = b,
	a = a
	}
end

return _Rect
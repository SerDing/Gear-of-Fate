-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-14 18:47:51
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-18 17:38:55


Rect = class()


function Rect:init(x,y,w,h) --initialize
	self.position = {x = 0, y = 0}
	self.size = {w = 0, h = 0}
	self.CenterPos = {x = 0, y = 0}

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

function Rect:draw()

	-- print(self.position.x,self.position.y)


	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)

	love.graphics.rectangle( "line",
		self.position.x - self.CenterPos.x,
		self.position.y - self.CenterPos.y,
		self.size.w,
		self.size.h )

	love.graphics.setColor(r,g,b,a)

	--[[

	旧的 可用的 实验代码

	love.graphics.rectangle( mode, x, y, width, height )


	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0,0,255,255)

	love.graphics.rectangle( "line",
		self.temp_position.x - self.centre_point.x,
		self.temp_position.y - self.centre_point.y,
		self.pak_info[self.playing_num].texture:getWidth(),
		self.pak_info[self.playing_num].texture:getHeight() )

	love.graphics.setColor(r,g,b,a)

	]]


end


function Rect:setPos(x,y)
	self.position.x = x
	self.position.y = y
end

function Rect:setCenter(x,y)
	self.CenterPos.x = x or self.CenterPos.x
	self.CenterPos.y = y or self.CenterPos.y
end

function Rect:setSize(w,h)
	self.size.w = w or 0
	self.size.h = h or 0
end

function Rect:setColor(r,g,b,a)
	self.color = {
	r = r,
	g = g,
	b = b,
	a = a
	}

end

return Rect
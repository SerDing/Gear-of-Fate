-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-26 23:41:15
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-27 00:20:15


local Sprite = class()


function Sprite:init(path,x,y,w,h) --initialize

	self.texture = love.graphics.newImage(path)

	self.rect = Rect.new(x,y,w,h)

	self.x = x or 0
	self.y = y or 0
	self.size.w = w or 1
	self.size.h = h or 1
	self.center.x = 0
	self.center.y = 0

	local tmp_width = self.texture:getWidth()
	local tmp_height = self.texture:getHeight()

	self.CurrentRect:setSize(tmp_width,tmp_height)

end



function Sprite:draw(x,y,r,sx,sy)

	if (x == nil and y == nil) then
		self:setPos()
	end

	love.graphics.draw(self.texture,
		self.pos.x,
		self.pos.y,
		r, 		-- rotation 旋转参数
		sx,
		sy,
		self.center.x,
		self.center.y)

	self.CurrentRect:setPos(x,y)


	self.CurrentRect:draw()

end

function Sprite:getRect() --取回包围盒

	return self.rect

end
function Sprite:setCenter(x,y) --取回包围盒

	self.center.x = x or 0
	self.center.y = y or 0


end


return Sprite
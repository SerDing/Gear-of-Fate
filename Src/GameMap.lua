-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-14 18:56:44
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-17 00:25:09


GameMap = class()


function GameMap:init() --initialize

	self.obejcts = {}

end


function GameMap:update(dt)

end


function GameMap:draw(x,y)

	for n=1,#self.obejcts do
		self.obejcts[n]:draw()
	end

end

return GameMap
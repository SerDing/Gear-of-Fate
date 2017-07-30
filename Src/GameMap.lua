-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-14 18:56:44
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-29 22:05:28


local GameMap = {}


function GameMap:Ctor() --initialize

	self.obejcts = {}

end


function GameMap:Update(dt)

end


function GameMap:Draw(x,y)

	for n=1,#self.obejcts do
		self.obejcts[n]:Draw()
	end

end

return GameMap
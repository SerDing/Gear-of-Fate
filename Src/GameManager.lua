-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-02 20:28:41
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-26 00:08:05


GameMgr = class()


function GameMgr:init() --initialize
	Game ={

		tile="",
		period = 0, --游戏阶段
		scre_offset = {x = 0 , y = 0 },
		mouse_pos = {x = 0 , y = 0 },
		run_path = "",

		Debug = false,

		keyboard_ini = {

			-- System window keys
			bag_win = "i", -- the bag window
			state_win = "m", -- hero's state window
			skill_win = "k", -- skill window

			-- Character Control keys
			up = "up",
			down = "down",
			left = "left",
			right = "right",
			attack = "x",
			jump = "c"


		},
		imageCachePool = {}, --资源缓存池
		resPool = {}, --资源加载列表
		soundCachePool = {}



	}



	--[[

	This is a test to test the SystemClass.lua(面向对象机制)

	self.id = 1
	print("self.id = " .. tostring(self.id))

	]]
end


function GameMgr:update(dt)

	-- if(Game.period == 0)then

	-- elseif(Game.period == 1)then

	-- end


end


function GameMgr:draw(x,y)

end

return GameMgr
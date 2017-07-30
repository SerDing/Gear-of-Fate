--[[
	Desc: A single object to manage core blocks of the game.
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:28:48
	Docs:
		* The class contain many game core data
]]


local _GAMEMGR = {

		title="",
		period = 0, --游戏阶段
		offset = {x = 0 , y = 0 },
		mousePos = {x = 0 , y = 0 },
		runPath = "",

		debug = false,

		keyCfg = {


			bag_win = "i",
			state_win = "m", -- hero's state window
			skill_win = "k",


			up = "up",
			down = "down",
			left = "left",
			right = "right",
			attack = "x",
			jump = "c"
		},

}


function _GAMEMGR.Ctor() --initialize

	--[[

	This is a test to test the Class.lua(面向对象机制)

	self.id = 1
	print("self.id = " .. tostring(self.id))

	]]
end


function _GAMEMGR.Update(dt)

	-- if(Game.period == 0)then

	-- elseif(Game.period == 1)then

	-- end


end


function _GAMEMGR.Draw(x,y)

end

return _GAMEMGR
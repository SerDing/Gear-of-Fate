--[[
	Desc: Monster Spawner, a monster entity factory.
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* Write notes here even more
]]

local _STRING = require("engine.string")
-- local _Monster = require "entity.monster"

local _MonsterSpawner = {}
local this = _MonsterSpawner

function _MonsterSpawner.Ctor()
	this.pathHead = "Data/monster/"
	-- this.monsterList = dofile("Data/monster/monster.lst")
end

-- function _MonsterSpawner.Spawn(monId, x, y, nav)
-- 	assert(this.monsterList[monId], 'can not find monPath in monster.lst, monID = ' .. monId)
-- 	local mon = _Monster.New(this.pathHead .. this.monsterList[monId], nav)
-- 	return mon
-- end 

return _MonsterSpawner 
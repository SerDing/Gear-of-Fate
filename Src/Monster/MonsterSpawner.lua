--[[
	Desc: Monster Spawner
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* Write notes here even more
]]

local _MonsterSpawner = {}

local _Monster = require "Src.Monster.Monster"

local _mobDataArr = {}

function _MonsterSpawner.Ctor()
	_MonsterSpawner.LoadLstData()
end 

function _MonsterSpawner.LoadLstData()
    _MonsterSpawner.pathHead = "/Data/monster/"

	_MonsterSpawner.monPathArr = {}

	_MonsterSpawner.monsterList = LoadFile("/Data/monster/monster.lst")
	
	_MonsterSpawner.monsterList = CutText(_MonsterSpawner.monsterList,"\n")
	
	_MonsterSpawner.monsterList = CutText(_MonsterSpawner.monsterList[2],"\t")

	for i=1,#_MonsterSpawner.monsterList do
		
		if i % 2 ~= 0 and _MonsterSpawner.monsterList[i + 1] then
			_MonsterSpawner.monPathArr[tonumber(_MonsterSpawner.monsterList[i])] = _MonsterSpawner.pathHead .. string.gsub(string.lower(_MonsterSpawner.monsterList[i + 1]), "`", "")
		elseif i % 2 ~= 0 and not _MonsterSpawner.monsterList[i + 1] then
			print("Error. _MonsterSpawner.LoadLstData() --> ending data error (no string data)")
		
		end
	end

end

function _MonsterSpawner.Spawn(monId, x, y, nav)
	-- print("monster:",monId,_MonsterSpawner.monPathArr[monId])
	
	local _mon
	local _monPath = _MonsterSpawner.monPathArr[monId]

	if _monPath then
		_mon = _Monster.New(_monPath, nav)
		return _mon
	else
		print("Error:_MonsterSpawner.Spawn() \ncan not find monPath in monster.lst\n_monId:" .. tostring(monId))
		return 0
	end

end 

return _MonsterSpawner 
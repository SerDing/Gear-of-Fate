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

function _MonsterSpawner.Ctor()
    _MonsterSpawner.LoadLstData()
end 

function _MonsterSpawner.LoadLstData()
    _MonsterSpawner.pathHead = "/Data/monster/"

	_MonsterSpawner.MonDataArr = {}

	_MonsterSpawner.monsterList = LoadFile("/Data/monster/monster.lst")
	
	_MonsterSpawner.monsterList = CutText(_MonsterSpawner.monsterList,"\n")
	
	_MonsterSpawner.monsterList = CutText(_MonsterSpawner.monsterList[2],"\t")

	for i=1,#_MonsterSpawner.monsterList do
		
		if i % 2 ~= 0 and _MonsterSpawner.monsterList[i + 1] then
			_MonsterSpawner.MonDataArr[tonumber(_MonsterSpawner.monsterList[i])] = _MonsterSpawner.pathHead .. string.gsub(string.lower(_MonsterSpawner.monsterList[i + 1]), "`", "")
		elseif i % 2 ~= 0 and not _MonsterSpawner.monsterList[i + 1] then
			print("Error. _MonsterSpawner.LoadLstData() --> ending data error (no string data)")
		
		end
	end

	_MonsterSpawner.Spawn(5)

end

function _MonsterSpawner.Spawn(monId)
    print("monster:",monId,_MonsterSpawner.MonDataArr[monId])
end 

return _MonsterSpawner 
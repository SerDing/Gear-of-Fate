--[[
	Desc: Black board with game common data 
	Author: Night_Walker 
	Since: 2018-04-07 00:19:57 
	Last Modified time: 2018-04-07 00:19:57 
	Docs: 
		* Write notes here even more 
]]

local _GameDataBoard = {}

local _KEY = {}

function _GameDataBoard.Load()
    _KEY = dofile("Config/Key.cfg")
end

function _GameDataBoard.GetKey(id)
    return _KEY[id]
end

return _GameDataBoard 
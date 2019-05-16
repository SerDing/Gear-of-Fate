--[[
	Desc. A new lua class 
	Author. Night_Walker 
	Since. 2018-02-04 16.45.51 
	Alter. 2018-02-04 16.45.51 
	Docs.
		* Write notes here even more 
]]

local _PassiveObjMgr = {}

local _ObjectMgr = require "Src.Scene.ObjectManager"
local _Obstacle = require "Src.Scene.Blocks.Obstacle"
local _AtkObj = require "Src.PassiveObject.AtkObj"
local _PathgateWall = require "Src.PassiveObject.PathgateWall"

function _PassiveObjMgr.Ctor()
	_PassiveObjMgr.pathHead = "/Data/passiveobject/"
	_PassiveObjMgr.objPathArr = {}
	_PassiveObjMgr.objPathArr = require("Data/passiveobject/passiveobject")
end

local function _GetObjPath(id)
	assert(_PassiveObjMgr.objPathArr[id], " No obj:" .. id .. " in passiveobj list.")
	return _PassiveObjMgr.pathHead .. string.lower(_PassiveObjMgr.objPathArr[id])
end

function _PassiveObjMgr.GeneratePassiveObj(id)
	
	local _objPath = _GetObjPath(id)
	local _objPathPieces = CutText(_objPath,"/")
	local _obj
	if _objPathPieces[#_objPathPieces - 1] == "obstacle" then
		_obj = _Obstacle.New(_objPath)
		return _obj
	elseif _objPathPieces[#_objPathPieces - 2] == "character" then
		print("__generate atk obj ", id)
		_obj = _AtkObj.New(_objPath)
		_ObjectMgr.AddObject(_obj)
		return _obj
	else
		return nil
	end

end 

function _PassiveObjMgr.AtkObj(id, x, y, dir)
	
	local _objPath = _GetObjPath(id)
	local _objPathPieces = CutText(_objPath,"/")
	local _obj
	if _objPathPieces[#_objPathPieces - 2] == "character" then
		_obj = _AtkObj.New(_objPath)
		_ObjectMgr.AddObject(_obj)
		return _obj
	else
		return nil
	end

end 

function _PassiveObjMgr.GeneratePathgate(x, y, id, destMap)
	local _path = _GetObjPath(id)
	_path = string.gsub(_path, "%.obj", "")
	local _data = require(_path)
	if #_data["[string data]"] == 3 then -- wall(left or right) (contains tile)
		return _PathgateWall.New(_path, x, y, destMap)
	-- elseif #_data["[string data]"] == 4 then -- down gate

	-- elseif #_data["[string data]"] == 5 then -- up gate

	-- elseif #_data["[string data]"] == 7 then -- side gate (left or right) (contains tile)

	else
		return nil;
	end

end

return _PassiveObjMgr
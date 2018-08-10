--[[
	Desc. A new lua class 
	Author. Night_Walker 
	Since. 2018-02-04 16.45.51 
	Alter. 2018-02-04 16.45.51 
	Docs.
		* Write notes here even more 
]]

local _PassiveObjMgr = {}

local _Obstacle = require "Src.Scene.Blocks.Obstacle"
local _AtkObj = require "Src.PassiveObject.AtkObj"
local _ObjectMgr = require "Src.Scene.ObjectManager"

function _PassiveObjMgr.Ctor()
	_PassiveObjMgr.LoadLstData()
end

function _PassiveObjMgr.LoadLstData()
	
	_PassiveObjMgr.pathHead = "/Data/passiveobject/"
	_PassiveObjMgr.objPathArr = {}
	_PassiveObjMgr.objList = LoadFile("/Data/passiveobject/passiveobject.lst")
	_PassiveObjMgr.objList = CutText(_PassiveObjMgr.objList,"\n")
	_PassiveObjMgr.objList = CutText(_PassiveObjMgr.objList[2],"\t")
	
	for i=1,#_PassiveObjMgr.objList do
		if i % 2 ~= 0 and _PassiveObjMgr.objList[i + 1] then
			local _tmpStr = string.gsub(string.lower(_PassiveObjMgr.objList[i + 1]), "`", "")
			_PassiveObjMgr.objPathArr[tonumber(_PassiveObjMgr.objList[i])] = strcat(_PassiveObjMgr.pathHead, _tmpStr)
		elseif i % 2 ~= 0 and not _PassiveObjMgr.objList[i + 1] then
			print("Error. _PassiveObjMgr.LoadLstData() --> ending data error (no string data)")
		end
	end

end 

function _PassiveObjMgr.GeneratePassiveObj(_objId)
	
	local _objPath

	if _PassiveObjMgr.objPathArr[_objId] then
		_objPath = _PassiveObjMgr.objPathArr[_objId]
	else
		error("_PassiveObjMgr.GeneratePassiveObj() \n* can not find objPath in passive object list\n* _objId:", tostring(_objId))
	end

	local _objPathPieces = CutText(_objPath,"/")
	local _obj
	if _objPathPieces[#_objPathPieces - 1] == "obstacle" then
		_obj = _Obstacle.New(_objPath)
		return _obj
	elseif _objPathPieces[#_objPathPieces - 2] == "character" then
		_obj = _AtkObj.New(_objPath)
		_ObjectMgr.AddObject(_obj)
		return _obj
	else
		return 0
	end

end 

function _PassiveObjMgr.AtkObj(_objId, x, y, dir)
	
	local _objPath

	if _PassiveObjMgr.objPathArr[_objId] then
		_objPath = _PassiveObjMgr.objPathArr[_objId]
	else
		error("_PassiveObjMgr.GeneratePassiveObj() \n* can not find objPath in passive object list\n* _objId:" .. tostring(_objId))
	end
	
	local _obj
	local _objPathPieces = CutText(_objPath,"/")
	if _objPathPieces[#_objPathPieces - 2] == "character" then
		_obj = _AtkObj.New(_objPath)
		_ObjectMgr.AddObject(_obj)
		return _obj
	else
		return 0
	end

end 

return _PassiveObjMgr
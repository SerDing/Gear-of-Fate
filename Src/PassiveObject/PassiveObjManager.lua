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

function _PassiveObjMgr.Ctor()
	
	_PassiveObjMgr.LoadLstData()
	
end

function _PassiveObjMgr.LoadLstData()
	
	_PassiveObjMgr.pathHead = "/Data/passiveobject/"

	_PassiveObjMgr.objDataArr = {}

	_PassiveObjMgr.passiveObjectList = LoadFile("/Data/passiveobject/passiveobject.lst")
	
	_PassiveObjMgr.passiveObjectList = CutText(_PassiveObjMgr.passiveObjectList,"\n")
	
	_PassiveObjMgr.passiveObjectList = CutText(_PassiveObjMgr.passiveObjectList[2],"\t")
	
	-- print(#_PassiveObjMgr.passiveObjectList)

	for i=1,#_PassiveObjMgr.passiveObjectList do
		
		if i % 2 ~= 0 and _PassiveObjMgr.passiveObjectList[i + 1] then
			_PassiveObjMgr.objDataArr[tonumber(_PassiveObjMgr.passiveObjectList[i])] = _PassiveObjMgr.pathHead .. string.gsub(string.lower(_PassiveObjMgr.passiveObjectList[i + 1]), "`", "")
		elseif i % 2 ~= 0 and not _PassiveObjMgr.passiveObjectList[i + 1] then
			print("Error. _PassiveObjMgr.LoadLstData() --> ending data error (no string data)")
		
		end
	end

end 

function _PassiveObjMgr.GeneratePassiveObj(_objId)
	
	local _tmpPassiveObj
	local _objPath

	if _PassiveObjMgr.objDataArr[_objId] then
		_objPath = _PassiveObjMgr.objDataArr[_objId]
	else
		print("Error:_PassiveObjMgr.GeneratePassiveObj() \ncan not find objPath in passive object list\n_objId:" .. tostring(_objId))
		return 0 
	end

	local _objPathPieces = CutText(_objPath,"/")

	if _objPathPieces[#_objPathPieces - 1] == "obstacle" then
		_tmpPassiveObj = _Obstacle.New(_objPath)
		return _tmpPassiveObj
	else
		return 0
	end

end 

return _PassiveObjMgr
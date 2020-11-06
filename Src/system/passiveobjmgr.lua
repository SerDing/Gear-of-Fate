--[[
	Desc. passive object manager
	Author. SerDing
	Since. 2018-02-04 16.45.51 
	Alter. 2018-02-04 16.45.51 
	Docs.
		* Write notes here even more 
]]
local _STRING = require("engine.string")
local _ObjectMgr = require "scene.ObjectManager"
local _Obstacle = require "scene.objects.obstacle"
local _Bullet = require "entity.bullet"
local _PathgateWall = require "scene.objects.pathgatewall"

local _PassiveObjMgr = {}
local this = _PassiveObjMgr

function _PassiveObjMgr.Ctor()
	this.pathHead = "resource/data/passiveobject/"
	this.objPathArr = {}
	this.objPathArr = require("resource/data/passiveobject/passiveobject")
end

local function _GetObjPath(id)
	assert(this.objPathArr[id], " No obj:" .. id .. " in passiveobj list.")
	return this.pathHead .. string.lower(this.objPathArr[id])
end

function _PassiveObjMgr.GeneratePassiveObj(id)
	
	local _objPath = _GetObjPath(id)
	local _objPathPieces = _STRING.split(_objPath, "/")
	local _obj
	if _objPathPieces[#_objPathPieces - 1] == "obstacle" then
		_obj = _Obstacle.New(_objPath)
		return _obj
	elseif _objPathPieces[#_objPathPieces - 2] == "character" then
		print("__generate atk obj ", id)
		_obj = _Bullet.New(_objPath)
		_ObjectMgr.AddObject(_obj)
		return _obj
	else
		return nil
	end

end 

function _PassiveObjMgr.AtkObj(id, x, y, dir)
	
	local _objPath = _GetObjPath(id)
	local _objPathPieces = _STRING.split(_objPath, "/")
	local _obj
	if _objPathPieces[#_objPathPieces - 2] == "character" then
		_obj = _Bullet.New(_objPath)
		_ObjectMgr.AddObject(_obj)
		return _obj
	else
		return nil
	end

end 

function _PassiveObjMgr.GeneratePathgate(x, y, id, destMap)
	local objPath = _GetObjPath(id)
	local objData = dofile(objPath)
	if #objData["[string data]"] == 3 then -- wall(left or right) (contains tile)
		return _PathgateWall.New(objPath, x, y, destMap)
	-- elseif #_data["[string data]"] == 4 then -- down gate

	-- elseif #_data["[string data]"] == 5 then -- up gate

	-- elseif #_data["[string data]"] == 7 then -- side gate (left or right) (contains tile)

	else
		return nil;
	end

end

return _PassiveObjMgr
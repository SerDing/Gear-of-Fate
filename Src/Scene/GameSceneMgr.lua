--[[
    Desc: Manage scenes in the game
    Author: Night_Walker
    Since: Thu Sep 07 2017 23:10:06 GMT+0800 (CST)
    Alter: Thu Sep 07 2017 23:10:06 GMT+0800 (CST)
    Docs: 
        * load [*.twn] or [*.dgn] then create right scene
]]

local _SCENEMGR = {}

local _Scene = require "Src.Scene.GameScene"

local _sendPos = require "Src.Scene.SendPosition" -- some position data

local _NAME_LIST = {
	town = require "Src.Script.town.town" ,
	dungeon = {},
}
local _Area = {town = {}}
local _SceneList = {}

local _Index = {  -- Index = {area,map}
	
	["elvengard"] = {1,0},
	["d_elvengard"] = {1,2},
	["gate"] = {1,1},

}


function _SCENEMGR.Ctor()
    
	_SCENEMGR.path = "Src/Script/map/"
	_SCENEMGR.preScene = {}
	_SCENEMGR.curScene = {}

	_SCENEMGR.curIndex = _Index["elvengard"]

	for k,v in pairs(_NAME_LIST.town) do
		_Area.town[k] = require ("Src.Script.town." .. v)
	end 
	
	
	

end 

function _SCENEMGR.Update(dt)
    if _SCENEMGR.curScene then
		_SCENEMGR.curScene:Update()
	else 
		print("Err:SceneMgr.Update() --> curScene is not existing !")
	end 
end 

function _SCENEMGR.Draw()
    if _SCENEMGR.curScene then
		_SCENEMGR.curScene:Draw()
	else 
		print("Err:SceneMgr.Draw() --> curScene is not existing !")
	end 
end

function _SCENEMGR.LoadScene(area,map,mode)
	
	
end

function _SCENEMGR.CreatScene(area,map,type)
	
	--[[	preDefine	]]
	if not _SceneList[type][area] then
		_SceneList[type][area] = {}
	end 
	
	local _path = string.gsub(_SCENEMGR.path .. _Area[type][area]["area"][map][1], ".map", ".lua")

	if not _SceneList[type][area][map] then
		
		--[[	check whether the map file exits 	]]
		fp = io.open( _path )
		if not fp then
			print("Err:_SCENEMGR.CreatScene() -- the map " .. _path .. " is not existing!")
			fp:close()
			return false
		end 
		fp:close()
		
		_SceneList[type][area][map] = _Scene.New(_path)
	end 
	
	
end


return _SCENEMGR 
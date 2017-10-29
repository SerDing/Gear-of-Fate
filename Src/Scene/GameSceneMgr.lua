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
local _Area = {town = {},dungeon = {}}
local _sceneList = {town = {},dungeon = {}}

local _Index = {  -- Index = {area,map}
	
	["elvengard"] = {1,0},
	["d_elvengard"] = {1,2},
	["gate"] = {1,1},

}

local _res = {}

local _GAMEINI = require "Src.Config.GameConfig" 

local hero_ = {} -- init a null pointer that will point to hero

local _Hero_SwordMan = require "Src.Heroes.Hero_SwordMan"

local _hero = _Hero_SwordMan.New(400,460)



function _SCENEMGR.Ctor()

	_SCENEMGR.path = "Src/Script/map/"
	_SCENEMGR.preScene = {}
	_SCENEMGR.curScene = {}

	_SCENEMGR.offset = {x = 0, y = 0}

	_SCENEMGR.curIndex = _Index["elvengard"]

	for k,v in pairs(_NAME_LIST.town) do
		_Area.town[k] = require ("Src.Script.town." .. v)
	end 

------[[	test elvengard map	]]

	_SCENEMGR.CreatScene(_Index["elvengard"][1],_Index["elvengard"][2],"town")
	
	_SCENEMGR.LoadScene(_Index["elvengard"][1],_Index["elvengard"][2],"town")

	_SCENEMGR.SetHeroPtr(_hero)
end 

function _SCENEMGR.Update(dt)
	
	_SCENEMGR.RefreshSystemOffset(_SCENEMGR.curScene:GetWidth(),_SCENEMGR.curScene:GetHeight())
	_hero:Update(dt)

	if _SCENEMGR.curScene then
		_SCENEMGR.curScene:Update(dt,_SCENEMGR.offset)
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
	_hero:Draw(_SCENEMGR.offset)
end

function _SCENEMGR.LoadScene(area,map,type)
	
	if _sceneList[type][area][map] then
		_SCENEMGR.curScene = _sceneList[type][area][map]
		_SCENEMGR.curIndex = {area,map}
		return true 
	else 
		print(
			"Err:_SCENEMGR:LoadScene() not created -- area:" .. 
			tostring(area) .. 
			" map:" .. 	
			tostring(map)
		)
		return false 
	end 
	
	
end

function _SCENEMGR.CreatScene(area,map,type)
	
	--[[	preDefine	]]
	
	if not _sceneList[type][area] then
		_sceneList[type][area] = {}
	end 
	if not _res[area] then
		_res[area] = {}
	end 
	if not _res[area][map] then
		_res[area][map] = {}
	end 
	--[[	transform file form [*.map] to  [*.lua] 	]]
	
	local _path = string.sub(
		_SCENEMGR.path .. 
		_Area[type][area]["[area]"][map][1], 
		1, 
		- 4 - 1
	)

	if not _sceneList[type][area][map] then
		
		--[[	check whether the map file exits 	]]
		if _SCENEMGR.IsMapFileExisting(_path .. ".lua") == false then
			print(
				"Err:_SCENEMGR.CreatScene() -- the map: " .. 
				_path .. 
				" is not existing!"
				)
			return false 
		end
		
		_sceneList[type][area][map] = _Scene.New(_path,_res[area][map]) 
	end 
	
	
end

function _SCENEMGR.IsMapFileExisting(path)
	local fp = io.open(path)
	local _result 
	if not fp then
		_result = false
	else 
		_result = true 
	end 
	fp:close()
	return _result 
end

function _SCENEMGR.RefreshSystemOffset(w,h)
	
	if hero_.pos.x + _SCENEMGR.offset.x < 350 then
		_SCENEMGR.offset.x,_SCENEMGR.offset.y = _SCENEMGR.GetScreenPos(hero_.pos.x+50,hero_.pos.y,w,h)
	elseif hero_.pos.x + _SCENEMGR.offset.x > 450 then
		_SCENEMGR.offset.x,_SCENEMGR.offset.y = _SCENEMGR.GetScreenPos(hero_.pos.x-50,hero_.pos.y,w,h)
	else
		_SCENEMGR.offset.x,_SCENEMGR.offset.y = _SCENEMGR.GetScreenPos(hero_.pos.x,hero_.pos.y,w,h)	--这种时候 x 轴 没必要更新，center 到这边已经没用了 就用来占位吧
	end
end

function _SCENEMGR.GetScreenPos(x,y,w,h)
	local w2,h2 = _GAMEINI.winSize.width/2,_GAMEINI.winSize.height/2--half of width or height
	local rx,ry = 0,0

	if w >_GAMEINI.winSize.width then
		if (x>w2 and x<w-w2) then
			rx = -(x-w2)
		elseif x<=w2 then
			rx=0
		elseif x>=w-w2 then
			rx=-(w-_GAMEINI.winSize.width)
		end
	end
	if h > _GAMEINI.winSize.height then
		if (y>h2 and y<h-h2) then
			ry = -(y-h2)
		elseif y<=h2 then
			ry=0
		elseif y>=h-h2 then
			ry=-(h-_GAMEINI.winSize.height)
		end
	end

	return rx,ry
end

function _SCENEMGR.SetHeroPtr(ptr)
	assert(ptr,"Warning!!! hero_ pointer is null!!!")
	hero_ = ptr
end

return _SCENEMGR 


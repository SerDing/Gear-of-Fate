--[[
    Desc: Manage scenes in the game
    Author: Night_Walker
    Since: Thu Sep 07 2017 23:10:06 GMT+0800 (CST)
    Alter: Thu Sep 07 2017 23:10:06 GMT+0800 (CST)
    Docs: 
		* load [*.twn] or [*.dgn] then create right scene
		
]]

local _SCENEMGR = {}

local _Sprite = require "Src.Core.Sprite"
local _ObjectMgr = require "Src.Scene.ObjectManager"
local _EffectMgr = require "Src.Scene.EffectManager"
local _Scene = require "Src.Scene.GameScene"
local _sendPos = require "Src.Scene.SendPosition" -- some position data

local _NAME_LIST = {
	town = require "./Data/town/town" ,
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

_EffectMgr.Ctor()
_ObjectMgr.Ctor()

local _Hero_SwordMan = require "Src.Heroes.Hero_SwordMan"

local _hero = _Hero_SwordMan.New(1400,460)

_ObjectMgr.AddObject(_hero)

local _cover = {
	imageData = love.image.newImageData(800, 600),
	sprite = {},
	alpha = 0,
	speed = 3,
}

_cover.sprite = _Sprite.New(love.graphics.newImage("/Dat/backgroundpic.png"))
_cover.sprite:SetColor(0,0,0,255)

local _passiveObjectList = LoadFile("/Data/passiveobject/passiveobject.lst")

_passiveObjectList = CutText(_passiveObjectList,"\n")

-- _passiveObjectList = CutText(_passiveObjectList[2],"\t")

-- print(_passiveObjectList[1],_passiveObjectList[2])

function _SCENEMGR.Ctor()

	_SCENEMGR.path = "./Data/map/"
	_SCENEMGR.preScene = {}
	_SCENEMGR.curScene = {}

	_SCENEMGR.offset = {x = 0, y = 0}

	_SCENEMGR.curIndex = _Index["elvengard"]

	for k,v in pairs(_NAME_LIST.town) do
		_Area.town[k] = require ("./Data/town." .. v)
	end 

	_SCENEMGR.curType = "town"

  ----[[	test elvengard map	]]

	-- _SCENEMGR.CreatScene(_Index["elvengard"][1],_Index["elvengard"][2],"town")
	
	_SCENEMGR.LoadScene(_Index["elvengard"][1],_Index["elvengard"][2],_SCENEMGR.curType)

	
end 

function _SCENEMGR.Update(dt)
	
	_SCENEMGR.RefreshSystemOffset(_SCENEMGR.curScene:GetWidth(),_SCENEMGR.curScene:GetHeight())
	
	if _SCENEMGR.curScene then
		_SCENEMGR.curScene:Update(dt,_SCENEMGR.offset)
	else 
		print("Err:SceneMgr.Update() --> curScene is not existing !")
	end 
	
end 

function _SCENEMGR.Draw()
    if _SCENEMGR.curScene then
		if _cover.alpha <= 240 then --防止切换场景后 场景先于黑色封面显示
			_SCENEMGR.curScene:Draw()
		end 
	else 
		print("Err:SceneMgr.Draw() --> curScene is not existing !")
	end 
	
	if _cover.alpha > 0 then
		_cover.sprite:Draw(0,0)
		_cover.sprite:SetColor(0,0,0,_cover.alpha)
		_cover.alpha = _cover.alpha - _cover.speed
	end 
	
end

function _SCENEMGR.LoadScene(area,map,type)
  ----[[  preDefine  ]]
	
	if not _sceneList[type][area] then
		_sceneList[type][area] = {}
	end

	if not _res[area] then
		_res[area] = {}
	end 

	if not _res[area][map] then
		_res[area][map] = {}
	end 
  ----[[    ]]
	if not _sceneList[type][area][map] then
		_SCENEMGR.CreatScene(area,map,type)
	end 

	if _sceneList[type][area][map] then
		_SCENEMGR.curScene = _sceneList[type][area][map]
		_SCENEMGR.curIndex = {area,map}
		_SCENEMGR.curScene:Awake()
		_hero:SetScenePtr(_SCENEMGR.curScene)
		return true 
	end 
	
end

function _SCENEMGR.UnLoadScene()
	_ObjectMgr.RemoveObject("OBJECT")
	_ObjectMgr.RemoveObject("NPC")
end

function _SCENEMGR.CreatScene(area,map,type)
	
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
		
		_sceneList[type][area][map] = _Scene.New(_path,_res[area][map],_SCENEMGR) 
	end 
	
	
end

function _SCENEMGR.IsMapFileExisting(path)
	local fp = io.open(path)
 
	if not fp then
		return false
	else 
		fp:close()
		return true
	end 
	
end

function _SCENEMGR.RefreshSystemOffset(w,h)
	if _hero.pos.x + _SCENEMGR.offset.x < _GAMEINI.winSize.width / 2 - 50 then
		_SCENEMGR.offset.x,_SCENEMGR.offset.y = _SCENEMGR.GetScreenPos(_hero.pos.x+50,_hero.pos.y,w,h)
	elseif _hero.pos.x + _SCENEMGR.offset.x > _GAMEINI.winSize.width / 2 + 50 then
		_SCENEMGR.offset.x,_SCENEMGR.offset.y = _SCENEMGR.GetScreenPos(_hero.pos.x-50,_hero.pos.y,w,h)
	else
		_SCENEMGR.offset.x,_SCENEMGR.offset.y = _SCENEMGR.GetScreenPos(_hero.pos.x,_hero.pos.y,w,h)	
	end
end

function _SCENEMGR.GetScreenPos(x,y,w,h)
	local w2,h2 = _GAMEINI.winSize.width / 2, _GAMEINI.winSize.height / 2--half of width or height
	local rx,ry = 0,0

	if w >_GAMEINI.winSize.width then
		if (x > w2 and x < w - w2) then
			rx = - (x - w2)
		elseif x <= w2 then
			rx = 0
		elseif x >= w - w2 then
			rx = - (w - _GAMEINI.winSize.width)
		end
	end
	
	if h > _GAMEINI.winSize.height then
		if (y > h2 and y < h - h2) then
			ry = - (y - h2)
		elseif y <= h2 then
			ry = 0
		elseif y >= h - h2 then
			ry = - (h - _GAMEINI.winSize.height)
		end
	end

	return rx,ry
end

function _SCENEMGR.SwitchScene(area,map,posIndex)
	
	local _arr = _Area.town[area]
	
	if _arr then
		local _pos = _sendPos[_SCENEMGR.curIndex[1] ][_SCENEMGR.curIndex[2]][posIndex]
		if _pos then
			_SCENEMGR.PutCover()
			_SCENEMGR.UnLoadScene()
			_SCENEMGR.LoadScene(area,map,_SCENEMGR.curType)
			_hero:SetPosition(_pos.x,_pos.y)
			-- Refresh screen offset rigth now to avoid position fixing delay when load objects of new scene. 
			_SCENEMGR.RefreshSystemOffset(_SCENEMGR.curScene:GetWidth(),_SCENEMGR.curScene:GetHeight())
		end 
	else
		print("Err: _SCENEMGR:SwitchScene() the objected AreaData is not Existing!")
		print(area,map)
		return false
	end
	
end

function _SCENEMGR.PutCover()
	_cover.alpha = 255
end 

function _SCENEMGR.SetCameraOffset(x,y)
	_SCENEMGR.curScene:SetCameraOffset(x,y)
end 

function _SCENEMGR.GetHero_()
	return _hero 
end 

return _SCENEMGR 


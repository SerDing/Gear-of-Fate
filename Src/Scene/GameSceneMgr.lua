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
local _sendPos = require "Src.Scene.SendPosition" -- new position in next scene
local _Hero_SwordMan = require "Src.Heroes.Hero_SwordMan"
-- local _CAMERA = require "Src.Game.GameCamera"
local _RESMGR = require("Src.Resource.ResManager")

-- const
local _res = {}
local _Area = {town = {},dungeon = {}}
local _sceneList = {town = {},dungeon = {}}
local _Index = {-- Index = {area,map}
	["elvengard"] = {1,0},
	["d_elvengard"] = {1,2},
	["gate"] = {1,1},
	["lorien"] = {-1, 0},
}

-- extern data loading
local _GAMEINI = require "Src.Config.GameConfig" 
local _NAME_LIST = {
	town = require "Data/town/town" ,
	dungeon = {},
}

-- init
_EffectMgr.Ctor()
_ObjectMgr.Ctor()
-- _CAMERA.Ctor(_SCENEMGR)

-- create hero
local _hero = _Hero_SwordMan.New(400,460)
_ObjectMgr.AddObject(_hero)

-- black cover when switch scene
local _cover = {
	imageData = love.image.newImageData(love.graphics.getWidth(), love.graphics.getHeight()), 
	sprite = {}, alpha = 240, speed = 3
}
-- _RESMGR.InstantiateImageData(_cover.imageData)
_cover.sprite = _Sprite.New(love.graphics.newImage(_cover.imageData)) -- love.graphics.newImage() "/Dat/backgroundpic.png"
_cover.sprite:SetColorEx(0,0,0,255)
_cover.sprite:SetColor(0,0,0,255)

function _SCENEMGR.Ctor()

	_SCENEMGR.path = "Data/map/"
	_SCENEMGR.preScene = {}
	_SCENEMGR.curScene = {}
	_SCENEMGR.offset = {x = 0, y = 0}
	_SCENEMGR.curIndex = _Index["elvengard"]
	_SCENEMGR.curType = "town"

	for k,v in pairs(_NAME_LIST.town) do
		_Area.town[k] = require ("Data/town." .. v)
	end 

    ----[[	test elvengard map	]]
	-- _SCENEMGR.CreatScene(_Index["elvengard"][1], _Index["elvengard"][2], "town")
	
	_SCENEMGR.LoadScene(_Index["lorien"][1], _Index["lorien"][2], _SCENEMGR.curType)
	-- _SCENEMGR.LoadScene(_Index["elvengard"][1], _Index["elvengard"][2], _SCENEMGR.curType)
	
	
end 

function _SCENEMGR.Update(dt)
	
	if _SCENEMGR.curScene.Update then
		_SCENEMGR.curScene:Update(dt)
	else 
		error("Err:SceneMgr.Update() --> curScene is not existing !")
	end

	-- _hero:Update(dt)

	-- _CAMERA.Update(dt)
	-- _CAMERA.LookAt(_hero.pos.x, _hero.pos.y)

end 

function _SCENEMGR.Draw(x, y)
	
	-- local drawFunc = function (x,y)
		if _SCENEMGR.curScene then
			if _cover.alpha <= 240 then --防止切换场景后 场景先于黑色封面显示
				if _SCENEMGR.curScene.Draw then
					_SCENEMGR.curScene:Draw(x, y)
				end
				
			end
		else
			print("Err:SceneMgr.Draw() --> curScene is not existing!")
		end

		-- _hero:Draw()
		
		if _cover.alpha > 0 then
			_cover.sprite:Draw(- x, - y)
			_cover.sprite:SetColor(0,0,0,_cover.alpha)
			_cover.alpha = _cover.alpha - _cover.speed
		end 
	-- end

	-- _CAMERA.Draw(drawFunc)

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
	
	local _path = string.sub(_SCENEMGR.path .. _Area[type][area]["[area]"][map][1], 1, - 4 - 1)
	
	if not _sceneList[type][area][map] then
		
		--[[	check whether the map file exits 	]]
		if _SCENEMGR.IsMapFileExisting(_path .. ".lua") == false then
			print("Err:_SCENEMGR.CreatScene() -- the map: " .. _path .. " is not existing!")
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

function _SCENEMGR.SwitchScene(area,map,posIndex)
	
	local _arr = _Area.town[area]
	
	if _arr then
		local _pos = _sendPos[_SCENEMGR.curIndex[1] ][_SCENEMGR.curIndex[2]][posIndex]
		if _pos then
			_SCENEMGR.PutCover()
			_SCENEMGR.UnLoadScene()
			_SCENEMGR.LoadScene(area,map,_SCENEMGR.curType)
			_hero:SetPosition(_pos.x,_pos.y)
		end 
	else
		error("_SCENEMGR:SwitchScene() the objected AreaData is not Existing!","\n* area:",area,"* map:",map)
		return false
	end
	
end

function _SCENEMGR.PutCover()
	_cover.alpha = 255
end 

function _SCENEMGR.GetHero_()
	return _hero 
end 

function _SCENEMGR.GetCurScene()
	return _SCENEMGR.curScene
end

return _SCENEMGR 


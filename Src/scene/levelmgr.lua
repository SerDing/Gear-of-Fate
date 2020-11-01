--[[
	Desc: Manage levels in the game
	Author: SerDing
	Since: 2017-09-07 
	Alter: 2019-12-12
]]

local _Event = require "core.event"
local _Level = require "scene.level"
local _CAMERA = require "scene.camera"
local _FILE = require('engine.filesystem')
local _RESMGR = require("system.resource.resmgr")
local _RESOURCE = require("engine.resource")

local _FACTORY = require "system.entityfactory"
local _sendPos = {}

local _Index = {-- Index = {area,map}
	["elvengard"] = {1,0},
	["d_elvengard"] = {1,2},
	["gate"] = {1,1},
	["lorien"] = {-1, 0},
}

-- _CAMERA.Ctor(_SCENEMGR)

---@class LevelManager
---@field curLevel Level
local _LEVELMGR = {}
local this = _LEVELMGR

function _LEVELMGR.Ctor()
	
	this.path = "Data/map/"
	this.curLevel = nil
	this.offset = {x = 0, y = 0}
	this.curIndex = _Index["elvengard"]
	this.curType = "town"
	this._levelPool = {town = {}, dungeon = {}}
	this._area = {town = {}, dungeon = {}}
	this._NAME_LIST = {
		town = _RESOURCE.ReadData("Data/town/town"),
		dungeon = {},
	}

	for k,v in pairs(this._NAME_LIST.town) do
		this._area.town[k] = _RESOURCE.ReadData("Data/town/" .. v)
	end 

	this._curtain = { alpha = 240, speed = 3 }

	this.eventMap = {}
	this.eventMap.OnSwitchingScene = _Event.New()

	-- this.LoadScene(_Index["elvengard"][1], _Index["elvengard"][2], this.curType)
	this.LoadLevel(_Index["lorien"][1], _Index["lorien"][2], this.curType)
	
end 

function _LEVELMGR.Update(dt)
	
	if this.curLevel.Update then
		this.curLevel:Update(dt)
	else 
		error("curScene is not existing !")
	end

	-- _CAMERA.Update(dt)
	-- _CAMERA.LookAt(_FACTORY.mainPlayer.transform.position.x, _FACTORY.mainPlayer.transform.position.y)

end 

local drawFunc = function (x,y)
	if this.curLevel then
		if this._curtain.alpha <= 240 then --防止切换场景后 场景先于黑色封面显示
			if this.curLevel.Draw then
				this.curLevel:Draw(x, y)
			end
		end
	end
	if this._curtain.alpha > 0 then
		love.graphics.setColor(0, 0, 0, this._curtain.alpha)
		love.graphics.rectangle("fill", -x, -y, love.graphics.getDimensions())
		love.graphics.setColor(255, 255, 255, 255)
		this._curtain.alpha = this._curtain.alpha - this._curtain.speed
	end 
end

function _LEVELMGR.Draw(x, y)
	-- _CAMERA.Draw(drawFunc)
	drawFunc(x, y)
end

function _LEVELMGR.LoadLevel(area, map, type)

	if not this._levelPool[type][area] then
		this._levelPool[type][area] = {}
	end

	----[[    ]]
	if not this._levelPool[type][area][map] then
		_LEVELMGR.CreatScene(area,map,type)
	end 

	if this._levelPool[type][area][map] then
		_LEVELMGR.curLevel = this._levelPool[type][area][map]
		_LEVELMGR.curIndex = {area,map}
		_LEVELMGR.curLevel:Awake()
	end 
	
	this.OnLoadScene()
end

function _LEVELMGR.OnLoadScene()
	this.eventMap.OnSwitchingScene:Notify(this.curLevel)
end

function _LEVELMGR.UnLoadScene()
end

function _LEVELMGR.CreatScene(area, map, type)
	-- delete the suffix ".map" 
	local mapPath = string.sub(_LEVELMGR.path .. this._area[type][area]["[area]"][map][1], 1, - 4 - 1) .. ".dat"
	if not this._levelPool[type][area][map] then
		--[[	check whether the map file exits 	]]
		if _LEVELMGR.IsMapFileExisting(mapPath) == false then
			error("No map file: " .. mapPath)
			return false
		end
		this._levelPool[type][area][map] = _Level.New(mapPath, _LEVELMGR) 
	end
end

function _LEVELMGR.SwitchScene(area, map, posIndex)
	
	local _arr = this._area.town[area]
	
	if _arr then
		local _pos = _sendPos[this.curIndex[1] ][this.curIndex[2]][posIndex]
		if _pos then
			this.PutCover()
			this.UnLoadScene()
			this.LoadLevel(area, map, this.curType)
			-- this._playerEntity.transform.position:Set(_pos.x, _pos.y, 0)
		end 
		
	else
		error("the area data is not existing! \n* area:" .. area .. " * map:" .. map)
		return false
	end
	
end

---@param event string 
---@param obj table 
---@param func function 
function _LEVELMGR.RegEventListener(event, obj, func)
	this.eventMap[event]:AddListener(obj, func)
end

---@param event string 
---@param obj table 
---@param func function 
function _LEVELMGR.DelEventListener(event, obj, func)
	this.eventMap[event]:DelListener(obj, func)
end

function _LEVELMGR.IsMapFileExisting(path)
	return _FILE.Exist(path)
	-- local fp = io.open(path)
	-- if not fp then
	-- 	return false
	-- else 
	-- 	fp:close()
	-- 	return true
	-- end 
end

function _LEVELMGR.PutCover()
	this._curtain.alpha = 255
end 

function _LEVELMGR.GetCurScene()
	return _LEVELMGR.curLevel
end

return _LEVELMGR 
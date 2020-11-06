--[[
	Desc: Resource manager, load custom type resource with pool.
 	Author: SerDing
	Since: 2017-07-28
	Alter: 2020-01-19
]]
local _STRING = require("engine.string")
local _FILE = require('engine.filesystem')
local _RESOURCE = require('engine.resource')


---@class _RESMGR
local _RESMGR = {
	imgPathHead = "resource/image/", -- ImagePacks/
	-- dataPathHead = "resource/data/"
}
local this = _RESMGR

local _pools = {
	entity = {},
	anim = {},
	state = {},
	skill = {},
	effect = {},
	equipment = {},
	buff = {},
	item = {},
}

local _meta = {__mode = 'v'}
for _, p in pairs(_pools) do
	setmetatable(p, _meta)
end

local function _HeaderHandle(path)
	if type(path) ~= "string" then
		return path
	end

	if string.sub(path, 1, 7) ~= "entity/" then
		path = path + "entity/"
	end

	return path
end

function _RESMGR.LoadDataFile(path)
	-- local f = dofile(path)

	local fileContent = _FILE.LoadFile(path)
	local f = loadstring(fileContent)()
	f.A = _STRING.GetFileDirectory(path)
	return f
end

---@param path string | table
---@return System.RESMGR.EntityData
local function _NewEntityData(path)
	---@class System.RESMGR.EntityData 
	local data = _RESOURCE.ReadData("resource/data/entity/instance/" .. path)

	for key, value in pairs(data) do
        value.class = require("component." .. key)
        if value.class.HandleData then
            value.class.HandleData(value)
        end
    end

	return data
end

---@param path string
---@return System.RESMGR.StateData
local function _NewStateData(path)
	---@class System.RESMGR.StateData
	local data = _RESOURCE.ReadData("resource/data/entity/states/" .. path)

	data.class = require("entity.states." .. data.script)
	data.script = nil

	if data.class.HandleData then
		data.class.HandleData(data)
	end

	return data
end

---@param path string @specific anim data path (animPath + "|" + imgPath)
---@param imgPath string @avatar part image path
---@return Engine.Resource.AniData 
local function _NewAvatarAnimData(path, imgPath)
	local pos = string.find(path, "|")
	path = string.sub(path, 1, pos - 1)
	return _RESOURCE.NewAniData(path, _RESOURCE.NewSpriteData, imgPath) 
end

---@param path string
local function _NewEquipmentData(path)
	return _RESOURCE.ReadData("resource/data/entity/equipment/" .. path)
end

---@param path string
---@return System.RESMGR.EntityData
function _RESMGR.LoadEntityData(path)
	return _RESOURCE.LoadResource(path, _NewEntityData, _pools.entity)
end

---@param path string
---@return Engine.Engine.Resource.StateData
function _RESMGR.LoadStateData(path)
	return _RESOURCE.LoadResource(path, _NewStateData, _pools.state)
end

---@param path string @anim data path
---@param imgPath string @avatar part image path
---@return Engine.Resource.AniData 
function _RESMGR.LoadAvatarAnimData(path, imgPath)
    return _RESOURCE.LoadResource(path .. "|" .. imgPath, _NewAvatarAnimData, _pools.anim, imgPath)
end

---@param path string
---@return EquData
function _RESMGR.LoadEquipmentData(path)
	return _RESOURCE.LoadResource(path, _NewEquipmentData, _pools.equipment)
end

return _RESMGR
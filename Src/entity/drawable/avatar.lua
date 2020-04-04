--[[
	Desc: Avatar, a set of frame animations.
	Author: SerDing 
	Since: 2018-09-22
	Alter: 2020-03-11
]]
local _Frameani = require "entity.drawable.frameani"
local _Layer = require("engine.graphics.drawable.layer")
local _RESMGR = require("system.resource.resmgr")
local _RESOURCE = require("engine.resource")

---@class Entity.Drawable.Avatar : Engine.Graphics.Drawable.Layer
---@field protected _indexMap table<string, Engine.Graphics.Drawable.Frameani>
---@field protected _animDatas table<string, table<string, Engine.Resource.AnimData>>
---@field protected _path string @ basic path for animData and images
---@field protected _subpath table<string, string>
---@field protected _order table<string, number>
---@field protected _dynamic boolean
local _Avatar = require("core.class")(_Layer)

function _Avatar.HandleData(data)
    if data.animPathSet then
        data.animDatas = {}
        for key, path in pairs(data.animPathSet) do
            data.animDatas[key] = _RESOURCE.LoadAnimData(data.path .. path)
        end
    end
end

---@param data table
function _Avatar:Ctor(data)
    _Layer.Ctor(self)
    self._indexMap = {}
    self._animDatas = {}
    
    self._path = data.path or ""
    self._subpath = data.subpath
    self._order = data.order
    self._dynamic = (data.animPathSet) and false or true
    
    local keylist = (self._dynamic == true) and self._subpath or data.animPathSet
    for key,_ in pairs(keylist) do
        self:AddPart(key)
    end
    if not self._dynamic then
        self._animDatas = data.animDatas
        self:Play()
    end
end 

function _Avatar:Update(dt, rate)
    for _,part in pairs(self._indexMap) do
        part:Update(dt, rate)
    end 
end 

---@param path string
function _Avatar:Play(path)
    if not self._dynamic then
        for key, part in pairs(self._indexMap) do
            part:Play(self._animDatas[key])
        end

        return
    end

    for key, part in pairs(self._indexMap) do
        part:Play(self._animDatas[key][path])
    end
end 

---@param animPathSet table<number, string>
function _Avatar:InitAnimDatas(animPathSet)
    local animPath = ""
    local basicPath = self._path .. "/"
    for key, subpath in pairs(self._subpath) do
        for i=1,#animPathSet do
            animPath = basicPath .. animPathSet[i]
            self._animDatas[key][animPathSet[i]] = _RESMGR.LoadAvatarAnimData(animPath, basicPath .. subpath)
        end
    end
end

---@param data table<string, string> @ new subpath data table
function _Avatar:Refresh(data)
    for key, subpath in pairs(data) do
        if not self._indexMap[key] then
            self:AddPart(key)
        end
        self._subpath[key] = subpath
    end
end

---@param key string
function _Avatar:AddPart(key)
    self._indexMap[key] = _Frameani.New()
    self._indexMap[key].order = self._order[key]
    self._animDatas[key] = {}
    self:Add(self._indexMap[key])
    
    ---@param partA string
    ---@param partB string
    local function _Sort(partA, partB)
        return partA.order < partB.order
    end
    _Layer.Sort(self, _Sort)
end

---@return Engine.Graphics.Drawable.Frameani
function _Avatar:GetPart(key)
    key = key or "skin"
    return self._indexMap[key]
end

function _Avatar:NextFrame()
    for _,part in pairs(self._indexMap) do
        part:NextFrame()
    end
end 

function _Avatar:SetFrame(n)
    for _,part in pairs(self._indexMap) do
        part:SetFrame(n)
    end
end

return _Avatar
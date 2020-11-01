--[[
    Desc: Resource module of engine, load basic resource with pool.
    Author: SerDing
    Since: 2019-12-06
    Alter: 2020-01-14
]]

local _STRING = require('engine.string')
local _FILE = require('engine.filesystem')

---@class Engine.Resource
local _RESOURCE = {}

local _pools = {
    aniData = {},
    spriteData = {},
    colliderData = {},
    image = {},
    font = {},
    sound = {},
    soundData = {},
}

local _meta = {__mode = 'v'}
for _, p in pairs(_pools) do
    setmetatable(p, _meta)
end

_RESOURCE.nullImg = love.graphics.newImage(love.image.newImageData(1, 1))
_RESOURCE.NewShader = love.graphics.newShader

---@param path string
---@return Image
function _RESOURCE.NewImage(path)
    if type(path) ~= "string" then
        return love.graphics.newImage(path)
    end
    
    return love.graphics.newImage("resource/image/" .. path .. ".png")
end

---@param path string
---@return SoundData 
function _RESOURCE.NewSoundData(path)
    return love.sound.newSoundData("resource/sound/" .. path .. ".ogg")
end

---@param path string
---@return Source
function _RESOURCE.NewSound(path)
    if type(path) ~= "string" then
        return love.audio.newSource(path)
    end

    return love.audio.newSource("resource/sound/" .. path .. ".ogg")
end

---@param path string
---@return Engine.Graphics.Drawable.SpriteData
function _RESOURCE.NewSpriteData(path)
    ---@type Engine.Graphics.Drawable.SpriteData
    local data = _RESOURCE.ReadData("Data/sprite/" .. path)
    data.image = _RESOURCE.LoadImage(path)

    return data
end

---@param path string
---@param newSpriteDataFunc function
---@param imgPath string | nil
---@return Engine.Resource.AniData
function _RESOURCE.NewAniData(path, newSpriteDataFunc, imgPath) 
    imgPath = imgPath and imgPath .. "/" or ""
    local staticData = _RESOURCE.ReadData("Data/animation/" .. path)

    ---@class Engine.Resource.AniData
    ---@field public path string
    ---@field public isLoop boolean
    ---@field public frames table<int, Engine.Graphics.Drawable.Frameani.Frame>
    ---@field public colliderData table<int, Entity.Collider.ColliderData>
    local data = {path = path, isLoop = staticData.isLoop or false, frames = {}}

    for k,v in pairs(staticData.frames) do
        data.frames[k] = {}
        data.frames[k].time = v.time
        if v.sprite then
            data.frames[k].data = _RESOURCE.LoadResource(imgPath .. v.sprite, newSpriteDataFunc, _pools.spriteData, imgPath)
        end
    end
    
    imgPath = string.sub(imgPath, 1, string.len(imgPath) - 1) -- delete '/'
    local aniName = string.sub(path, _STRING.FindCharReverse(path, "/") + 1, string.len(path))
    local colliderDataPath = (imgPath ~= "") and string.sub(imgPath, 1, _STRING.FindCharReverse(imgPath, "/")) .. aniName or path
    colliderDataPath = string.gsub(colliderDataPath, "entity/", "")
    data.colliderData = _RESOURCE.NewColliderData(colliderDataPath)

    -- if data.colliderData then
    --     print(path, imgPath, data.colliderData)
    -- end

    return data
end

function _RESOURCE.NewColliderData(path)
    path = "Data/entity/collider/" .. path
    local exists = _FILE.Exist(path .. ".dat")
    return exists and _RESOURCE.ReadData(path) or nil
end

---@param path string
---@return Image
function _RESOURCE.LoadImage(path)
    return _RESOURCE.LoadResource(path, _RESOURCE.NewImage, _pools.image)
end

---@param path string
---@return Source
function _RESOURCE.LoadSound(path)
    return _RESOURCE.LoadResource(path, _RESOURCE.NewSound, _pools.sound)
end

---@param path string
---@return SoundData
function _RESOURCE.LoadSoundData(path)
    return _RESOURCE.LoadResource(path, _RESOURCE.NewSoundData, _pools.soundData)
end

---@param path string
---@return Engine.Graphics.Drawable.SpriteData
function _RESOURCE.LoadSpriteData(path)
    return _RESOURCE.LoadResource(path, _RESOURCE.NewSpriteData, _pools.spriteData)
end

---@param path string
---@return Engine.Resource.AniData
function _RESOURCE.LoadAniData(path)
    -- print("_RESOURCE.LoadAnimData(path)", path)
    return _RESOURCE.LoadResource(path, _RESOURCE.NewAniData, _pools.aniData, _RESOURCE.NewSpriteData)
end

function _RESOURCE.ReadData(path)
    if type(path) == "table" then
        return path
    end
    path = path .. ".dat"
    assert(_FILE.Exist(path), "no file: ".. path) 
    local fileContent = _FILE.LoadFile(path)
    local A = _STRING.GetFileDirectory(path)
    fileContent = string.gsub(fileContent, "$A", A)
    return loadstring(fileContent)()
end

---@param path string
---@param newFunc function
---@param pool table
function _RESOURCE.LoadResource(path, newFunc, pool, ...)
    if pool[path] == nil then
        local t = newFunc(path, ...)
        pool[path] = t
    end

    return pool[path]
end

function _RESOURCE.RecursiveLoad(tab, loadFunc, keyword)
	if type(tab) == "table" and tab[keyword] == nil then
        for key, value in pairs(tab) do
            tab[key] = _RESOURCE.RecursiveLoad(value, loadFunc, keyword)
        end

        return tab
    else
        return loadFunc(tab)
    end
end

return _RESOURCE
--[[
	Desc: A manager to manage all resource in the game
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 22:10:59
	Docs:
]]

---@class _RESMGR
---@public field imageNull image
---@public field pathHead string
local _RESMGR = {}
local this = _RESMGR

function _RESMGR.Ctor()
	this.imageCachePool = {}
	this.soundCachePool = {}
	this.count = 0
	this.maxSize = 700
	this.pathHead = "/ImagePacks/"
	this.soundPathList = require "Config.SoundPack"

	local _cacheNameList = {
		"/ImagePacks/character/swordman/equipment/avatar/skin/sm_body0001.img/",
		"/ImagePacks/character/swordman/equipment/avatar/weapon/sswd/sswd4200c.img/",
		"/ImagePacks/character/swordman/equipment/avatar/weapon/katana/katana3201b.img/",
		"/ImagePacks/character/swordman/equipment/avatar/weapon/katana/katana3201c.img/",
		
		"/ImagePacks/character/swordman/effect/gorecross/gorecross_cross.img/",
		"/ImagePacks/character/swordman/effect/gorecross/gorecross_obj_cross_ldodge.img/",
		"/ImagePacks/character/swordman/effect/gorecross/gorecross_obj_cross_none.img/",
		"/ImagePacks/character/swordman/effect/gorecross/gorecross_slash.img/",
	}
	-- cache some images by img pack
	for n = 1, #_cacheNameList do
		this.LoadTextureByImg(_cacheNameList[n])
	end 

	local imgData = love.image.newImageData(1, 1)
	this.imageNull = love.graphics.newImage(imgData)
	this._timer = 0
end

function _RESMGR.Update(dt)
	-- print the amount of the resource pool
	this._timer = this._timer + dt
	if this._timer > 0.016 * 60 then
		this._timer = 0
		print("ResPool_Count:", _RESMGR.count)
	end
end

function _RESMGR.LoadTexture(path, cache)
	local texture = this.imageCachePool[path]
	if texture then
		return texture
	end
	-- not found in pool, create one.
	this.imageCachePool[path] = love.graphics.newImage(path)
	this.count = this.count + 1
	-- proc overflow of pool.
	if this.count > this.maxSize then
		table.remove(this.imageCachePool, 1)
	end
	return this.imageCachePool[path]
end

function _RESMGR.LoadSound(path, cache)
	if not cache then
		local sound = this.soundCachePool[path]
		if sound then
			return sound
		end
	end
	-- not found in pool or force to reload, then create new one.
	this.soundCachePool[path] = love.audio.newSource(path, "static")
	return this.soundCachePool[path]
end

function _RESMGR.LoadTextureByImg(filePath)
	
	local tmpArray = string.split(filePath,"/")
	
	local _offsetName = string.gsub(tmpArray[#tmpArray - 1],".img",".txt")
	
	if love.filesystem.exists(strcat(filePath,"offset.txt")) == false
	and love.filesystem.exists(strcat(filePath,_offsetName)) == false then
		print("The img pack is not existing:",filePath)
		return
	end

	local _offset_text

	if love.filesystem.exists(strcat(filePath , _offsetName)) then
		_offset_text = LoadFile(strcat(filePath, _offsetName))
	else 
		_offset_text = LoadFile(strcat(filePath, "offset.txt"))
	end 

	if _offset_text == nil then
		print("_RESMGR.LoadTextureByImg():Can not get offset data!" .. filePath)
		return
	end
	
	local  first_cut = split(_offset_text, "\n")

	local _num = table.getn(first_cut)

	if first_cut[#first_cut] == "" then
		_num = _num - 1
	end 
	
	for n=0,_num - 1 do
		this.LoadTexture(strcat(filePath, tostring(n), ".png"),true)
	end 

end

function _RESMGR.LoadDataFile(path)
	return require(string.sub(path, 1, string.len(path) - 4))
end

function _RESMGR.InstantiateImageData(imagedata)
	--[[
		all of pixel value in imagedata are zero,
		this method will set them to a non-zero value to 
		make them can be visible when they are draw
	]]

	local w = imagedata:getWidth()
	local h = imagedata:getHeight()

	for x = 0, w - 1 do
		for y = 0, h - 1 do
			imagedata:setPixel(x, y, 255, 255, 255, 255) -- set color of pixel to white
		end
	end
end

return _RESMGR
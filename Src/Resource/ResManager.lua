--[[
	Desc: A manager to manage all resource in the game
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 22:10:59
	Docs:
		* LoadTexture(filePath) find repeated resource by filePath
		* LoadSound(filePath) is similar to LoadTexture()
]]

local _RESMGR = {
	imageCachePool = {},
	soundCachePool = {},
	count = 0,
	maxSize = 1200,
	pathHead = "/ImagePacks/"
}

local _time = 0
function _RESMGR.Ctor() --initialize
	_RESMGR.soundPathList = require "Config.SoundPack" 
	-- print(_RESMGR.soundPathList.SM_ATK_01) -- OK

	-- [[ caching texture in some img packages advanced ]]
	
	-- for n=0, 209 do
	-- 	local _tmpPath = "/ImagePacks/character/swordman/equipment/avatar/skin/sm_body0001.img/"
	-- 	_RESMGR.LoadTexture(strcat(_tmpPath, tostring(n), ".png"),true)
	-- end 

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

	for n=1,#_cacheNameList do
		_RESMGR.LoadTextureByImg(_cacheNameList[n])
	end 
end

function _RESMGR.Update(dt)
	-- Display the amount of the resource pool
	_time = _time + dt
	if _time > 0.016 * 60 then
		_time = 0
		print("ResPool_Count:", _RESMGR.count)
	end
end

function _RESMGR.LoadTexture(path, cache)
	local texture = _RESMGR.imageCachePool[path]
	if texture then
		return texture
	end
	-- not found in pool, create one.
	_RESMGR.imageCachePool[path] = love.graphics.newImage(path)
	_RESMGR.count = _RESMGR.count + 1
	-- proc overflow of pool size
	if _RESMGR.count > _RESMGR.maxSize then
		table.remove(_RESMGR.imageCachePool, 1)
	end
	return _RESMGR.imageCachePool[path]
end

function _RESMGR.LoadSound(path, cache)
	if not cache then
		local sound = _RESMGR.soundCachePool[path]
		if sound then
			return sound
		end
	end
	-- not found in pool or force to reload, then create new one.
	_RESMGR.soundCachePool[path] = love.audio.newSource(path)
	return _RESMGR.soundCachePool[path]
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
		print("Error:_ResPack:Ctor() --> Can not get offset data!" .. filePath)
		return
	end
	
	local  first_cut = CutText(_offset_text, "\n")

	local _num = table.getn(first_cut)

	if first_cut[#first_cut] == "" then
		_num = _num - 1
	end 
	
	for n=0,_num - 1 do
		_RESMGR.LoadTexture(strcat(filePath, tostring(n), ".png"),true)
	end 

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
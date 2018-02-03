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
	resPool = {},
	soundCachePool = {},
	pathHead = "/ImagePacks/"
}


function _RESMGR.Ctor() --initialize
	_RESMGR.soundList = require "./Config.SoundPack" 
	-- print(_RESMGR.soundList.SM_ATK_01)

	-- [[ caching texture in some img packages advanced ]]
	
	-- for n=0, 209 do
	-- 	local _tmpPath = "/ImagePacks/character/swordman/equipment/avatar/skin/sm_body0001.img/"
	-- 	_RESMGR.LoadTexture(_tmpPath .. tostring(n) .. ".png",true)
	-- end 

	local _cacheNameList = {
		"/ImagePacks/character/swordman/equipment/avatar/skin/sm_body0001.img/",
		"/ImagePacks/character/swordman/equipment/avatar/weapon/sswd4200c.img/",
		"/ImagePacks/character/swordman/equipment/avatar/weapon/katana/katana0003b.img/",
		"/ImagePacks/character/swordman/equipment/avatar/weapon/katana/katana0003c.img/",
		

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

	-- Display the amount of the resource poll
	-- print( "ResCachePool_Number:"  .. tostring(table.getn(_RESMGR.imageCachePool)) )
end

function _RESMGR.LoadTexture(filePath,cache)
	if not cache then
		-- [[ find objected texture in imageCachePool ]]
		for n = 1 , table.getn(_RESMGR.imageCachePool) do
			if(_RESMGR.imageCachePool[n].filePath == filePath)then
				return _RESMGR.imageCachePool[n].pointing
			end
		end
	end 
	
	-- [[ find nothing then create objceted texture ]]
	local _tmpImage = {pointing = 0, filePath = filePath}
    _tmpImage.pointing =  love.graphics.newImage(filePath)
    _RESMGR.imageCachePool[#_RESMGR.imageCachePool + 1] = _tmpImage
	
	if cache then
		_tmpImage = nil
	else 
		return _tmpImage.pointing 
	end 
	
end


function _RESMGR.LoadSound(filePath,cache) -- cache : early caching resource

	if not cache then
		-- [[ find objected sound in imageCachePool ]]
		for n = 1 , #_RESMGR.soundCachePool do
			if(_RESMGR.soundCachePool[n].filePath == filePath)then
				return _RESMGR.soundCachePool[n].pointing
			end
		end
	end

	-- [[ find nothing then create objceted texture ]]
	local _tmpSound = {pointing = 0, filePath = filePath}
    _tmpSound.pointing = love.audio.newSource(filePath)
    _RESMGR.soundCachePool[ #_RESMGR.soundCachePool + 1] = _tmpSound
	
	if cache then
		_tmpSound = nil
	else 
		return _tmpSound.pointing 
	end 
	
end

function _RESMGR.LoadTextureByImg(filePath)
	
	local tmpArray = string.split(filePath,"/")
	
	local _offsetName = string.gsub(tmpArray[#tmpArray - 1],".img",".txt")
	
	if(love.filesystem.exists(filePath .. "offset.txt") == false
	and love.filesystem.exists(filePath .. _offsetName) == false
	)then
		print("The img pack is not existing:",filePath)
		return
	end

	local _offset_text

	if(love.filesystem.exists(filePath  .. _offsetName))then
		_offset_text = LoadFile(filePath .. _offsetName)
	else 
		_offset_text = LoadFile(filePath .. "offset.txt")
	end 

	if(_offset_text == nil)then
		print("Error:_ResPack:Ctor() --> Can not get offset data!" .. filePath)
		return
	end
	
	local  first_cut = CutText(_offset_text, "\n")

	local _num = table.getn(first_cut)

	if first_cut[#first_cut] == "" then
		_num = _num - 1
	end 
	
	for n=0,_num - 1 do
		_RESMGR.LoadTexture(filePath .. tostring(n) .. ".png",true)
		print(filePath .. tostring(n) .. ".png")
	end 

end

return _RESMGR
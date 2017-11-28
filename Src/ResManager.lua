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
	
	for n=0, 209 do
		local _tmpPath = "/ImagePacks/character/swordman/equipment/avatar/skin/sm_body0001.img/"
		_RESMGR.LoadTexture(_tmpPath .. tostring(n) .. ".png",true)
	end 

end

function _RESMGR.Update(dt)

	-- Suggest the amount of the resource poll
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

return _RESMGR
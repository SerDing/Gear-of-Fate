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
	_RESMGR.imageCachePool = {}
	_RESMGR.resPool = {}
	_RESMGR.soundCachePool = {}

end


function _RESMGR.Update(dt)

	-- Suggest the amount of the resource poll
	-- print( "ResCachePool_Number:"  .. tostring(table.getn(_RESMGR.imageCachePool)) )
end


function _RESMGR.LoadTexture(filePath)


	for n = 1 , table.getn(_RESMGR.imageCachePool) do
	    if(_RESMGR.imageCachePool[n].filePath == filePath)then
	    	return _RESMGR.imageCachePool[n].pointing
	    end
	end


	local _tmpImage = {pointing = 0, filePath = filePath}
    _tmpImage.pointing =  love.graphics.newImage(filePath)
    _RESMGR.imageCachePool[#_RESMGR.imageCachePool + 1] = _tmpImage
    return _tmpImage.pointing
end


function _RESMGR.LoadSound(filePath)

	for n = 1 , #_RESMGR.soundCachePool do
	    if(_RESMGR.soundCachePool[n].filePath == filePath)then
	    	return _RESMGR.soundCachePool[n].pointing
	    end
	end


	local _tmpSound = {pointing = 0, filePath = filePath}
    _tmpSound.pointing = love.audio.newSource(filePath)
    _RESMGR.soundCachePool[ #_RESMGR.soundCachePool + 1] = _tmpSound
    return _tmpSound.pointing
end

return _RESMGR
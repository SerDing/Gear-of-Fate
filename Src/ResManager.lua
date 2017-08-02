--[[
	Desc: A manager to manage all resource in the game
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 22:10:59
	Docs:
		* LoadTexture(FilePath) find repeated resource by FilePath
		* LoadSound(FilePath) is similar to LoadTexture()
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


function _RESMGR.LoadTexture(FilePath)


	for n = 1 , table.getn(_RESMGR.imageCachePool) do
	    if(_RESMGR.imageCachePool[n].FilePath == FilePath)then
	    	return _RESMGR.imageCachePool[n].pointing
	    end
	end


	local _tmpImage = {pointing = 0, FilePath = FilePath}
    _tmpImage.pointing =  love.graphics.newImage(FilePath)
    table.insert(_RESMGR.imageCachePool, #_RESMGR.imageCachePool, _tmpImage)
    return _tmpImage.pointing
end


function _RESMGR.LoadSound(FilePath)

	for n = 1 , #_RESMGR.soundCachePool do
	    if(_RESMGR.soundCachePool[n].FilePath == FilePath)then
	    	return _RESMGR.soundCachePool[n].pointing
	    end
	end


	local _tmpSound = {pointing = 0, FilePath = FilePath}
    _tmpSound.pointing = love.audio.newSource(FilePath)
    table.insert(_RESMGR.soundCachePool, #_RESMGR.soundCachePool, _tmpSound)
    return _tmpSound.pointing
end

return _RESMGR
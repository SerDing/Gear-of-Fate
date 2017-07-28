-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-02 20:57:37
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-21 17:28:55


ResMgr = class()


function ResMgr:init() --initialize

	Game.resPool = {}


end


function ResMgr:update(dt)

	-- 监视资源缓存池的情况
	-- print( "ResCachePool_Number:"  .. tostring(table.getn(Game.imageCachePool)) )
end


function ResMgr:LoadTexture(FilePath)

	-- 通过循环 遍历查找当前资源缓存池中是否存在目标资源 避免重复加载相同资源
	for n = 1 , #Game.imageCachePool do
	    if(Game.imageCachePool[n].FilePath == FilePath)then -- 若存在
	    	return Game.imageCachePool[n].pointing --直接返回资源指针
	    end
	end

	-- 不存在 则 加载该资源 并将其加入缓存池中
	local TmpImage = {pointing = 0, FilePath = FilePath} --定义资源格式：指针 路径标识
    TmpImage.pointing =  love.graphics.newImage(FilePath)
    table.insert(Game.imageCachePool, #Game.imageCachePool, TmpImage)
    return TmpImage.pointing --返回资源指针
end


function ResMgr:LoadSound(FilePath)

	-- 通过循环 遍历查找当前资源缓存池中是否存在目标资源 避免重复加载相同资源
	for n = 1 , #Game.soundCachePool do
	    if(Game.soundCachePool[n].FilePath == FilePath)then -- 若存在
	    	return Game.soundCachePool[n].pointing --直接返回资源指针
	    end
	end

	-- 不存在 则 加载该资源 并将其加入缓存池中
	local TmpSound = {pointing = 0, FilePath = FilePath} --定义资源格式：指针 路径标识
    TmpSound.pointing = love.audio.newSource(FilePath)
    table.insert(Game.soundCachePool, #Game.soundCachePool, TmpSound)
    return TmpSound.pointing --返回资源指针
end

return ResMgr
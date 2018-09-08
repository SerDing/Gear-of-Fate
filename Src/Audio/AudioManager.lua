--[[
	Desc: Audio Manager for game
	Author: Night_Walker 
	Since: 2018-08-02 00:13:14 
	Last Modified time: 2018-08-02 00:13:14 
	Docs: 
		* Write notes here even more 
]]

local _AudioMgr = {}

local _RESMGR = require "Src.Resource.ResManager"

-- References
local music_ = {
    ["BGM"] = {id = "", source = nil},
    ["EVM"] = {id = "", source = nil},
}
local sound_ = {id = "", source = nil}

function _AudioMgr.Init()
    _AudioMgr.pathHead = "/SoundPacks/"
    _AudioMgr.pathList = require("/Config/audio")
end 

local function _randomSoundID(randomID)
    local _realID = string.sub(randomID, 3, string.len(randomID))
    
    local i = 1
    while _AudioMgr.pathList[strcat(_realID, string.format("_%02d", i))] do
        i = i + 1
    end

    local _rangeUpper = i - 1
    local _rstr = strcat(_realID, string.format( "_%02d", math.random(1, _rangeUpper)))
    return _rstr
end

function _AudioMgr.PlaySound(id)
    id = string.upper(id)

    if string.sub(id, 1, 2) == "R_" then -- 'R_' head means get random id like "SW_ATK_01 / SW_ATK_02 / SW_ATK_03"
        id = _randomSoundID(id)
    end
    assert(_AudioMgr.pathList[id], "_AudioMgr.PlaySound(id) cannot find path by id:" .. id)
    
    local _PATH = strcat(_AudioMgr.pathHead, _AudioMgr.pathList[id])
    if not love.filesystem.exists(_PATH) then
        print("Error: _AudioMgr --> PlaySound() file not exists:")
        print("\t - ", _PATH)

        return 0
    end

    if sound_.id ~= id then
        sound_.source = _RESMGR.LoadSound(_PATH)
        sound_.id = id
    end

    if sound_.source:isPlaying() then
        -- sound_.source:rewind() -- replay
        sound_.source = _RESMGR.LoadSound(_PATH, true)
        sound_.source:play()
    else
        sound_.source:play()
    end
    
    sound_.source:setVolume(1.0)
end 

function _AudioMgr.PlaySceneMusic(id_table) -- play map music
    -- example: id_table = {"AMB_FOREST_01", "M_FOREST_01_NEW"}
    _AudioMgr.PlayEVM(id_table[1])
    _AudioMgr.PlayBGM(id_table[2])
end

function _AudioMgr.PlayBGM(id) -- play background music
    -- _AudioMgr.PlayMusic("BGM", id)
    -- music_["BGM"].source:setVolume(0.5)
end

function _AudioMgr.PlayEVM(id) -- play enviroment music
    _AudioMgr.PlayMusic("EVM", id)
    music_["EVM"].source:setVolume(0.5)
end

function _AudioMgr.PlayMusic(tp, id) -- play music
    assert(type(tp) == "string", "_AudioMgr.PlayMusic(tp, id) tp must be string! ")
    assert(type(id) == "string", "_AudioMgr.PlayMusic(tp, id) id must be string! ")
    id = string.upper(id)
    if music_[tp].id == id then
        if not music_[tp].source:isPlaying() then
            music_[tp].source:play()
        end
    else
        -- stop last music
        if music_[tp].source then
            music_[tp].source:stop()
        end 

        local _PATH
        if tp == "BGM" then
            _PATH = _AudioMgr.pathList[id]
        elseif tp == "EVM" then
            _PATH = _AudioMgr.pathHead .. _AudioMgr.pathList[id]
        end

        if not love.filesystem.exists(_PATH) then -- check file exists
            print("Error: _AudioMgr --> PlayMusic()" .. tp .. " file not exists:")
            print("\t - ", _PATH)

            return 0
        end
        
        -- file exists, make the source point to new source
        music_[tp].source = _RESMGR.LoadSound(_PATH)
        music_[tp].source:setLooping(true)
        music_[tp].source:play()
        music_[tp].id = id -- record new index
    end


end

return _AudioMgr 
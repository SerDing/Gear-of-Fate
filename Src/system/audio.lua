--[[
	Desc: Audio module of engine
	Author: SerDing
	Since: 2018-08-02
	Alter: 2020-01-19
]]

local _RESOURCE = require('engine.resource')

---@class System.Audio
local _Audio = {}

local _music = {
    ["BGM"] = {id = '', source = nil},
    ["EVM"] = {id = '', source = nil},
}
local _sound = {id = '', source = nil}

function _Audio.Init(bgmVol, soundVol)
    _Audio._bgmVol = bgmVol or 0.005 -- 0.005  0.65
    _Audio._soundVol = soundVol or 0.085 -- 0.0085   1
    _Audio.pathHead = "SoundPacks/"
    _Audio.audioList = dofile("Config/audio.lua")
end

---@param id string
---@return string
local function _randomSoundID(randomID)
    local realID = string.sub(randomID, 3, string.len(randomID)) -- skip "R_"
    
    local i = 1
    while _Audio.audioList[realID .. string.format("_%02d", i)] do
        i = i + 1
    end
    local upperRange = i - 1

    local rstr = realID .. string.format( "_%02d", math.random(1, upperRange))
    return rstr
end

---@param id string 
function _Audio.PlaySound(id)
    id = string.upper(id)

    if string.sub(id, 1, 2) == "R_" then -- 'R_' head means get random id like "SW_ATK_01 / SW_ATK_02 / SW_ATK_03"
        id = _randomSoundID(id)
    end
    assert(_Audio.audioList[id], "_AudioMgr.PlaySound(id) cannot find path by id:" .. id)
    
    local _PATH = _Audio.pathHead .. _Audio.audioList[id]
    if not love.filesystem.exists(_PATH) then
        print("sound file does not exist:\n\t - " .. _PATH)

        return false
    end

    _sound.id = id
    _sound.source = _RESOURCE.NewSound(_RESOURCE.LoadSoundData(_PATH))
    _sound.source:play()
    _sound.source:setVolume(1.0 * _Audio._soundVol)
end 

---@param id_table table
function _Audio.PlaySceneMusic(id_table) -- play map music
    -- example: id_table = {"AMB_FOREST_01", "M_FOREST_01_NEW"}
    _Audio.PlayEVM(id_table[1])
    _Audio.PlayBGM(id_table[2])
end

function _Audio.PlayBGM(id) -- play background music
    _Audio.PlayMusic("BGM", id)
    _music["BGM"].source:setVolume(0.5 * _Audio._bgmVol)
end

function _Audio.PlayEVM(id) -- play enviroment music
    _Audio.PlayMusic("EVM", id)
    _music["EVM"].source:setVolume(0.5 * _Audio._bgmVol)
end

---@param tp string
---@param id string
function _Audio.PlayMusic(tp, id) -- play music
    assert(type(tp) == "string", "_AudioMgr.PlayMusic(tp, id) tp must be string! ")
    assert(type(id) == "string", "_AudioMgr.PlayMusic(tp, id) id must be string! ")
    id = string.upper(id)
    if _music[tp].id == id then
        if not _music[tp].source:isPlaying() then
            _music[tp].source:play()
        end
    else
        -- stop last music
        if _music[tp].source then
            _music[tp].source:stop()
        end 

        local _PATH
        if tp == "BGM" then
            _PATH = _Audio.audioList[id]
        elseif tp == "EVM" then
            _PATH = _Audio.pathHead .. _Audio.audioList[id]
        end

        if not love.filesystem.exists(_PATH) then -- check file exists
            print("Error: _AudioMgr --> PlayMusic()" .. tp .. " file not exists:")
            print("\t - ", _PATH)

            return 0
        end
        
        -- file exists, make the source point to new source
        --music_[tp].source = _RESMGR.LoadSound(_PATH)
        _music[tp].source = _RESOURCE.LoadSound(_PATH)
        _music[tp].source:setLooping(true)
        _music[tp].source:play()
        _music[tp].id = id -- record new index
    end


end

---@param volume number
function _Audio.SetSndVol(volume)
    assert(type(volume) == "number", "volume must be a number value.")
    _Audio._soundVol = volume
end

---@param volume number
function _Audio.SetBgmVol(volume)
    assert(type(volume) == "number", "volume must be a number value.")
    _Audio._bgmVol = volume
end

return _Audio
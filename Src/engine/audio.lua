--[[
	Desc: Audio module of engine
	Author: SerDing
	Since: 2018-08-02
	Alter: 2020-01-19
]]

local _RESOURCE = require('engine.resource')

---@class Engine.Audio
---@field protected _playingQueue table<number, soundData>
local _AUDIO = {}

local _music = {
    BGM = {id = '', source = nil},
    EVM = {id = '', source = nil},
}

function _AUDIO.Init(bgmVol, soundVol)
    _AUDIO._bgmVol = bgmVol or 0.005 -- 0.005   0.65
    _AUDIO._soundVol = soundVol or 0.085 -- 0.0085  1
    _AUDIO._playingQueue = {}
end

function _AUDIO.Update(dt)
    -- body
end

---@param soundData string 
function _AUDIO.PlaySound(soundData)
    local source = _RESOURCE.NewSound(soundData)
    source:setVolume(1.0 * _AUDIO._soundVol)
    source:play()
end 

function _AUDIO.RandomPlay(soundDataSet)
    local n = math.random(1, #soundDataSet)
    _AUDIO.PlaySound(soundDataSet[n])
end

---@param id_table table
function _AUDIO.PlaySceneMusic(id_table) -- play map music
    -- example: id_table = {"AMB_FOREST_01", "M_FOREST_01_NEW"}
    _AUDIO.PlayEVM(id_table[1])
    _AUDIO.PlayBGM(id_table[2])
end

function _AUDIO.PlayBGM(id) -- play background music
    _AUDIO.PlayMusic("BGM", id)
    _music["BGM"].source:setVolume(0.5 * _AUDIO._bgmVol)
end

function _AUDIO.PlayEVM(id) -- play enviroment music
    _AUDIO.PlayMusic("EVM", id)
    _music["EVM"].source:setVolume(0.5 * _AUDIO._bgmVol)
end

---@param tp string
---@param id string
function _AUDIO.PlayMusic(tp, id) -- play music
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
            _PATH = _AUDIO.audioList[id]
        elseif tp == "EVM" then
            _PATH = _AUDIO.pathHead .. _AUDIO.audioList[id]
        end

        if not love.filesystem.exists(_PATH) then -- check file exists
            print("Error: _AudioMgr --> PlayMusic()" .. tp .. " file not exists:")
            print("\t - ", _PATH)

            return 0
        end
        
        -- file exists, make the source point to new source
        -- music_[tp].source = _RESMGR.LoadSound(_PATH)
        _music[tp].source = _RESOURCE.LoadSound(_PATH)
        _music[tp].source:setLooping(true)
        _music[tp].source:play()
        _music[tp].id = id -- record new index
    end


end

---@param volume number
function _AUDIO.SetSndVol(volume)
    assert(type(volume) == "number", "volume must be a number value.")
    _AUDIO._soundVol = volume
end

---@param volume number
function _AUDIO.SetBgmVol(volume)
    assert(type(volume) == "number", "volume must be a number value.")
    _AUDIO._bgmVol = volume
end

return _AUDIO
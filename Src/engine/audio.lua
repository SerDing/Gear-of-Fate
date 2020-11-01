--[[
	Desc: Audio module of engine
	Author: SerDing
	Since: 2018-08-02
	Alter: 2020-01-19
]]
local _SETTING = require("setting")
local _RESOURCE = require('engine.resource')

---@class Engine.Audio
---@field protected _playingQueue table<number, soundData>
local _AUDIO = {}

local _music = {
    _BGM = {id = '', source = nil},
    _AMB = {id = '', source = nil},
    _playingQueue = {},
}

function _AUDIO.Update(dt)
    -- body
end

---@param soundData SoundData|string 
function _AUDIO.PlaySound(soundData)
    local source = _RESOURCE.NewSound(soundData)
    source:setVolume(0.7 * _SETTING.sound)
    source:play()
end 

---@param soundDataSet table<int, SoundData>
function _AUDIO.RandomPlay(soundDataSet)
    local n = math.random(1, #soundDataSet)
    _AUDIO.PlaySound(soundDataSet[n])
end

---@param idTable table
function _AUDIO.PlaySceneMusic(idTable) -- play map music
    -- example: idTable = {"AMB_FOREST_01", "M_FOREST_01_NEW"}
    _AUDIO.PlayAMB(idTable[1])
    _AUDIO.PlayBGM(idTable[2])
end

function _AUDIO.PlayBGM(id) -- play background music
    _AUDIO.PlayMusic("BGM", id)
    _music._BGM.source:setVolume(_SETTING.music)
end

function _AUDIO.PlayAMB(id) -- play ambient music
    _AUDIO.PlayMusic("EVM", id)
    _music._AMB.source:setVolume(_SETTING.music)
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
            print("Error: AUDIO:PlayMusic()" .. tp .. " no file:")
            print("\t - ", _PATH)

            return false
        end
        
        -- file exists, make the source point to new source
        -- music_[tp].source = _RESMGR.LoadSound(_PATH)
        _music[tp].source = _RESOURCE.LoadSound(_PATH)
        _music[tp].source:setLooping(true)
        _music[tp].source:play()
        _music[tp].id = id -- record new index
    end

end

return _AUDIO
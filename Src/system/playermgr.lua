--[[
    Desc: Player manager.
    Author: SerDing
    Since: 2020-10-13T19:54:48.608Z+08:00
    Alter: 2020-10-13T19:54:48.608Z+08:00
]]

local _Event = require("core.event")

---@class PlayerManager
---@field protected _players table<int, Entity>
---@field protected _mainPlayer Entity
---@field public onSetMainPlayer Event @func(preMainPlayer, newMainPlayer)
local _PLAYERMGR = {
    _players = {},
    _mainPlayer = nil,
    onSetMainPlayer = _Event.New(),
}

local this = _PLAYERMGR

---@param player Entity
---@param isMain boolean
function _PLAYERMGR.Add(player, isMain)
    this._players[#this._players + 1] = player
    if isMain then
        _PLAYERMGR.SetMainPlayer(player)
    end
end


---@param player Entity
function _PLAYERMGR.SetMainPlayer(player)
    if this._mainPlayer == player then
        return 
    end

    player.fighter:SetAura("player")
    player.aic.enable = false
    
    if this._mainPlayer then
        this._mainPlayer.aic.enable = true
        if not this._mainPlayer.fighter.isDead then
            local auraType = (player.identity.camp == this._mainPlayer.identity.camp) and "partner" or nil --TODO:add partner check
            this._mainPlayer.fighter:SetAura(auraType)
        end
    end
    
    this.onSetMainPlayer:Notify(player)
    this._mainPlayer = player
end

function _PLAYERMGR.GetMainPlayer()
    return this._mainPlayer
end

return _PLAYERMGR
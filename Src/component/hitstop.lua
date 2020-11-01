--[[
	Desc: HitStop, a component for stopping effect when attack hit enemy.
	Author: SerDing 	
	Since: 2019-11-04 01:05:38 
	Alter: 2020-10-10 01:05:38
]]
local _Timer = require("utils.timer")
local _Base = require("component.base")

---@class Entity.Component.HitStop : Entity.Component.Base
local _HitStop = require("core.class")(_Base)

local _stopList = {"state", "render", "movement"}

---@param entity Entity
function _HitStop:Ctor(entity)
    _Base.Ctor(self, entity) 
    self._timer = _Timer.New()
    self._identity = self._entity.identity
end

function _HitStop:Enter(time)
    self._timer:Start(time)
    self._identity.isPaused = true
end

function _HitStop:Update(dt)
    if not self._identity.isPaused then
        return false
    end
    
    self._timer:Tick(dt)
    if self._timer.isRunning == false then
        self._identity.isPaused = false
    end
end

return _HitStop
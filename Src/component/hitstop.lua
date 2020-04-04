--[[
    Desc: HitStop, a component for stopping running when attack hit enemy.
    Author: SerDing
    Since: 2019-11-04
    Alter: 2019-12-08
]]

local _Timer = require("utils.timer")

---@class Entity.Component.HitStop : Entity.Component.Base
local _HitStop = require("core.class")()

local _constStopComponents = {'state', 'avatar', 'Movement', "effect"}

---@param entity GameObject
function _HitStop:Ctor(entity)
    self._entity = entity
    self._timer = _Timer.New()
    self._timer:SetAction(
        function ()
            self:SetComponentsEnable(true)
            self.isStopping = false
            print("hitstop enable")
        end
    )
    self.isStopping = false
end

function _HitStop:Enter(time)
    self._timer:Start(time)
    self:SetComponentsEnable(false)
    self.isStopping = true
end

function _HitStop:Update(dt)
    self._timer:Tick(dt)
end

function _HitStop:SetComponentsEnable(state)
    local cp
    for i = 1, #_constStopComponents do
        cp = self._entity[_constStopComponents[i]]
        if cp then
            cp.enable = state
        end
    end
end

return _HitStop
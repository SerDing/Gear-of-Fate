--[[
    Desc: a component for projectile logic
    Feature:
        1.Death: by anim playing end / by time / by distance
        2.Combat: Attack / BeHit
        3.Move: forward / changeDirection
    Author: SerDing
    Since: 2020-03-18
    Alter: 2020-03-18
]]
local _Base = require("component.base")

---@class Entity.Component.Projectile : Entity.Component.Base
local _Projectile = require("core.class")(_Base)

function _Projectile:Ctor(entity, data, param)
    _Base.Ctor(self, entity)
    self._playEnd = data.playEnd
    self._attack = data.attack
    self._maxDistance = data.maxDistance
    self._movementParam = data.movementParam
    self._entity.combat:StartAttack(self._attack)
end

function _Projectile:Update(dt)
    if not self.enable or self._entity.fighter.isDead then
        return
	end

    if self._movementParam and self._entity.render.renderObj:GetTick() == self._movementParam.tick then
        self._entity.movement:EaseMove(self._movementParam.type, self._movementParam.v, self._movementParam.a)
    end

    if self._entity.identity.master then
        if self._playEnd then
            if self._entity.render.renderObj:TickEnd() then
                self._entity.identity:StartDestroy()
            end
        else
            -- death by time / distance
        end
    end
end

return _Projectile
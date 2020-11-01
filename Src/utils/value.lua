--[[
    Desc: Value, a util for finite variable object.
    Author: SerDing
    Since: 2019-12-06
    Alter: 2019-12-06
]]

local _Event = require("core.event")

---@class Utils.PositiveValue
---@field protected _cur float
---@field protected _max float
---@field protected _autoVariable boolean
---@field protected _varySpeed float
---@field public onValueChange Event
local _PositiveValue = require("core.class")()

function _PositiveValue:Ctor(cur, max, varySpeed)
    self._cur = cur or 100
    self._max = max or 100
    self._autoVariable = (varySpeed == 0) and false or true
    self._varySpeed = varySpeed or 0
    self.onValueChange = _Event.New()
end

function _PositiveValue:Update(dt)
    if self._autoVariable then
        local Func = self._varySpeed > 0 and self.Increase or self.Decrease
        Func(self, self._varySpeed * dt)
    end
end

---@param delta float @ delta > 0
function _PositiveValue:Increase(delta)
    local newValue = self._cur + delta
    if newValue > self._max then
        newValue = self._max
    end
    local change = newValue - self._cur
    self._cur = newValue
    self.onValueChange:Notify("increase", change)
end

---@param delta float @ delta > 0
function _PositiveValue:Decrease(delta)
    local newValue = self._cur - delta
    if newValue < 0 then
        newValue = 0
    end
    local change = newValue - self._cur--self._cur - newValue
    self._cur = newValue
    self.onValueChange:Notify("decrease", change)
end

function _PositiveValue:GetCur()
    return self._cur
end

function _PositiveValue:GetMax()
    return self._max
end

return _PositiveValue
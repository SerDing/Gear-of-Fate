--[[
    Desc: Value, a util class.
    Author: SerDing
    Since: 2019-12-06
    Alter: 2019-12-06
]]

local _Event = require("core.event")

---@class Utils.Value
---@field changeEvent Event
local _Value = require("core.class")()

function _Value:Ctor(cur, max, varySpeed)
    self._cur = cur or 100
    self._max = max or 100
    self.autoVariable = (varySpeed == 0) and false or true
    self.varySpeed = varySpeed or 0
    self.changeEvent = _Event.New()
end

function _Value:Update(dt)
    if self.autoVariable then
        self:Change(self.varySpeed * dt)
    end
end

function _Value:Change(deltaValue)
    
    local change = deltaValue
    if self._cur + deltaValue < 0 then
        change = -self._cur
    end

    self._cur = self._cur + deltaValue
    if self._cur < 0 then
        self._cur = 0
    end
    
    if self._cur > self._max then
        self._cur = self._max
    end

    if deltaValue > 0 then
        self.changeEvent:Notify("increase", change)
    else
        self.changeEvent:Notify("decrease", change)
    end
end

function _Value:GetCur()
    return self._cur
end

function _Value:GetMax()
    return self._max
end

return _Value
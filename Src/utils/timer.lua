--[[
	Desc: Timer, a util class.
 	Author: SerDing
	Since: 2019-08-24 21:45
	Alter: 2019-11-5 
]]
---@class Utils.Timer
---@field protected _time milli
---@field protected _count milli
---@field protected _action function
---@field protected isRunning boolean
local _Timer = require("core.class")()

---@param time milli
---@param action function
function _Timer:Ctor(time, action)
    self._count = 0
    self._time = time or 0
    self.isRunning = false
    self._action = action or nil
end

---@param dt float
function _Timer:Tick(dt)
    if not self.isRunning then
        return
    end

    self._count = self._count + dt * 1000
    if self._count >= self._time then
        if self._action ~= nil then
            self._action()
        end
        self.isRunning = false
    end
end

---@param time milli
function _Timer:Start(time, keepSurplus)
    self._count = (keepSurplus and self._count > self._time) and self._count - self._time or 0
    self._time = time
    self.isRunning = true
end

function _Timer:SetAction(action)
    self._action = action
end

function _Timer:Stop()
    self.isRunning = false
end

function _Timer:Continue()
    self.isRunning = true
end

function _Timer:Cancel()
    self:Stop()
    self._count = 0
end

function _Timer:GetCount()
    return self._count
end

return _Timer

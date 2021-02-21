--[[
    Desc: Radian, a radius convertion object. 
    Author: SerDing
    Since:2020-02-07
    Alter:2020-03-20
]]
---@class Engine.Graphics.Config.Radian
---@field protected _angle number
local _Radian = require("core.class")()

function _Radian:Ctor(angle)
    self:Set(angle or 0)
end

function _Radian:Set(angle)
    self._angle = angle
end

function _Radian:Get(isAngle)
    if isAngle then
        return self._angle
    else
        return math.rad(self._angle)
    end
end

return _Radian
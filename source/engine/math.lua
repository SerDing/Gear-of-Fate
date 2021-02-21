--[[
    Desc: Math module
    Author: SerDing
    Since: 2019-12-06
    Alter: 2019-12-06
]]

---@class Engine.Math
local _MATH = {}

function _MATH.GetDistance(p1, p2)
    return math.sqrt(math.pow(math.abs(p1.x - p2.x),2) + math.pow(math.abs(p1.y - p2.y),2))
end

---@param a float @start value
---@param b float @finish value
---@param time float @0.0 ~ 1.0
function _MATH.Lerp(a, b, time)
    return a + (b - a) * time
end

return _MATH
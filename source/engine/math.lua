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

function _MATH.GetFixNumber(number)
    return math.floor(number * 1000) / 1000
end

function _MATH.Sign(value)
    if value == 0 then
         return 0
    end

    return value > 0 and 1 or -1
end

---@param value number
---@param left number
---@param right number
---@param rangeOpen boolean
function _MATH.IsInRange(value, left, right, rangeOpen)
    if rangeOpen then
        return value >= left and value <= right
    else
        return value > left and value < right
    end
end

return _MATH
--[[
	Desc: Color, a kind of drawing config.
 	Author: SerDing
	Since: 2020-02-09
	Alter: 2020-02-09
]]
local _GRAPHICS = require("engine.graphics")

---@class Engine.Graphics.Config.Color
local _Color = require("core.class")()

--_Color.Ctor = _Color.Set
function _Color:Ctor(red, green, blue, alpha)
    self:Set(red, green, blue, alpha)
end

function _Color:Set(red, green, blue, alpha)
    self.red = red or self.red
    self.green = green or self.red
    self.blue = blue or self.red
    self.alpha = alpha or self.red
end

---@param color Engine.Graphics.Config.Color
function _Color:Copy(color)
    self:Set(color:Get())
end

--- Get one channel value or all values of a color instance.
---@param channel string
---@return int
function _Color:Get(channel)
    if channel then
        return self[channel]
    else
        return self.red, self.green, self.blue, self.alpha
    end
end

function _Color:Apply()
    _GRAPHICS.SetColor(self.red, self.green, self.blue, self.alpha)
end

function _Color:Reset()
    -- _GRAPHICS.ResetColor()
end

function _Color.White()
    return _Color.New(255, 255, 255, 255)
end

function _Color.Black()
    return _Color.New(0, 0, 0, 255)
end

_Color.const = {
    white = _Color.White(),
    black = _Color.Black(),
    red = _Color.New(255, 0, 0, 255),
    green = _Color.New(0, 255, 0, 255),
    blue = _Color.New(0, 0, 255, 255),
    yellow = _Color.New(255, 255, 0, 255),
}

return _Color
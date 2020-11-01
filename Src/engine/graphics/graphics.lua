--[[
	Desc: Graphics system of engine.
 	Author: SerDing
	Since: 2020-02-09
	Alter: 2020-02-09
]]

---@class Engine.Graphics.Graphics
local _GRAPHICS = {}

_GRAPHICS.Draw = love.graphics.draw
_GRAPHICS.Push = love.graphics.push
_GRAPHICS.Pop = love.graphics.pop
_GRAPHICS.Translate = love.graphics.translate
_GRAPHICS.Scale = love.graphics.scale
_GRAPHICS.DrawRect = love.graphics.rectangle
_GRAPHICS.Points = love.graphics.points
_GRAPHICS.Print = love.graphics.print
_GRAPHICS.SetShader = love.graphics.setShader
_GRAPHICS.GetWidth = love.graphics.getWidth
_GRAPHICS.GetHeight = love.graphics.getHeight

local _preBlendmode = ""
local _curBlendmode = "alpha"
local _preColor = {}
local _curColor = {red = 255, green = 255, blue = 255, alpha = 255}
local _preShader
local _curShader = love.graphics.getShader()
local _preFont
local _curFont = love.graphics.getFont()

love.graphics.setPointSize(5)
love.graphics.setBackgroundColor(100, 100, 100, 255)
function _GRAPHICS.Init()
end

function _GRAPHICS.SetColor(red, green, blue, alpha)
    if _curColor.red ~= red or _curColor.green ~= green or _curColor.blue ~= blue or _curColor.alpha ~= alpha then
        love.graphics.setColor(red, green, blue, alpha)

        _preColor.red = _curColor.red
        _preColor.green = _curColor.green
        _preColor.blue = _curColor.blue
        _preColor.alpha = _curColor.alpha

        _curColor.red = red
        _curColor.green = green
        _curColor.blue = blue
        _curColor.alpha = alpha
    end
end

function _GRAPHICS.ResetColor()
    _GRAPHICS.SetColor(_preColor.red, _preColor.green, _preColor.blue, _preColor.alpha)
end

function _GRAPHICS.SetBlendmode(blendmode)
    if blendmode ~= _curBlendmode then
        _preBlendmode = _curBlendmode
        _curBlendmode = blendmode
        love.graphics.setBlendMode(blendmode)
    end
end

function _GRAPHICS.ResetBlendmode()
    _GRAPHICS.SetBlendmode(_preBlendmode)
end

return _GRAPHICS
--[[
	Desc: Background of scene
	Author: SerDing
	Since: 2021-01-30
	Alter: 2021-02-01
]]
local _GRAPHICS = require("engine.graphics")
local _Frameani = require("engine.graphics.drawable.frameani")

---@class System.Scene.Background:Engine.Graphics.Drawable.Frameani
local _Background = require("core.class")(_Frameani)

function _Background:Ctor(data, rate)
	_Frameani.Ctor(self, data)
	self._scrollRate = 1.0 - rate or 0
	self._cameraTranslation = 0
end

function _Background:_OnDraw()
	_GRAPHICS.Push()
	_GRAPHICS.Translate(self._cameraTranslation * self._scrollRate, 0)
	_Frameani._OnDraw(self)
	_GRAPHICS.Pop()
end

function _Background:SetCameraTranslation(translation)
	self._cameraTranslation = translation
end

return _Background
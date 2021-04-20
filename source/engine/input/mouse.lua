--[[
	Desc: Mouse
	Author: SerDing
	Since: 2021-01-22 19:40:00
	Alter: 2021-01-26 00:12:00
]]
local _Event = require("core.event")
local _InputDevice = require("engine.input.inputdevice")
local _GRAPHICS = require("engine.graphics")

---@class Engine.Input.Mouse : Engine.Input.InputDevice
---@field protected _listeners table<int, Engine.Input.Mouse.MouseListener>
---@field protected _onMousePress Event
---@field protected _onMouseRelease Event
---@field protected _onMouseMove Event
local _Mouse = require("core.class")(_InputDevice)

function _Mouse:Ctor(INPUT)
	_InputDevice.Ctor(self, "mouse", INPUT)
	self._listeners = {}
	self._onMousePress = _Event.New()
	self._onMouseRelease = _Event.New()
	self._onMouseMove = _Event.New()
	self:_HookLoveCallbakcs()
end

function _Mouse:_HookLoveCallbakcs()
	---@param x number
	---@param y number
	---@param button int@left:1, middle:2, right:3.
	---@param istouch boolean
	local function _MousePressed(x, y, button, istouch)
		_InputDevice.Press(self, button)
		x, y = _Mouse.GetScaledMousePosition(x, y)
		for i = 1, #self._listeners do
			self._listeners[i]:OnMousePress(x, y, button, istouch)
		end
	end

	---@param x number
	---@param y number
	---@param button int@left:1, middle:2, right:3.
	---@param istouch boolean
	local function _MouseReleased(x, y, button, istouch)
		_InputDevice.Release(self, button)
		x, y = _Mouse.GetScaledMousePosition(x, y)
		for i = 1, #self._listeners do
			self._listeners[i]:OnMouseRelease(x, y, button, istouch)
		end
	end

	---@param x number
	---@param y number
	---@param dx number
	---@param dy number
	local function _MouseMoved(x, y, dx, dy)
		x, y = _Mouse.GetScaledMousePosition(x, y)
		dx, dy = _Mouse.GetScaledMousePosition(dx, dy)
		for i = 1, #self._listeners do
			self._listeners[i]:OnMouseMove(x, y, dx, dy)
		end
	end

	love.mousepressed = _MousePressed
	love.mousereleased = _MouseReleased
	love.mousemoved = _MouseMoved
end

function _Mouse:AddListener(obj)
	self._listeners[#self._listeners + 1] = obj
end

function _Mouse:DelListener(obj)
	for i = #self._listeners, 1, -1 do
		if self._listeners[i] == obj then
			table.remove(self._listeners, i)
			return true
		end
	end
	return false
end

---@param x float @ can be null
---@param y float @ can be null
function _Mouse.GetScaledMousePosition(x, y)
	x = x or love.mouse.getX()
	y = y or love.mouse.getY()
	local ratio = _GRAPHICS.GetDimensionRatio()
	return x / ratio.x, y / ratio.y
end

function _Mouse.GetRawPosition()
	return love.mouse.getPosition()
end

---@class Engine.Input.Mouse.MouseListener
local _MouseListener = require("core.class")()

function _MouseListener:OnMousePress()
end

function _MouseListener:OnMouseRelease()
end

function _MouseListener:OnMouseMove()
end

return _Mouse
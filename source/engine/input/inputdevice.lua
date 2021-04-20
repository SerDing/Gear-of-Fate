--[[
    Desc: Input state, a base class to manage input state of device or input component.
    Author: SerDing
    Since: 2021-04-05
    Alter: 2021-04-05
]]

local _INPUT_DEFINE = require("engine.input.inputdefine")

---@class Engine.Input.InputDevice
---@field protected _buttonState table<string, int>
---@field protected _axisState table<string, number>
---@field protected _INPUT Engine.Input
local _InputDevice = require("core.class")()

function _InputDevice:Ctor(deviceType, INPUT)
	self._deviceType = deviceType
	self._INPUT = INPUT
	self._buttonState = {}
	self._axisState = {} -- physical axis of controller / virtual axis of game
end

function _InputDevice:Update()
	for key, value in pairs(self._buttonState) do
		if value == _INPUT_DEFINE.STATE.PRESSED then
			self._buttonState[key] = _INPUT_DEFINE.STATE.DOWN
		end
		if value == _INPUT_DEFINE.STATE.RELEASED then
			self._buttonState[key] = nil
		end
	end
end

function _InputDevice:IsPressed(button)
	return self._buttonState[button] == _INPUT_DEFINE.STATE.PRESSED
end

function _InputDevice:IsDown(button)
	return self._buttonState[button] == _INPUT_DEFINE.STATE.DOWN
end

function _InputDevice:IsPressed(button)
	return self._buttonState[button] == _INPUT_DEFINE.STATE.RELEASED
end

function _InputDevice:Press(button)
	if not self._buttonState[button] then
		self._buttonState[button] = _INPUT_DEFINE.STATE.PRESSED

		return true
	end

	return false
end

function _InputDevice:Release(button)
	if self._buttonState[button] and self._buttonState[button] ~= _INPUT_DEFINE.STATE.RELEASED then
		self._buttonState[button] = _INPUT_DEFINE.STATE.RELEASED

		return true
	end

	return false
end

function _InputDevice:OnAxis(axis, newValue)
	if axis then
		self._axisState[axis] = newValue
	end
end



return _InputDevice
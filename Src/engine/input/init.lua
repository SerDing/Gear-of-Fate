--[[
	Desc: Input Module of Engine, manage input messages and devices
	Author: SerDing
	Since: 2018-04-06
	Alter: 2019-10-24
]]

---@class Engine.Input
---@field protected _inputStates table @input states for keyboard and gamePad
---@field protected _mode string @input mode
---@field protected _gamepad Joystick 
local _INPUT = {
    _gamepad = nil,
    _inputStates = {
        keyboard = {}, -- key states for keyboard
        gamepad = {}, -- button states for gamepad
    },
    _mode = "keyboard",
    _axisMap = {
        positive = {
            leftx = "RIGHT",
            lefty = "DOWN",
            triggerleft = "USE_ITEM",
            triggerright = "BACK",
        },
        negative = {
            leftx = "LEFT",
            lefty = "UP",
        }
    }
}

local _InputMap = require("Data.input.InputMap")
local _InputHandlers = {} ---@type table<number, Engine.Input.InputHandler>
local _AXIS_DEADBAND = 0.19
local _TRIGGER_DEADBAND = 0.19
local STATE = {PRESSED = 1,HOLD = 2, RELEASED = 3}

function _INPUT.Update(dt)
    for _, inputStates in pairs(_INPUT._inputStates) do
        for k,v in pairs(inputStates) do
            if v == STATE.PRESSED then
                inputStates[k] = STATE.HOLD
            elseif v == STATE.RELEASED then
                inputStates[k] = nil
            end 
        end 
    end
end

local function _PressButton(action)
    for i=1,#_InputHandlers do
        _InputHandlers[i]:Press(action)
    end
end

local function _ReleaseAction(action)
    for i=1,#_InputHandlers do
        _InputHandlers[i]:Release(action)
    end
end

---@param inputType string
---@param key string
function _INPUT.Press(inputType, key)
    _INPUT._mode = inputType
    _INPUT._inputStates[inputType][key] = STATE.PRESSED
    local action = _InputMap[inputType][key] or nil
    if action then
        _PressButton(action)
    end
end

---@param inputType string
---@param key string
function _INPUT.Release(inputType, key)
    _INPUT._mode = inputType
    _INPUT._inputStates[inputType][key] = STATE.RELEASED
    local action = _InputMap[inputType][key] or nil
    if action then
        _ReleaseAction(action)
    end
end

function _INPUT.HandleAxis(axis, newValue)
    local axisValue = _INPUT._gamepad:getGamepadAxis(axis)
    if axisValue > _AXIS_DEADBAND then
        _PressButton(_INPUT._axisMap.positive[axis])
    else
        _ReleaseAction(_INPUT._axisMap.positive[axis])
    end
    if axisValue < -_AXIS_DEADBAND then
        _PressButton(_INPUT._axisMap.negative[axis])
    else
        _ReleaseAction(_INPUT._axisMap.negative[axis])
    end
end

function _INPUT.KeyPressed(key)
	_INPUT.Press("keyboard", key)
	-- _UIMGR.KeyPressed(key)
end

function _INPUT.KeyReleased(key)
	_INPUT.Release("keyboard", key)
end

-- function _INPUT.MousePressed(x, y, button, istouch)
-- 	_UIMGR.MousePressed(x, y, button, istouch)
-- end

-- function _INPUT.MouseReleased(x, y, button, istouch)
-- 	_UIMGR.MouseReleased(x, y, button, istouch)
-- end

-- function _INPUT.MouseMoved(x, y, dx, dy)
-- 	_UIMGR.MouseMoved(x, y, dx, dy)
-- end

function _INPUT.JoystickAdded(joystick)
    if joystick:isGamepad() then
        _INPUT._gamepad = joystick
        print("_INPUT: Gamepad Connected:", joystick:getID(), joystick:getName(), joystick:getHatCount())
    end
end

---@param joystick Joystick
---@param axis string
---@param newValue number
function _INPUT.GamePadAxis(joystick, axis, newValue)
    if math.abs(newValue) >= _AXIS_DEADBAND then
        _INPUT._mode = "gamepad" 
    end

    _INPUT.HandleAxis(axis, newValue)
end

function _INPUT.GamePadPressed(joystick, button)
	_INPUT.Press("gamepad", button)
end

function _INPUT.GamePadReleased(joystick, button)
	_INPUT.Release("gamepad", button)
end

function _INPUT.IsKeyPressed(key)
    return _INPUT._inputStates.keyboard[key] == STATE.PRESSED
end

function _INPUT.IsKeyHold(key)
    return _INPUT._inputStates.keyboard[key] == STATE.HOLD
end

function _INPUT.IsKeyReleased(key)
    return _INPUT._inputStates.keyboard[key] == STATE.RELEASED
end

--- Is gamepad key pressed.
---@param btn string @ gamepad button 
function _INPUT.IsGPKeyPressed(btn)
    return _INPUT._inputStates.gamepad[btn] == STATE.PRESSED
end

--- Is gamepad key hold.
---@param btn string @gamepad button 
function _INPUT.IsGPKeyHold(btn)
    return _INPUT._inputStates.gamepad[btn] == STATE.HOLD
end

--- Is gamepad key released.
---@param btn string @ gamepad button 
function _INPUT.IsGPKeyReleased(btn)
    return _INPUT._inputStates.gamepad[btn] == STATE.RELEASED
end

---@param inputHandler Engine.Input.InputHandler
function _INPUT.Register(inputHandler)
    _InputHandlers[#_InputHandlers + 1] = inputHandler
end

---@param inputHandler Engine.Input.InputHandler
function _INPUT.UnRegister(inputHandler)
    local n = 0
    for i = 1, #_InputHandlers do
        if _InputHandlers[i] == inputHandler then
            n = i
        end
    end
    table.remove(_InputHandlers, n)
end

love.keypressed = _INPUT.KeyPressed
love.keyreleased = _INPUT.KeyReleased
-- love.mousepressed = _GAME.MousePressed
-- love.mousereleased = _GAME.MouseReleased
-- love.mousemoved = _GAME.MouseMoved
love.joystickadded = _INPUT.JoystickAdded
love.gamepadaxis = _INPUT.GamePadAxis
love.gamepadpressed = _INPUT.GamePadPressed
love.gamepadreleased = _INPUT.GamePadReleased

return _INPUT
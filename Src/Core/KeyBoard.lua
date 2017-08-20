--[[
	Desc. keyboard class
 	Author. Night_Walker
	Since. 2017-07-28 21.54.14
	Alter. 2017-07-30 12.40.40
	Docs.
		* New methods to check the key state
]]

local _KEYBOARD = {
    KEY = {} -- example { a = _enum_pressed,down = _enum_released} -- map stucture
}

local _enum_pressed = 1
local _enum_hold = 2
local _enum_released = 3

function _KEYBOARD.Update()
    for k,v in pairs(_KEYBOARD.KEY) do
        if v == _enum_pressed then
            _KEYBOARD.KEY[k] = _enum_hold
        elseif v == _enum_released then
            _KEYBOARD.KEY[k] = nil
        end 
    end 
end

function _KEYBOARD.Press(key)
	return _KEYBOARD.KEY[key] == _enum_pressed
end 

function _KEYBOARD.Hold(key)
	return _KEYBOARD.KEY[key] == _enum_hold
end

function _KEYBOARD.Release(key)
	return _KEYBOARD.KEY[key] == _enum_released
end

function _KEYBOARD.PressHandle(key)
    _KEYBOARD.KEY[key] = _enum_pressed
end

function _KEYBOARD.ReleaseHandle(key)
	_KEYBOARD.KEY[key] = _enum_released
end

return _KEYBOARD 
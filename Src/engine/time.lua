--[[
	Desc: Time Module
	Author: SerDing
	Since: 2021-02-05
	Alter: 2021-02-05
]]
---@class Engine.Time
local _TIME = {}
local _FRAME_MAX = 1000000000
local _frame = 0
local _Floor = math.floor

function _TIME._FrameUpdate()
	_frame = _frame + 1
	if _frame > _FRAME_MAX then
		_frame = 0
	end
end

function _TIME.Update(dt)
	_TIME._FrameUpdate()

	return _Floor(dt * 1000) / 1000
end

function _TIME.GetFrame()
	return _frame
end

function _TIME.GetDelta()
	return love.timer.getDelta()
end

function _TIME.GetTime()
	return love.timer.getTime()
end

function _TIME.GetFPS()
	return love.timer.getFPS()
end

return _TIME
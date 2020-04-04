--[[
	Desc: Frame animation
 	Author: SerDing
	Since: 2020-02-09 16:49
	Alter: 2020-02-09 16:49
]]
local _Timer = require("utils.timer")
local _Sprite = require("engine.graphics.drawable.sprite")

---@class Engine.Graphics.Drawable.Frameani : Engine.Graphics.Drawable.Sprite
---@field protected _animData Engine.Resource.AnimData
---@field protected _frame int
---@field protected _tick int
---@field protected _length int
---@field protected _timer Utils.Timer
local _Frameani = require("core.class")(_Sprite)

---@class Engine.Graphics.Drawable.Frameani.Frame
---@field public data Engine.Graphics.Drawable.SpriteData
---@field public time milli
local _Frame = require("core.class")()

function _Frameani:Ctor(animData)
    _Sprite.Ctor(self)
    self._animData = nil
    self._frame = 1
    self._tick = 0
    self._length = 0
    self._animData = nil
    self._timer = _Timer.New()
    self:Play(animData)
end

---@param dt float
function _Frameani:Update(dt, rate)
    self._tick = -1
    self._timer:Tick(dt * (rate or 1.0))
    if self._timer.isRunning == false then
        self._tick = self._frame
        if self._frame == self._length then
            if self._animData.isLoop == true then
                self:Reset()
            end
        else
            self._frame = self._frame + 1
        end
        self:Refresh()
    end
end

function _Frameani:Refresh()
    if self._animData then
        if self._animData.frames[self._frame].time then
            self._timer:Start(self._animData.frames[self._frame].time)
        else
            self._timer:Stop()
        end
        if self._animData.frames[self._frame].data then
            self:SetData(self._animData.frames[self._frame].data)
        else
            self:SetData()
        end
    else
        self:SetData()
    end
end

-- function _Frameani:Draw(x, y, r, sx, sy)    
--     _Sprite.Draw(x, y, r, sx, sy)
-- end

function _Frameani:Play(animData)
    self._animData = animData
    if self._animData then
        self._length = #self._animData.frames
    else
       self._length = 0
    end

    self:Reset()
    self:Refresh()
end

function _Frameani:Reset()
    self._frame = 1
    self._tick = 0
end

function _Frameani:SetFrame(frame)
    if frame > self._length then
        return false
    end
    self._frame = frame
    self._tick = frame - 1
    self:Refresh()
end

function _Frameani:NextFrame()
    local frame = self._frame + 1
    if frame > self._length then
        if self._animData.isLoop == true then
            frame = 1
        else
            return false
        end
    end
    self:SetFrame(frame)
end

function _Frameani:GetFrame()
    return self._frame
end

function _Frameani:GetTick()
    return self._tick
end

function _Frameani:TickEnd()
    return self._tick == self._length
end

return _Frameani
--[[
	Desc: Dash state (run)
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]

local _Vector2 = require("utils.vector2")
local _Base  = require "entity.states.base"

---@class State.Move : State.Base
local _Move = require("core.class")(_Base)

function _Move:Ctor(data, ...)
    _Base.Ctor(self, data, ...)
    self.name = "dash"
    self.time_up = 0
    self.time_down = 0
    self.time_left = 0
    self.time_right = 0
    self.speed = _Vector2.New()
end 

function _Move:Enter()
    _Base.Enter(self)
end

function _Move:Update(dt, timeScale)
    timeScale = timeScale or 1.0
    local up = self._input:IsHold("UP")
	local down = self._input:IsHold("DOWN")
	local left = self._input:IsHold("LEFT")
    local right = self._input:IsHold("RIGHT")
    
    self._render.timeScale = self._entity.stats.moveRate * timeScale
    local moveSpeed = self._entity.stats.moveSpeed * timeScale
    self.speed:Set(moveSpeed, moveSpeed * 0.56)
    local axisX, axisY = 0, 0

    if up or down then
        if up and down then
            if self.time_up > self.time_down then
                axisY = -1
            else
                axisY = 1
            end 
        elseif up then
            axisY = -1
        else 
            axisY = 1
        end 
    end 
    
    if left or right then
        if left and right then
            if self.time_left > self.time_right then
                axisX = -1
            else 
                axisX = 1
            end 
        elseif left then
            axisX = -1
        else 
            axisX = 1
        end
    end

    if axisX ~= 0 and self._entity.transform.direction ~= axisX then
        self._entity.transform.direction = axisX
    end
    self._movement:X_Move(axisX * self.speed.x)
    self._movement:Y_Move(axisY * self.speed.y)

    if self._input:IsPressed("UP") then
        self.time_up = love.timer.getTime()
    end 
    
    if self._input:IsPressed("DOWN") then
        self.time_down = love.timer.getTime()
    end 
    
    if self._input:IsPressed("LEFT") then
        self.time_left = love.timer.getTime()
    end 
   
    if self._input:IsPressed("RIGHT") then
        self.time_right = love.timer.getTime()
    end 

    if not up and not down and not left and not right then 
        self._STATE:SetState(self._nextState)
    end 
    
end 

function _Move:Exit()
    self._render.timeScale = 1.0
end

function _Move:GetTrans()
	return self._trans
end

return _Move 
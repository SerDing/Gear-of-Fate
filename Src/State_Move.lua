--[[
	Desc: move state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of move state in this class
]]

local _State_Move = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

local _time_up = 0
local _time_down = 0
local _time_left = 0
local _time_right = 0

function _State_Move:Ctor()
   
end 

function _State_Move:Enter(hero_)
    self.name = "move"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)
    _time_left = 0
    _time_right = 0
end

function _State_Move:Update(hero_,FSM_)
	local up = _KEYBOARD.Hold("up")
	local down = _KEYBOARD.Hold("down")
	local left = _KEYBOARD.Hold("left")
	local right = _KEYBOARD.Hold("right")
	
    local _left_Release = false
    local _right_Release = false
    local _leftRlsTime = 0
    local _rightRlsTime = 0

    if up or down then
        if up and down then
            if _time_up > _time_down then
                hero_.pos.y = hero_.pos.y - hero_.spd.y
            else 
                hero_.pos.y = hero_.pos.y + hero_.spd.y
            end 
        elseif up then
            hero_.pos.y = hero_.pos.y - hero_.spd.y
        else 
            hero_.pos.y = hero_.pos.y + hero_.spd.y
        end 
    end 
    
    if left or right then
        if left and right then
            if _time_left > _time_right then
                hero_.pos.x = hero_.pos.x - hero_.spd.x
                hero_:SetDir(-1)
            elseif _time_left == _time_right then
                hero_.pos.x = hero_.pos.x + hero_.spd.x * hero_:GetDir()
            else 
                hero_.pos.x = hero_.pos.x + hero_.spd.x
                hero_:SetDir(1)
                print(_time_left - _time_right)
            end 
        elseif left then
            hero_.pos.x = hero_.pos.x - hero_.spd.x
			hero_:SetDir(-1)
        else 
            hero_.pos.x = hero_.pos.x + hero_.spd.x
            hero_:SetDir(1)
        end
    end


    if _KEYBOARD.Press("up") then
        _time_up = love.timer.getTime()
    end 
    
    if _KEYBOARD.Press("down") then
        _time_down = love.timer.getTime()
    end 
    
    if _KEYBOARD.Press("left") then
        _time_left = love.timer.getTime()
    end 
   
    if _KEYBOARD.Press("right") then
        _time_right = love.timer.getTime()
    end 
    
    
    if not up and not down and not left and not right then 
        FSM_:SetState(FSM_.oriState,hero_)
    end 
end 

function _State_Move:Exit(hero_)
    
    
    
end

return _State_Move 
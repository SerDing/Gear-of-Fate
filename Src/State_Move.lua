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
    --body
end 

function _State_Move:Enter(hero_)
    self.name = "move"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)

end

function _State_Move:Update(hero_,FSM_)
    

    if _KEYBOARD.Hold("up") or _KEYBOARD.Hold("down") then
        if _KEYBOARD.Hold("up") and _KEYBOARD.Hold("down") then
            if _time_up > _time_down then
                hero_.pos.y = hero_.pos.y - hero_.spd.y
            else 
                hero_.pos.y = hero_.pos.y + hero_.spd.y
            end 
        elseif _KEYBOARD.Hold("up") then
            hero_.pos.y = hero_.pos.y - hero_.spd.y
        else 
            hero_.pos.y = hero_.pos.y + hero_.spd.y
        end 
    
    end 
    
    if _KEYBOARD.Hold("left") or _KEYBOARD.Hold("right") then
        if _KEYBOARD.Hold("left") and _KEYBOARD.Hold("right") then
            if _time_left > _time_right then
                hero_.pos.x = hero_.pos.x - hero_.spd.x
                hero_:SetDir(-1)
            else 
                hero_.pos.x = hero_.pos.x + hero_.spd.x
                hero_:SetDir(1)
            end 
        elseif _KEYBOARD.Hold("left") then
            hero_.pos.x = hero_.pos.x - hero_.spd.x
             hero_:SetDir(-1)
        else 
            hero_.pos.x = hero_.pos.x + hero_.spd.x
            hero_:SetDir(1)
        end 
    
    end 


    if _KEYBOARD.Release("up") then
        _time_up = love.timer.getTime()
        print("_time_up " .. tostring(_time_up))
    end 
    
    if _KEYBOARD.Release("down") then
        _time_down = love.timer.getTime()
        print("_time_down " .. tostring(_time_down))
    end 
    
    if _KEYBOARD.Release("left") then
        _time_left = love.timer.getTime()
        print("_time_left " .. tostring(_time_left))
    end 
   
    if _KEYBOARD.Release("right") then
        _time_right = love.timer.getTime()
        print("_time_right " .. tostring(_time_right))
    end 



    -- if(_time_up > _time_down)then
    --     hero_.pos.y = hero_.pos.y - hero_.spd.y
    -- elseif(_time_up < _time_down)then
    --     hero_.pos.y = hero_.pos.y + hero_.spd.y
    -- end 

    -- if(_time_left > _time_right)then
    --     hero_.pos.x = hero_.pos.x - hero_.spd.x
    --     hero_:SetDir(-1)
    -- elseif(_time_left < _time_right)then
    --     hero_.pos.x = hero_.pos.x + hero_.spd.x
    --     hero_:SetDir(1)
    -- end
    
    if(love.keyboard.isDown("up") == false and
    love.keyboard.isDown("down") == false and
    love.keyboard.isDown("left") == false and
    love.keyboard.isDown("right") == false
    )then 
        FSM_:SetState(FSM_.oriState,hero_)
        -- _time_up = 0
        -- _time_down = 0
        -- _time_left = 0
        -- _time_right = 0
    end 
end 

function _State_Move:Exit(hero_)
    --body
end

return _State_Move 
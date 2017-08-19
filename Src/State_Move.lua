--[[
	Desc: move state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of move state in this class
]]

local _State_Move = require("Src.Class")()

function _State_Move:Ctor()
    --body
end 

function _State_Move:Enter(hero_)
    self.name = "move"
	hero_.pakGrp.body:SetAnimation(self.name)
	hero_.pakGrp.weapon:SetAnimation(self.name)

end

function _State_Move:Update(hero_,FSM_)
    
    local time_up = 0
    local time_down = 0
    local time_left = 0
    local time_right = 0

    local dt = love.timer.getDelta()

    if love.keyboard.isDown("up") then
        time_up = time_up + dt
    end 
    
    if love.keyboard.isDown("down") then
        time_down = time_down + dt
    end 
    
    if love.keyboard.isDown("left") then
        time_left = time_left + dt
    end 
   
    if love.keyboard.isDown("right") then
        time_right = time_right + dt
    end 

    




	if(time_up > time_down)then
        hero_.pos.y = hero_.pos.y - hero_.spd.y
    elseif(time_up < time_down)then
        hero_.pos.y = hero_.pos.y + hero_.spd.y
    end 

    if(time_left > time_right)then
        hero_.pos.x = hero_.pos.x - hero_.spd.x
        hero_:SetDir(-1)
    elseif(time_left < time_right)then
        hero_.pos.x = hero_.pos.x + hero_.spd.x
        hero_:SetDir(1)
    end
    
    if(love.keyboard.isDown("up") == false and
    love.keyboard.isDown("down") == false and
    love.keyboard.isDown("left") == false and
    love.keyboard.isDown("right") == false
    )then 
        FSM_:SetState(FSM_.oriState,hero_)
        -- time_up = 0
        -- time_down = 0
        -- time_left = 0
        -- time_right = 0
    end 
end 

function _State_Move:Exit(hero_)
    --body
end

return _State_Move 
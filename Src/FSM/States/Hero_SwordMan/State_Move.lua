--[[
	Desc: move state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of move state in this class
]]

local _State_Move = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_Move:Ctor()
    self.time_up = 0
    self.time_down = 0
    self.time_left = 0
    self.time_right = 0
    self.trans = {
		{"NORMAL", "JUMP", "jump"}, 
		{"NORMAL", "ATTACK", "attack"}, 
		{"NORMAL", "UNIQUE", "upperslash"}, 
		{"NORMAL", "BACK", "jump", true}, 
		{"SKILL", "GoreCross", "gorecross"}, 
		{"SKILL", "HopSmash", "hopsmash"}, 
		{"SKILL", "MoonLightSlash", "moonslash"}, 
		{"SKILL", "TripleSlash", "tripleslash"}, 
    }
    self.KEYID = {}
end 

function _State_Move:Enter(hero_)
    self.name = "move"
	hero_:SetAnimation(self.name)
	self.time_up = 0
    self.time_down = 0
    self.time_left = 0
    self.time_right = 0

    
end

function _State_Move:Update(hero_,FSM_)
	local up = _KEYBOARD.Hold("up")
	local down = _KEYBOARD.Hold("down")
	local left = _KEYBOARD.Hold("left")
	local right = _KEYBOARD.Hold("right")
	
    if up or down then
        if up and down then
            if self.time_up > self.time_down then
                hero_:Y_Move(-hero_.spd.y )
            else 
                hero_:Y_Move(hero_.spd.y )
            end 
        elseif up then
            hero_:Y_Move(-hero_.spd.y )
        else 
            hero_:Y_Move(hero_.spd.y )
        end 
    end 
    
    if left or right then
        if left and right then
            if self.time_left > self.time_right then
                hero_:X_Move(- hero_.spd.x)
                hero_:SetDir(-1)
            elseif self.time_left == self.time_right then
                hero_:X_Move(hero_.spd.x * hero_:GetDir())
            else 
                hero_:X_Move(hero_.spd.x)
                hero_:SetDir(1)
            end 
        elseif left then
            hero_:X_Move(- hero_.spd.x)
			hero_:SetDir(-1)
        else 
            hero_:X_Move(hero_.spd.x)
            hero_:SetDir(1)
        end
    end


    if _KEYBOARD.Press("up") then
        self.time_up = love.timer.getTime()
    end 
    
    if _KEYBOARD.Press("down") then
        self.time_down = love.timer.getTime()
    end 
    
    if _KEYBOARD.Press("left") then
        self.time_left = love.timer.getTime()
    end 
   
    if _KEYBOARD.Press("right") then
        self.time_right = love.timer.getTime()
    end 
    
    
    if not up and not down and not left and not right then 
        FSM_:SetState(FSM_.oriState,hero_)
    end 

end 

function _State_Move:Exit(hero_)
end

function _State_Move:GetTrans()
	return self.trans
end

return _State_Move 
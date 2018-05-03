--[[
	Desc: dash state (run)
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of dash state in this class
]]

local _State_Dash = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard"

function _State_Dash:Ctor()
    self.KEYID = {}
    self.trans = {
		{"NORMAL", "JUMP", "jump"}, 
		{"NORMAL", "ATTACK", "dashattack"}, 
		{"NORMAL", "UNIQUE", "upperslash"}, 
		{"NORMAL", "BACK", "jump", true}, 
		{"SKILL", "GoreCross", "gorecross"}, 
		{"SKILL", "HopSmash", "hopsmash"}, 
		{"SKILL", "MoonLightSlash", "moonslash"}, 
		{"SKILL", "TripleSlash", "tripleslash"}, 
    }
end 

function _State_Dash:Enter(hero_)
    self.name = "dash"
	hero_:SetAnimation(self.name)
end

function _State_Dash:Update(hero_,FSM_)
	
    local up = _KEYBOARD.Hold("up")
	local down = _KEYBOARD.Hold("down")
	local left = _KEYBOARD.Hold("left")
	local right = _KEYBOARD.Hold("right")
	
    if up then
        hero_:Y_Move(- hero_.spd.y * 1.5 )
    elseif down then
        hero_:Y_Move( hero_.spd.y * 1.5 )
    end 
           
    if left then
        hero_:X_Move(- hero_.spd.x * 2)
        hero_:SetDir(-1)
    elseif right then
        hero_:X_Move( hero_.spd.x * 2)
        hero_:SetDir(1)
    end 

    if _KEYBOARD.Press("left") then
        if _KEYBOARD.Hold("right") then
            FSM_:SetState("move",hero_)
            hero_:SetDir(-1)
        end 
    end 
   
    if _KEYBOARD.Press("right") then
        if _KEYBOARD.Hold("left") then
            FSM_:SetState("move",hero_)
            hero_:SetDir(1)
        end 
    end 
    
    if not up and not down and not left and not right then 
        FSM_:SetState(FSM_.oriState,hero_)
    end 
    
end 

function _State_Dash:Exit(hero_)
end

function _State_Dash:GetTrans()
	return self.trans
end

return _State_Dash 
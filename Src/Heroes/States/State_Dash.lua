--[[
	Desc: dash state (run)
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of dash state in this class
]]

local _State_Dash = require("Src.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard"



function _State_Dash:Ctor()
    self.KEYID = {}
end 

function _State_Dash:Enter(hero_)
    self.name = "dash"
	hero_:GetBody():SetAnimation(self.name)
	hero_:GetWeapon():SetAnimation(self.name)
    
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

    if _KEYBOARD.Press(hero_.KEY["JUMP"]) then
		FSM_:SetState("jump",hero_)
	end 

    if _KEYBOARD.Press(hero_.KEY["ATTACK"]) then
		FSM_:SetState("dashattack",hero_)
    end 
    
    if _KEYBOARD.Press(hero_.KEY["UNIQUE"]) then
		FSM_:SetState("upperslash",hero_)
	end

    if _KEYBOARD.Press(hero_.KEY["BACK"]) then
		FSM_:SetState("jump",hero_,true)
	end

    self.KEYID["GoreCross"] = hero_:GetSkillKeyID("GoreCross")
    
    if _KEYBOARD.Press(hero_.KEY[self.KEYID["GoreCross"]]) then
        FSM_:SetState("gorecross",hero_)
    end 

end 

function _State_Dash:Exit(hero_)
    --body
end

return _State_Dash 
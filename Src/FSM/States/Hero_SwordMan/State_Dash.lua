--[[
	Desc: dash state (run)
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of dash state in this class
]]

local _State_Dash = require("Src.Core.Class")()

function _State_Dash:Ctor()
    self.KEYID = {}
    self.trans = {
		{"NORMAL", "JUMP", "jump"}, 
		{"NORMAL", "ATTACK", "dashattack"}, 
		{"SKILL", "UpperSlash", "upperslash"},  
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
    self.input = hero_:GetInput()
    self.movement = hero_:GetComponent('Movement')
end

function _State_Dash:Update(hero_,FSM_)
	
    local up = self.input:IsHold("up")
	local down = self.input:IsHold("down")
	local left = self.input:IsHold("left")
	local right = self.input:IsHold("right")
	
    if up then
        self.movement:Y_Move(- hero_.spd.y * 1.5 )
    elseif down then
        self.movement:Y_Move( hero_.spd.y * 1.5 )
    end 
           
    if left then
        self.movement:X_Move(- hero_.spd.x * 2)
        hero_:SetDir(-1)
    elseif right then
        self.movement:X_Move( hero_.spd.x * 2)
        hero_:SetDir(1)
    end 

    if self.input:IsPressed("left") then
        if self.input:IsHold("right") then
            FSM_:SetState("move",hero_)
            hero_:SetDir(-1)
        end 
    end 
   
    if self.input:IsPressed("right") then
        if self.input:IsHold("left") then
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
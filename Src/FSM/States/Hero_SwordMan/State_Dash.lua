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
        {"NORMAL", "ATTACK", "dashattack"},
        {"NORMAL", "JUMP", "jump"},
        {"NORMAL", "BACK", "jump", true},
        {"SKILL", 46, "upperslash"},
		{"SKILL", 64, "gorecross"},
		{"SKILL", 65, "hopsmash"},
		{"SKILL", 77, "moonslash"},
		{"SKILL", 8, "tripleslash"},
    }
end 

function _State_Dash:Enter(hero_)
    self.name = "dash"
    hero_:SetAnimation(self.name)
    self.input = hero_:GetComponent("Input")
    self.movement = hero_:GetComponent('Movement')
    self.animator = hero_:GetBody()
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
    
    local realSpdX = hero_.spd.x * 2

    -- if self.animator:GetCount() == 2 or 
    -- self.animator:GetCount() == 3 or 
    -- -- self.animator:GetCount() == 4 or 
    -- -- self.animator:GetCount() == 0 or
    -- self.animator:GetCount() == 6 or 
    -- self.animator:GetCount() == 7 then
    --     realSpdX = hero_.spd.x * 1.5 
    -- end

    if left then
        self.movement:X_Move(- realSpdX)
        hero_:SetDir(-1)
    elseif right then
        self.movement:X_Move( realSpdX)
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
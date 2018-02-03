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

----[[  Normal state switching  ]]

    self:StateSwitch("JUMP","jump",hero_,FSM_)

    self:StateSwitch("ATTACK","dashattack",hero_,FSM_)

    self:StateSwitch("UNIQUE","upperslash",hero_,FSM_)

    self:StateSwitch("BACK","jump",hero_,FSM_,true)
    
----[[  Skill state switching  ]]

	self:AtkStateSwitch("GoreCross","gorecross",hero_,FSM_)

    self:AtkStateSwitch("HopSmash","hopsmash",hero_,FSM_)

    self:AtkStateSwitch("MoonLightSlash","moonslash",hero_,FSM_)

    self:AtkStateSwitch("TripleSlash","tripleslash",hero_,FSM_)
    
end 

function _State_Dash:Exit(hero_)
    --body
end

function _State_Dash:StateSwitch(keyID,stateName,hero_,FSM_,...)
	if _KEYBOARD.Press(hero_.KEY[keyID]) then
		FSM_:SetState(stateName,hero_,...)
	end 
end

function _State_Dash:AtkStateSwitch(skillName,stateName,hero_,FSM_)
	self.KEYID[skillName] = hero_:GetSkillKeyID(skillName)
	
	if _KEYBOARD.Press(hero_.KEY[self.KEYID[skillName]]) then
		FSM_:SetState(stateName,hero_)
	end 
end

return _State_Dash 
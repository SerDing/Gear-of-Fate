--[[
	Desc: Attack1 state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Attack1 state in this class
]]

local _State_Attack = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_Attack:Ctor()
    self.name = "attack"

    self.childName ={
        "attack1",
        "attack2",
        "attack3",

    } 
    
    self.attackNum = 0
    self.KEYID = {}
    self.atkJudger = {}
end

function _State_Attack:Enter(hero_,FSM_)
    
	hero_:SetAnimation(self.childName[1])
	self.attackNum = 1

    self.atkJudger = hero_:GetAtkJudger()
    self.atkJudger:ClearDamageArr()
    self.attackName = self.childName[self.attackNum]

    if hero_:GetAttackMode() == "frenzy" then
        FSM_:SetState("frenzyattack",hero_)
        return  
    end

end

function _State_Attack:Update(hero_,FSM_)
    local _body = hero_:GetBody()
    local _dt = love.timer.getDelta()
    
    local _leftHold = _KEYBOARD.Hold(hero_.KEY["LEFT"])
    local _rightHold = _KEYBOARD.Hold(hero_.KEY["RIGHT"])

    if self.attackNum == 1 then
        
        

        if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 2
            self.atkJudger:ClearDamageArr()
            self.attackName = self.childName[self.attackNum]
            hero_:SetAnimation(self.childName[self.attackNum])
        end 


    elseif self.attackNum == 2 then
        
        if hero_:GetAttackBox() then
            self.atkJudger:Judge(hero_, "MONSTER")
        end

        if _body:GetCount() <= 2 then
            hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )
        end 

        if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
        (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
            
            hero_:X_Move(hero_.spd.x * 30 * _dt * hero_.dir )
        end 

        if _KEYBOARD.Press(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            self.atkJudger:ClearDamageArr()
            self.attackName = self.childName[self.attackNum]
            hero_:SetAnimation(self.childName[self.attackNum])
        end 

    elseif self.attackNum == 3 then
        if hero_:GetAttackBox() then
            self.atkJudger:Judge(hero_, "MONSTER")
        end
        
        if _body:GetCount() < 4 then
            
            hero_:X_Move(hero_.spd.x * 30 * _dt * hero_.dir )

            if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
            (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
                
                hero_:X_Move(hero_.spd.x * 20 * _dt * hero_.dir )
            end 
        end 

    end 

    -- attack judgement
    if hero_:GetAttackBox() then
        self.atkJudger:Judge(hero_, "MONSTER", self.attackName)
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

    self.KEYID["HopSmash"] = hero_:GetSkillKeyID("HopSmash")
	
	if _KEYBOARD.Press(hero_.KEY[self.KEYID["HopSmash"]]) then
		FSM_:SetState("hopsmash",hero_)
	end 

end 

function _State_Attack:Exit(hero_)
    --body
end

return _State_Attack 
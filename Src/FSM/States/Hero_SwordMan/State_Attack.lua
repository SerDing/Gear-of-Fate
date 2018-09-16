--[[
	Desc: Attack1 state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Attack1 state in this class
]]

local _State_Attack = require("Src.Core.Class")()

function _State_Attack:Ctor()
    self.name = "attack"

    self.childName = {"attack1", "attack2", "attack3"}
    self.trans = {
		{"NORMAL", "UNIQUE", "upperslash"}, 
		{"NORMAL", "BACK", "jump", true}, 
		{"SKILL", "GoreCross", "gorecross"}, 
		{"SKILL", "HopSmash", "hopsmash"}, 
		{"SKILL", "MoonLightSlash", "moonslash"}, 
		{"SKILL", "TripleSlash", "tripleslash"}, 
	}
    
    self.attackNum = 0
    self.KEYID = {}
    self.atkJudger = {}
    self.input = {}
end

function _State_Attack:Enter(hero_,FSM_)
    self.attackNum = 1
    self.attackName = self.childName[self.attackNum]
    self.atkJudger = hero_:GetAtkJudger()
    self.atkJudger:ClearDamageArr()
    self.input = hero_:GetInput()
    self.movement = hero_:GetComponent('Movement')

    hero_:SetAnimation(self.attackName)

    if hero_:GetAttackMode() == "frenzy" then
        FSM_:SetState("frenzyattack",hero_)
        return  
    end
end

function _State_Attack:Update(hero_,FSM_)
    local _body = hero_:GetBody()
    local _dt = love.timer.getDelta()
    
    local _leftHold = self.input:IsHold(hero_.KEY["LEFT"])
    local _rightHold = self.input:IsHold(hero_.KEY["RIGHT"])
    local _movable = true

    if (self.input:IsHold(hero_.KEY["LEFT"]) and hero_.dir == 1) or
    (self.input:IsHold(hero_.KEY["RIGHT"]) and hero_.dir == -1) then
        _movable = false
    end

    if self.attackNum == 1 then
        if self.input:IsPressed(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 2
            self.attackName = self.childName[self.attackNum]
            self.atkJudger:ClearDamageArr()
            hero_:SetAnimation(self.childName[self.attackNum])
        end
    elseif self.attackNum == 2 then
        if self.input:IsPressed(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            self.attackName = self.childName[self.attackNum]
            self.atkJudger:ClearDamageArr()
            hero_:SetAnimation(self.childName[self.attackNum])
        end 
    end 
    if self.attackNum == 2 or self.attackNum == 3 then
        if _movable then
            if _body:GetCount() <= self.attackNum then
                self.movement:X_Move(hero_.spd.x * 0.75 * hero_.dir )
            end 
            
            if (self.input:IsHold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
            (self.input:IsHold(hero_.KEY["RIGHT"]) and hero_.dir == 1 ) then
                
                self.movement:X_Move(hero_.spd.x * 0.75 * hero_.dir )
            end 
        end
    end
    
    -- attack judgement
    if hero_:GetAttackBox() then
        self.atkJudger:Judge(hero_, "MONSTER", self.attackName)
    end

    -- memory release
    _body = nil
    _dt = nil
    
    _leftHold = nil
    _rightHold = nil
    _movable = nil
    
end 

function _State_Attack:Exit(hero_)
    --body
end

function _State_Attack:GetTrans()
	return self.trans
end

return _State_Attack 



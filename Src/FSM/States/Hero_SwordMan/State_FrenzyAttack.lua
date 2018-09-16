--[[
	Desc: Attack1 state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of frenzy attack state in this class
]]
-- Remember to change self.input:IsHold() to Press() 

local _State_AtkBase  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_FrenzyAttack = require("Src.Core.Class")(_State_AtkBase)

function _State_FrenzyAttack:Ctor()
    self.name = "frenzyattack"
    self.childName ={"frenzy1", "frenzy2", "frenzy3", "frenzy4"}
    self.trans = {
		{"NORMAL", "UNIQUE", "upperslash"}, 
		{"NORMAL", "BACK", "jump", true}, 
		{"SKILL", "GoreCross", "gorecross"}, 
		{"SKILL", "HopSmash", "hopsmash"}, 
	}
    
    self.attackNum = 0
    self.KEYID = {}
    self.spdRate = 0.55
    self:_Init()
end 

function _State_FrenzyAttack:Enter(hero_)
    
	hero_:SetAnimation(self.childName[1])
	self.attackNum = 1
    
    self.atkJudger = hero_:GetAtkJudger()
    self.atkJudger:ClearDamageArr()
    self.movement = hero_:GetComponent('Movement')

    ----[[  Call base class function  ]]
    self:_Enter(hero_)
    self:Effect("frenzy/sword1-1.lua", 0, 1)
    self:Effect("frenzy/sword1-3.lua", 0, 1)
    self:Effect("frenzy/sword1-4.lua", 0, 1)
    
end

function _State_FrenzyAttack:Update(hero_,FSM_)
    local _body = hero_:GetBody()
    local _dt = love.timer.getDelta()
    
    local _leftHold = self.input:IsHold(hero_.KEY["LEFT"])
    local _rightHold = self.input:IsHold(hero_.KEY["RIGHT"])
    local _movable = true

    if (_leftHold and hero_.dir == 1) or
    (_rightHold and hero_.dir == -1) then
        _movable = false
    end

    if self.attackNum == 1 then
        
        if self.input:IsHold(hero_.KEY["ATTACK"]) and _body:GetCount() > 4 then
            self.attackNum = 2
            self.atkJudger:ClearDamageArr()
            hero_:SetAnimation(self.childName[self.attackNum])
            
           
            for n=1,#self.effect do
                self.effect[n].over = true
            end 

            for n=1,#self.effect do
                table.remove(self.effect,n)
            end 

            self:Effect("frenzy/sword2-1.lua", 1, 1)
            self:Effect("frenzy/sword2-3.lua", 1, 1)
            self:Effect("frenzy/sword2-4.lua", 1, 1)
           
        end 
        
    elseif self.attackNum == 2 then
        
        if _movable then
            if _body:GetCount() <= 2 then
                self.movement:X_Move(hero_.spd.x * hero_.dir )
            end 
    
            if (_leftHold and hero_.dir == -1 ) or 
            (_rightHold and hero_.dir == 1 )   then  
                self.movement:X_Move(hero_.spd.x * self.spdRate * hero_.dir )
            end 
        end

        if self.input:IsHold(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            self.atkJudger:ClearDamageArr()
            hero_:SetAnimation(self.childName[self.attackNum])
            
            
            for n=1,#self.effect do
                self.effect[n].over = true
            end 
           
            for n=1,#self.effect do
                table.remove(self.effect,n)
            end 

            self:Effect("frenzy/sword3-1.lua", 1, 1)
            self:Effect("frenzy/sword3-2.lua", 1, 1)
            self:Effect("frenzy/sword3-3.lua", 1, 1)

        end 
        
    elseif self.attackNum == 3 then

        if _movable then
            if _body:GetCount() < 4 then
                self.movement:X_Move(hero_.spd.x * hero_.dir )
            end 
            
            if (_leftHold and hero_.dir == -1 ) or 
            (_rightHold and hero_.dir == 1 )   then
                
                self.movement:X_Move(hero_.spd.x * self.spdRate  * hero_.dir )
            end
        end

        if self.input:IsHold(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 4
            self.atkJudger:ClearDamageArr()
            hero_:SetAnimation(self.childName[self.attackNum])
            
            
            for n=1,#self.effect do
                self.effect[n].over = true
            end 
            
            for n=1,#self.effect do
                table.remove(self.effect,n)
            end 

            self:Effect("frenzy/sword4-1.lua", 1, 1)
            self:Effect("frenzy/sword4-2.lua", 1, 1)
            self:Effect("frenzy/sword4-3.lua", 1, 1)        

        end 

    elseif self.attackNum == 4 then
        if _body:GetCount() < 3 then
            if _movable then
                self.movement:X_Move(hero_.spd.x * hero_.dir )
                
                if (_leftHold and hero_.dir == -1 ) or 
                (_rightHold and hero_.dir == 1 )   then
                    
                    self.movement:X_Move(hero_.spd.x * self.spdRate  * hero_.dir )
                end
            end
        end 
    end 
   
    if hero_:GetAttackBox() then
        self.atkJudger:Judge(hero_, "MONSTER", self.childName[self.attackNum])
    end

    for n=1,#self.effect do
        if self.effect[n] then
            self.effect[n].pos.x = hero_.pos.x
        end 
    end 
    
end 

function _State_FrenzyAttack:Exit(hero_)
    
    for n=1,#self.effect do
        self.effect[n].over = true
    end 
    self:_Exit()
end

function _State_FrenzyAttack:GetTrans()
	return self.trans
end

return _State_FrenzyAttack 
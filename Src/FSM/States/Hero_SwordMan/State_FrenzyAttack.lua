--[[
	Desc: Attack1 state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of frenzy attack state in this class
]]
-- Remember to change _KEYBOARD.Hold() to Press() 

local _State_AtkBase  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_FrenzyAttack = require("Src.Core.Class")(_State_AtkBase)

local _KEYBOARD = require "Src.Core.KeyBoard" 

function _State_FrenzyAttack:Ctor()
    self.name = "frenzyattack"

    self.childName ={
        "frenzy1",
        "frenzy2",
        "frenzy3",
        "frenzy4",
    }
    
    self.attackNum = 0
    self.KEYID = {}

    self:AtkBase_Init()

end 

function _State_FrenzyAttack:Enter(hero_)
    
	hero_:GetBody():SetAnimation(self.childName[1])
	hero_:GetWeapon():SetAnimation(self.childName[1])
	self.attackNum = 1
    
    self.atkJudger = hero_:GetAtkJudger()
    self.atkJudger:ClearDamageArr()

----[[  Call base class function  ]]
    self:AtkBase_Enter(hero_)
    self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword1-1.lua",0,1,hero_)
    self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword1-3.lua",0,1,hero_)
    self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword1-4.lua",0,1,hero_)
    
end

function _State_FrenzyAttack:Update(hero_,FSM_)
    local _body = hero_:GetBody()
    local _dt = love.timer.getDelta()
    
    local _leftHold = _KEYBOARD.Hold(hero_.KEY["LEFT"])
    local _rightHold = _KEYBOARD.Hold(hero_.KEY["RIGHT"])
    local _movable = true

    -- local _keyCheck = _KEYBOARD.Press
    local _keyCheck = _KEYBOARD.Hold

    if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == 1) or
    (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == -1) then
        _movable = false
    end

    if self.attackNum == 1 then
        
        if _keyCheck(hero_.KEY["ATTACK"]) and _body:GetCount() > 4 then
            self.attackNum = 2
            self.atkJudger:ClearDamageArr()
            hero_:GetBody():SetAnimation(self.childName[self.attackNum])
            hero_:GetWeapon():SetAnimation(self.childName[self.attackNum])
           
            for n=1,#self.effect do
                self.effect[n].over = true
            end 

            for n=1,#self.effect do
                table.remove(self.effect,n)
            end 

            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword2-1.lua",1,1,hero_)
            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword2-3.lua",1,1,hero_)
            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword2-4.lua",1,1,hero_)
           
        end 
        
    elseif self.attackNum == 2 then
        
        if _movable then
            if _body:GetCount() <= 2 then
                hero_:X_Move(hero_.spd.x * 30 * _dt * hero_.dir )
            end 
    
            if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
            (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then  
                hero_:X_Move(hero_.spd.x * 50 * _dt * hero_.dir )
            end 
        end

       

        if _keyCheck(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            self.atkJudger:ClearDamageArr()
            hero_:GetBody():SetAnimation(self.childName[self.attackNum])
            hero_:GetWeapon():SetAnimation(self.childName[self.attackNum])
            
            for n=1,#self.effect do
                self.effect[n].over = true
            end 
           
            for n=1,#self.effect do
                table.remove(self.effect,n)
            end 

            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword3-1.lua",-1,1,hero_)
            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword3-2.lua",1,1,hero_)
            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword3-3.lua",0,1,hero_)

        end 
        
    elseif self.attackNum == 3 then

        if _movable then
            if _body:GetCount() < 4 then
                hero_:X_Move(hero_.spd.x * 30 * _dt * hero_.dir )
            end 
            
            if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
            (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
                
                hero_:X_Move(hero_.spd.x * 50 * _dt * hero_.dir )
                
            end
        end

        if _keyCheck(hero_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 4
            self.atkJudger:ClearDamageArr()
            hero_:GetBody():SetAnimation(self.childName[self.attackNum])
            hero_:GetWeapon():SetAnimation(self.childName[self.attackNum])
            
            for n=1,#self.effect do
                self.effect[n].over = true
            end 
            
            for n=1,#self.effect do
                table.remove(self.effect,n)
            end 

            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword4-1.lua",0,1,hero_)
            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword4-2.lua",0,1,hero_)
            self:Effect(self.EffectMgr.pathHead["SwordMan"] .. "frenzy/sword4-3.lua",0,1,hero_)        

        end 

    elseif self.attackNum == 4 then
        if _body:GetCount() < 3 then
            if _movable then
                hero_:X_Move(hero_.spd.x * 30 * _dt * hero_.dir )
                
                if (_KEYBOARD.Hold(hero_.KEY["LEFT"]) and hero_.dir == -1 ) or 
                (_KEYBOARD.Hold(hero_.KEY["RIGHT"]) and hero_.dir == 1 )   then
                    
                    hero_:X_Move(hero_.spd.x * 50 * _dt * hero_.dir )
                end
            end
        end 
    end 
   
    if hero_:GetAttackBox() then
        self.atkJudger:Judge(hero_, "MONSTER")
    end

    for n=1,#self.effect do
        if self.effect[n] then
            self.effect[n].pos.x = hero_.pos.x
        end 
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

function _State_FrenzyAttack:Exit(hero_)
    
    for n=1,#self.effect do
        self.effect[n].over = true
    end 
    self:AtkBase_Exit()
end

return _State_FrenzyAttack 
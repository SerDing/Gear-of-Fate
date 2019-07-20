--[[
	Desc: FrenzyAttack state 
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of frenzy attack state in this class
]]
-- Remember to change self.input:IsHold() to Press() 

local base  = require "Src.FSM.States.Hero_SwordMan.State_AtkBase"
local _State_FrenzyAttack = require("Src.Core.Class")(base)

function _State_FrenzyAttack:Ctor(...)
    base.Ctor(self, ...)
    self.name = "frenzyattack"
    self.childName ={"frenzy1", "frenzy2", "frenzy3", "frenzy4"}
    self.trans = {
        {"NORMAL", "BACK", "jump", true}, 
        {"SKILL", 46, "upperslash"}, 
		{"SKILL", 64, "gorecross"}, 
		{"SKILL", 65, "hopsmash"}, 
	}
    
    self.attackNum = 0
    self.hitTimes = 0
    self.KEYID = {}
    self.spdRate = 0.55
end 

function _State_FrenzyAttack:Enter()
    
	self.hero:Play(self.childName[1])
	self.attackNum = 1
    
    self.atkJudger = self.hero:GetAtkJudger()
    self.atkJudger:ClearDamageArr()
    self.hitTimes = 0
    self.movement = self.hero:GetComponent('Movement')

    ----[[  Call base class function  ]]
    base.Enter(self)
    self:Effect("frenzy/sword1-1.lua")
    self:Effect("frenzy/sword1-3.lua")
    self:Effect("frenzy/sword1-4.lua")

    local function attack_event(frame)
        if not self.hero:GetAttackBox() or self.hitTimes >= 2 then
            return
        end
        self.atkJudger:ClearDamageArr()
        if self.atkJudger:Judge(self.hero, "MONSTER", self.childName[self.attackNum]) then
            self.hitTimes = self.hitTimes + 1
        end
    end

    self.hero.animMap:GetWidget("weapon_c1").OnChangeFrame = attack_event
    self.hero.animMap:GetWidget("weapon_b1").OnChangeFrame = attack_event

end

function _State_FrenzyAttack:Update()
    local _body = self.hero:GetBody()
    local _dt = love.timer.getDelta()
    
    local _leftHold = self.input:IsHold(self.FSM.HotKeyMgr_.KEY["LEFT"])
    local _rightHold = self.input:IsHold(self.FSM.HotKeyMgr_.KEY["RIGHT"])
    local _movable = true

    if (_leftHold and self.hero.dir == 1) or
    (_rightHold and self.hero.dir == -1) then
        _movable = false
    end

    if self.attackNum == 1 then
        
        if self.input:IsHold(self.FSM.HotKeyMgr_.KEY["ATTACK"]) and _body:GetCount() > 4 then
            self.attackNum = 2
            -- self.atkJudger:ClearDamageArr()
            self.hitTimes = 0
            self.hero:Play(self.childName[self.attackNum])

            self:ClearEffects()

            self:Effect("frenzy/sword2-1.lua")
            self:Effect("frenzy/sword2-3.lua")
            self:Effect("frenzy/sword2-4.lua")
           
        end 
        
    elseif self.attackNum == 2 then
        
        if _movable then
            if _body:GetCount() <= 2 then
                self.movement:X_Move(self.hero.spd.x * self.hero.dir )
            end 
    
            if (_leftHold and self.hero.dir == -1 ) or 
            (_rightHold and self.hero.dir == 1 )   then  
                self.movement:X_Move(self.hero.spd.x * self.spdRate * self.hero.dir )
            end 
        end

        if self.input:IsHold(self.FSM.HotKeyMgr_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            -- self.atkJudger:ClearDamageArr()
            self.hitTimes = 0
            self.hero:Play(self.childName[self.attackNum])
            
            self:ClearEffects()

            self:Effect("frenzy/sword3-1.lua")
            self:Effect("frenzy/sword3-2.lua")
            self:Effect("frenzy/sword3-3.lua")

        end 
        
    elseif self.attackNum == 3 then

        if _movable then
            if _body:GetCount() < 4 then
                self.movement:X_Move(self.hero.spd.x * self.hero.dir )
            end 
            
            if (_leftHold and self.hero.dir == -1 ) or 
            (_rightHold and self.hero.dir == 1 )   then
                
                self.movement:X_Move(self.hero.spd.x * self.spdRate  * self.hero.dir )
            end
        end

        if self.input:IsHold(self.FSM.HotKeyMgr_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 4

            -- self.atkJudger:ClearDamageArr()

            self.hitTimes = 0
            self.hero:Play(self.childName[self.attackNum])
            
            
            self:ClearEffects()

            self:Effect("frenzy/sword4-1.lua")
            self:Effect("frenzy/sword4-2.lua")
            self:Effect("frenzy/sword4-3.lua")

        end 

    elseif self.attackNum == 4 then
        if _body:GetCount() < 3 then
            if _movable then
                self.movement:X_Move(self.hero.spd.x * self.hero.dir )
                
                if (_leftHold and self.hero.dir == -1 ) or 
                (_rightHold and self.hero.dir == 1 )   then
                    
                    self.movement:X_Move(self.hero.spd.x * self.spdRate  * self.hero.dir )
                end
            end
        end 
    end 
   
    -- if self.hero:GetAttackBox() then
    --     local _hit = self.atkJudger:Judge(self.hero, "MONSTER", self.childName[self.attackNum])
    --     if _hit then
    --         self.hitTimes = self.hitTimes + 1
    --         if self.hitTimes < 2 then
    --             self.atkJudger:ClearDamageArr()
    --         end
    --     end
    -- end

    for n=1,#self.effect do
        if self.effect[n] then
            self.effect[n]:SetPos(self.hero.pos.x)
        end 
    end 
    
end 

function _State_FrenzyAttack:Exit()
    self.hero.animMap:GetWidget("weapon_b1").OnChangeFrame = nil
    self.hero.animMap:GetWidget("weapon_c1").OnChangeFrame = nil
    for n=1,#self.effect do
        self.effect[n].playOver = true
    end
    base.Exit(self)
end

function _State_FrenzyAttack:GetTrans()
	return self.trans
end

return _State_FrenzyAttack 
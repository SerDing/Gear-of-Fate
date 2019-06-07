--[[
	Desc: Attack state 
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* wrap the logic of Attack state in this class
]]

local _State_Attack = require("Src.Core.Class")()

function _State_Attack:Ctor(FSM, hero)
    self.FSM = FSM
    self.hero = hero
    self.name = "attack"
    self.childName = {"attack1", "attack2", "attack3"}
    self.trans = {
        {"NORMAL", "BACK", "jump", true}, 
        {"SKILL", 46, "upperslash"},
		{"SKILL", 64, "gorecross"}, 
		{"SKILL", 65, "hopsmash"}, 
		{"SKILL", 77, "moonslash"}, 
		{"SKILL", 8, "tripleslash"}, 
	}
    
    self.attackNum = 0
    self.KEYID = {}
    self.atkJudger = {}
    self.input = {}
end

function _State_Attack:Enter()
    self.attackNum = 1
    self.attackName = self.childName[self.attackNum]
    self.atkJudger = self.hero:GetAtkJudger()
    self.atkJudger:ClearDamageArr()
    self.input = self.hero:GetComponent("Input")
    self.movement = self.hero:GetComponent('Movement')

    self.hero:SetAnimation(self.attackName)

    if self.hero:GetAttackMode() == "frenzy" then
        self.FSM:SetState("frenzyattack",self.hero)
        return
    end
end

function _State_Attack:Update()
    local _body = self.hero:GetBody()
    local _dt = love.timer.getDelta()
    
    local _leftHold = self.input:IsHold(self.FSM.HotKeyMgr_.KEY["LEFT"])
    local _rightHold = self.input:IsHold(self.FSM.HotKeyMgr_.KEY["RIGHT"])
    local _movable = true

    if (self.input:IsHold(self.FSM.HotKeyMgr_.KEY["LEFT"]) and self.hero.dir == 1) or
    (self.input:IsHold(self.FSM.HotKeyMgr_.KEY["RIGHT"]) and self.hero.dir == -1) then
        _movable = false
    end

    if self.attackNum == 1 then
        if self.input:IsPressed(self.FSM.HotKeyMgr_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 2
            self.attackName = self.childName[self.attackNum]
            self.atkJudger:ClearDamageArr()
            self.hero:SetAnimation(self.childName[self.attackNum])
        end
    elseif self.attackNum == 2 then
        if self.input:IsPressed(self.FSM.HotKeyMgr_.KEY["ATTACK"]) and _body:GetCount() > 3 then
            self.attackNum = 3
            self.attackName = self.childName[self.attackNum]
            self.atkJudger:ClearDamageArr()
            self.hero:SetAnimation(self.childName[self.attackNum])
        end
    end
    if self.attackNum == 2 or self.attackNum == 3 then
        if _movable then
            if _body:GetCount() <= self.attackNum then
                self.movement:X_Move(self.hero.spd.x * 0.75 * self.hero.dir )
            end
            if (self.input:IsHold(self.FSM.HotKeyMgr_.KEY["LEFT"]) and self.hero.dir == -1 ) or 
            (self.input:IsHold(self.FSM.HotKeyMgr_.KEY["RIGHT"]) and self.hero.dir == 1 ) then
                self.movement:X_Move(self.hero.spd.x * 0.75 * self.hero.dir )
            end
        end
    end
    -- attack judgement
    if self.hero:GetAttackBox() then
        self.atkJudger:Judge(self.hero, "MONSTER", self.attackName)
    end

    if self.hero:GetBody():GetCurrentPlayNum() == 0 then
        self.FSM:SetState(self.FSM.oriState,self.hero)
    end
    
end 

function _State_Attack:Exit()
    
end

function _State_Attack:GetTrans()
	return self.trans
end

return _State_Attack 



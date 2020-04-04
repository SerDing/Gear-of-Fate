--[[
	Desc: FrenzyAttack state 
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]
local _Base  = require "entity.states.base"

---@class State.FrenzyAttack : State.Base
local _FrenzyAttack = require("core.class")(_Base)

function _FrenzyAttack:Ctor(data, ...)
    _Base.Ctor(self, data, ...)
    self.name = "frenzyattack"
    self.anims ={"frenzy1", "frenzy2", "frenzy3", "frenzy4"}
    self.trans = {
        {"NORMAL", "BACK", "jump", true}, 
        {"SKILL", 46, "upperslash"}, 
		{"SKILL", 64, "gorecross"}, 
		{"SKILL", 65, "hopsmash"}, 
	}
    
    self._process = 0
    self.hitTimes = 0
    self.spdRate = 0.55
end 

function _FrenzyAttack:OnAttack(frame)
    if not self._entity:GetAttackBox() or self.hitTimes >= 2 then
        return
    end
    self.combat:ClearDamageArr()
    if self.combat:Judge(self._entity, "MONSTER", self.anims[self._process]) then
        self.hitTimes = self.hitTimes + 1
    end
end

function _FrenzyAttack:Enter()
    _Base.Enter(self)
    -- _Base.Effect(self, "frenzy/sword1-1.ani")
    -- _Base.Effect(self, "frenzy/sword1-3.ani")
    -- _Base.Effect(self, "frenzy/sword1-4.ani")
    self.avatar:Play(self.anims[1])
    
    self.avatar:GetPart("weapon_c1").eventMap.OnChangeFrame:AddListener(self, self.OnAttack)
    self.avatar:GetPart("weapon_b1").eventMap.OnChangeFrame:AddListener(self, self.OnAttack)
    self.combat:ClearDamageArr()

	self._process = 1
    self.hitTimes = 0
end

function _FrenzyAttack:Update()    
    local _leftHold = self.input:IsHold("LEFT")
    local _rightHold = self.input:IsHold("RIGHT")
    local _movable = true

    if (_leftHold and self._entity.transform.direction == 1) or
    (_rightHold and self._entity.transform.direction == -1) then
        _movable = false
    end

    if self._process == 1 then
        
        if self.input:IsHold("ATTACK") and self.body:GetFrame() > 4 then
            self._process = 2
            -- self.atkJudger:ClearDamageArr()
            self.hitTimes = 0
            self.avatar:Play(self.anims[self._process])

            -- self:ClearEffects()

            -- self:Effect("frenzy/sword2-1.ani")
            -- self:Effect("frenzy/sword2-3.ani")
            -- self:Effect("frenzy/sword2-4.ani")
           
        end 
        
    elseif self._process == 2 then
        
        if _movable then
            if self.body:GetFrame() <= 2 then
                self.movement:X_Move(self._entity.spd.x * self._entity.transform.direction )
            end 
    
            if (_leftHold and self._entity.transform.direction == -1 ) or
            (_rightHold and self._entity.transform.direction == 1 )   then
                self.movement:X_Move(self._entity.spd.x * self.spdRate * self._entity.transform.direction )
            end 
        end

        if self.input:IsHold("ATTACK") and self.body:GetFrame() > 3 then
            self._process = 3
            -- self.atkJudger:ClearDamageArr()
            self.hitTimes = 0
            self.avatar:Play(self.anims[self._process])
            
            -- self:ClearEffects()

            -- self:Effect("frenzy/sword3-1.ani")
            -- self:Effect("frenzy/sword3-2.ani")
            -- self:Effect("frenzy/sword3-3.ani")

        end 
        
    elseif self._process == 3 then

        if _movable then
            if self.body:GetFrame() < 4 then
                self.movement:X_Move(self._entity.spd.x * self._entity.transform.direction )
            end 
            
            if (_leftHold and self._entity.transform.direction == -1 ) or
            (_rightHold and self._entity.transform.direction == 1 )   then
                
                self.movement:X_Move(self._entity.spd.x * self.spdRate  * self._entity.transform.direction )
            end
        end

        if self.input:IsHold("ATTACK") and self.body:GetFrame() > 3 then
            self._process = 4

            -- self.atkJudger:ClearDamageArr()

            self.hitTimes = 0
            self.avatar:Play(self.anims[self._process])
            
            
            -- self:ClearEffects()

            -- self:Effect("frenzy/sword4-1.ani")
            -- self:Effect("frenzy/sword4-2.ani")
            -- self:Effect("frenzy/sword4-3.ani")

        end 

    elseif self._process == 4 then
        if self.body:GetFrame() < 3 then
            if _movable then
                self.movement:X_Move(self._entity.spd.x * self._entity.transform.direction )
                
                if (_leftHold and self._entity.transform.direction == -1 ) or
                (_rightHold and self._entity.transform.direction == 1 )   then
                    
                    self.movement:X_Move(self._entity.spd.x * self.spdRate  * self._entity.transform.direction )
                end
            end
        end 
    end 
   
    -- if self._entity:GetAttackBox() then
    --     local _hit = self.atkJudger:Judge(self._entity, "MONSTER", self.childName[self.attackNum])
    --     if _hit then
    --         self.hitTimes = self.hitTimes + 1
    --         if self.hitTimes < 2 then
    --             self.atkJudger:ClearDamageArr()
    --         end
    --     end
    -- end

end 

function _FrenzyAttack:Exit()
    _Base.Exit(self)
    self.avatar:GetPart("weapon_b1").eventMap.OnChangeFrame.DelListener(self, self.OnAttack)
    self.avatar:GetPart("weapon_c1").eventMap.OnChangeFrame.DelListener(self, self.OnAttack)
    for n=1,#self.effect do
        self.effect[n].playOver = true
    end
end

function _FrenzyAttack:GetTrans()
	return self.trans
end

return _FrenzyAttack 
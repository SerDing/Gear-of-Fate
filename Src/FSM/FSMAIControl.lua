--[[
	Desc: Control behavior of the entity using its FSM
	Author: Night_Walker 
	Since: 2018-02-25 15:56:25 
	Last Modified time: 2018-02-25 15:56:25 
	Docs: 
		* Write notes here even more 
]]

local _FSMAIControl = require("Src.Core.Class")()

local _ObjectMgr = require "Src.Scene.ObjectManager"

local hero_ = {}

function _FSMAIControl:Ctor(FSM_, entity)
    
    -- instance pointer
    self.FSM = FSM_
    hero_ = _ObjectMgr.GetHero()

    -- property
    self.moveTerm = entity.property["[detination change term]"] or 5000
    self.attackDelay = entity.property["[attack delay]"] or 1000
    self.attackDelay = 1000
    self.warLike = entity.property["[warlike]"] or 60
    self.warLike = 100
    self.range = {
        {320, 150}, -- observation area 
        {320, 400, 85, 150}, -- onlookers area
        {30, 30}, -- attacking area
    }

    -- perceptions init
    self.aim = entity:GetAim()
    self.dir = 1
    self.heroPos = {}

    -- timer data
    self.moveTimer = self.moveTerm
    self.attackTimer = 0

end 

function _FSMAIControl:Update(dt, entity)
    
    self:UpdatePerceptions(entity)

    self.moveTimer = self.moveTimer + dt
    self.attackTimer = self.attackTimer + dt

    if GetDistance(hero_:GetPos(), entity:GetPos()) <= entity.property["[sight]"] then-- in the sight of the monster
        -- attack
        if self.FSM.curState.name == "waiting" or self.FSM.curState.name == "move" then
            if self:IsInAttackArea(hero_, entity, {30, 30}) then
                if self.attackTimer >=  self.attackDelay / 1000 then
                    self.attackTimer = 0
                    if self:GetWarLikeResult() then
                        self.FSM:SetState("attack", entity)
                    end
                end
            end 
        end
        -- Visual reaction
        if self:IsInAttackArea(hero_, entity, self.range[1]) and self.FSM.curState.name == "waiting" then
            entity:SetDir(self.dir)
        end

        -- path planning
        if self.FSM.curState.name == "waiting" then
            if self.moveTimer >= self.moveTerm / 1000 then
                self.moveTimer = 0
                self.FSM:SetState("move", entity)
                local _range = (self:GetWarLikeResult()) and self.range[3] or self.range[1]
                entity:SetAim(
                    self.heroPos.x + math.random(-_range[1], _range[1]), 
                    self.heroPos.y + math.random(-_range[2], _range[2])
                )
            end
        end
        -- log("close to the target", GetDistance(hero_:GetPos(), entity:GetPos()))
    else

        -- idle
        log("monster idle")
    end

end 

function _FSMAIControl:UpdatePerceptions(entity)
    -- self.aim = entity:GetAim()
    self.dir = (math.floor(hero_.pos.x) > math.floor(entity.pos.x)) and 1 or -1
    self.heroPos = hero_:GetPos()
end

function _FSMAIControl:GetWarLikeResult()
    return math.random(1, 100) < self.warLike
end

function _FSMAIControl:IsInAttackArea(obj, entity, range)
    
    local _objPos = obj:GetPos()
    local _entityPos = entity:GetPos()

    if math.abs(_objPos.x - _entityPos.x) <= range[1] and 
    math.abs(_objPos.y - _entityPos.y) <= range[2] then
        
        return true
    end

    return false
end

function _FSMAIControl:SetDir(entity)
    local _dir = (math.floor(hero_.pos.x) > math.floor(entity.pos.x)) and 1 or -1
    entity:SetDir(_dir)
end

return _FSMAIControl 
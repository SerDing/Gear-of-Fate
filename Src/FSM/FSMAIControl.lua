--[[
	Desc: Control behavior of the entity using its FSM
	Author: Night_Walker 
	Since: 2018-02-25 15:56:25 
	Last Modified time: 2018-02-25 15:56:25 
	Docs: 
		* Write notes here even more 
]]

local _FSMAIControl = require("Src.Core.Class")()

local _ACTORMGR = require "Src.Actor.ActorMgr"
local _GDB = require "Src.Game.GameDataBoard"

function _FSMAIControl:Ctor(FSM_, entity, nav, input)
    
    -- instance pointer
    self.FSM = FSM_
    self.nav = nav
    self.input = input
    self.hero_ = _ACTORMGR.mainPlayer
    
    -- property
    self.moveTerm = entity.property["[detination change term]"] or 5000
    self.attackDelay = entity.property["[attack delay]"] or 1000
    self.warLike = entity.property["[warlike]"] or 60
    -- self.warLike = 100
    self.range = {
        {320, 200}, -- observation area 
        {320, 400, 85, 150}, -- onlookers area
        {30, 30}, -- attack area
    }
    self.pos = {x = 0, y = 0}
    self.move = false
    self.lastDistanceDir = {x = 0, y = 0}
    self.distanceDir = {x = 0, y = 0}

    -- perceptions data init
    self.aim = entity:GetAim()
    self.dir = 1
    self.heroPos = {}
    self.newAim = {}

    -- timer data
    self.moveTimer = math.random(0, self.moveTerm)
    self.attackTimer = math.random(0, self.attackDelay)
    
    self.scene = {} -- null ptr
end 

function _FSMAIControl:Update(dt, entity)

    self:UpdatePerceptions(dt, entity)

    -- in the sight of the monster
    if GetDistance(self.hero_:GetPos(), entity:GetPos()) <= entity.property["[sight]"] then
        self:Action(entity)
        self:SelectDestination(entity)
        self:MoveMethod(entity)    
        self:SetDir(entity, self.heroPos)
    else
        -- idle
        self:SetDir(entity, self.newAim)
        if self.FSM:GetCurState().name == "move" then
            self.FSM:SetState("waiting", entity)
        end
        
    end
    
end

function _FSMAIControl:Action(entity)
    -- attack
    if self.FSM.curState.name == "waiting" then
        if self:IsInAttackArea(self.hero_, entity, {30, 30}) then
            if self.attackTimer >=  self.attackDelay / 1000 then
                self.attackTimer = 0
                if self:GetWarLikeResult() then
                    self.FSM:SetState("attack", entity)
                end
            end
        end
    end
end

function _FSMAIControl:SelectDestination(entity)
    if self.FSM:GetCurState().name == "waiting" then
        if self.moveTimer >= self.moveTerm / 1000 then
            self.moveTimer = 0
            -- print("start select new destination")
            local _range = (self:GetWarLikeResult()) and self.range[3] or self.range[1]
            self.newAim = {}
            local calcTimes = 0
            repeat
                self.newAim = {
                    x = self.heroPos.x + math.random(-_range[1], _range[1]), 
                    y = self.heroPos.y + math.random(-_range[2], _range[2])
                }
                calcTimes = calcTimes + 1
                if calcTimes >= 10 then
                    break
                end
                -- print("repeat calc aim")
            until self.scene:IsInMoveableArea(self.newAim.x, self.newAim.y) and self.scene:IsInObstacles(self.newAim.x, self.newAim.y)[1] == false
            -- print("nav pos:", self.newAim.x, self.newAim.y)
            
            -- print("finished select new destination")
            self:NavMove(self.newAim.x, self.newAim.y, entity)
            
        end
    end
end

function _FSMAIControl:MoveMethod(entity)
    
    -- if self.move then -- move stage
    --     if self.distanceDir.x == self.lastDistanceDir.x then
    --         if entity:GetPos().x < self.pathNodes[self.nodeIndex]:GetPos().x then
    --             self.input:Press(_GDB.GetKey("RIGHT"))
    --         end

    --         if entity:GetPos().x > self.pathNodes[self.nodeIndex]:GetPos().x then
    --             self.input:Press(_GDB.GetKey("LEFT"))
    --         end
    --     end

    --     if self.distanceDir.y == self.lastDistanceDir.y then
    --         if entity:GetPos().y < self.pathNodes[self.nodeIndex]:GetPos().y then
    --             self.input:Press(_GDB.GetKey("DOWN"))
    --         end
            
    --         if entity:GetPos().y > self.pathNodes[self.nodeIndex]:GetPos().y then
    --             self.input:Press(_GDB.GetKey("UP"))
    --         end
    --     end

    --     self.distanceDir = {
    --         x = (entity:GetPos().x - self.pathNodes[self.nodeIndex]:GetPos().x > 0) and 1 or -1 , 
    --         y = (entity:GetPos().y - self.pathNodes[self.nodeIndex]:GetPos().y > 0) and 1 or -1
    --     }

    --     if self.distanceDir.x == - self.lastDistanceDir.x and 
    --        self.distanceDir.y == - self.lastDistanceDir.y then -- outride goal node, switch goal to next node
    --         if self.nodeIndex < self.nodesNum then
    --             self.nodeIndex = self.nodeIndex + 1
    --             entity:SetAimNode(self.pathNodes[self.nodeIndex])
    --             self.lastDistanceDir = {
    --                 x = (entity:GetPos().x - self.pathNodes[self.nodeIndex]:GetPos().x > 0) and 1 or -1 , 
    --                 y = (entity:GetPos().y - self.pathNodes[self.nodeIndex]:GetPos().y > 0) and 1 or -1
    --             }
    --         else
    --             self.FSM:SetState("waiting", entity)
    --             self.move = false
    --         end
    --         self.input:Release(_GDB.GetKey("RIGHT"))
    --         self.input:Release(_GDB.GetKey("LEFT"))
    --         self.input:Release(_GDB.GetKey("UP"))
    --         self.input:Release(_GDB.GetKey("DOWN")) 
    --     end
    -- end

    -- old move stop logic
    if self.FSM:GetCurState().name == "move" then -- move state control
        local _stopRange = self.FSM:GetCurState():GetStopRange()
        if self.pathNodes[self.nodeIndex]:IsInNode(entity:GetPos().x, entity:GetPos().y) then -- math.abs(self.pos.x - self.aim.x) <= _stopRange
            if self.nodeIndex < self.nodesNum then
                self.nodeIndex = self.nodeIndex + 1
                entity:SetAimNode(self.pathNodes[self.nodeIndex])
            else
                self.FSM:SetState("waiting", entity)
            end
        end
    end

end

function _FSMAIControl:NavMove(x, y, entity)

    self.pathNodes = self.nav:FindPath(entity, x, y)
    
    if not self.pathNodes then
        -- print("End node cannot be pass, path finding finished.")
        return false
    end

    self.nodesNum = #self.pathNodes
    self.nodeIndex = 1
    entity:SetAimNode(self.pathNodes[self.nodeIndex])
    self.FSM:SetState("move", entity)
    
    -- self.lastDistanceDir = {
    --     x = (entity:GetPos().x - self.pathNodes[self.nodeIndex]:GetPos().x > 0) and 1 or -1 , 
    --     y = (entity:GetPos().y - self.pathNodes[self.nodeIndex]:GetPos().y > 0) and 1 or -1
    -- }

    -- self.move = true
    -- print("monster start move")
	self.FSM:GetCurState():SetStopRange(self.nav:GetNodeSize() / 2)
end

function _FSMAIControl:UpdatePerceptions(dt, entity)
    self.aim = entity:GetAim()
    self.pos = entity:GetPos()
    self.heroPos = self.hero_:GetPos()
    self.moveTimer = self.moveTimer + dt
    self.attackTimer = self.attackTimer + dt
end

function _FSMAIControl:GetWarLikeResult()
    return (math.random(1, 100) < self.warLike)
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

function _FSMAIControl:SetDir(entity, aim)
    if self.FSM:GetCurState().name == "damage" or self.FSM:GetCurState().name == "die" then
        return
    end
    local _dir = (math.floor(aim.x) > math.floor(entity.pos.x)) and 1 or -1
    entity:SetDir(_dir)
end

function _FSMAIControl:SetScenePtr(ptr)
	assert(ptr,"Err: _FSMAIControl:SetScenePtr() scene pointer is nil!")
	self.scene = ptr
end

return _FSMAIControl 
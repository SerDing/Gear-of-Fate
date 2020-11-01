--[[
	Desc: Entity Manager
	Author: SerDing
	Since: 2019-11-07
    Alter: 2019-11-07
    * Attention! You must assign the logic and responsibility of every component clearly
    to update them in right order, it's neccessary for using this entity-component architecture 
    or you can't find suitable updating order easily.
]]
local _runningOrder = {
    update = {
        "aic",
        "state",
        "combat",
        "skills",
        "projectile",
        "movement",
        "fighter",
        "hitstop",
        "effect",
        "stats",
        "buff",
        "input",
        "render",
    },
    draw = {
        "render", 
    },
}

---@class EntityManager
---@field protected _entityList table<int, Entity>
---@field protected _count int
---@field public player Entity
local _EntityMgr = {
    _entityList = {},
    _count = 0,
    player = nil,
}

---@class Entity
---@field public transform Entity.Component.Transform
---@field public identity Entity.Component.Identity
---@field public aic Entity.Component.AIC
---@field public input Entity.Component.Input
---@field public render Entity.Component.Render
---@field public fighter Entity.Component.Fighter
---@field public movement Entity.Component.Movement
---@field public stats Entity.Component.Stats
---@field public state Entity.Component.State
---@field public skills Entity.Component.Skills
---@field public combat Entity.Component.Combat
---@field public equipment Entity.Component.Equipment
---@field public hitstop Entity.Component.HitStop
---@field public buff Entity.Component.Buff
---@field public effect Entity.Component.Effect
---@field public projectile Entity.Component.Projectile
local _Entity = require("core.class")()

function _EntityMgr.Update(dt)
    for i=1,#_runningOrder.update do
        local compKey = _runningOrder.update[i]
        local j = 1
        while j <= #_EntityMgr._entityList do
            local entity = _EntityMgr._entityList[j]
            local comp = entity[compKey] or nil ---@type Entity.Component.Base
            if comp and comp.Update and comp.enable then 
                comp:Update(dt)
            end
            j = j + 1
        end
    end

    for n = #_EntityMgr._entityList, 1, -1 do
        if _EntityMgr._entityList[n].identity.process == 0 then
            _EntityMgr.DelEntity(_EntityMgr._entityList[n])
        end 
	end 
end

---@param a Entity
---@param b Entity
local _Sort = function (a, b)
    local y1 = a.transform.position.y + a.render.offset
    local y2 = b.transform.position.y + b.render.offset
	if math.floor(y1) == math.floor(y2) then
		return a.identity.id < b.identity.id
	else
		return math.floor(y1) < math.floor(y2)
	end
end

function _EntityMgr.Draw() 
    table.sort(_EntityMgr._entityList, _Sort)
    for i=1,#_runningOrder.update do
        local compKey = _runningOrder.update[i]
        for j = 1, #_EntityMgr._entityList do
            local entity = _EntityMgr._entityList[j]
            local comp = entity[compKey] or nil ---@type Entity.Component.Base
            if comp and comp.Draw and comp.enable then 
                comp:Draw()
            end
        end
    end
end

---@param entity Entity
function _EntityMgr.AddEntity(entity)
    _EntityMgr._entityList[#_EntityMgr._entityList + 1] = entity
    _EntityMgr._count = _EntityMgr._count + 1
    entity.identity.id = _EntityMgr._count
end

---@param entity Entity
function _EntityMgr.DelEntity(entity)
    local index = 0
    for i = 1, #_EntityMgr._entityList do
        if _EntityMgr._entityList[i] == entity then
            index = i
        end
    end
    table.remove(_EntityMgr._entityList, index)
    _EntityMgr._count = _EntityMgr._count - 1
end

---@return table<int, Entity>
function _EntityMgr.GetEntityList()
    return _EntityMgr._entityList
end

return _EntityMgr
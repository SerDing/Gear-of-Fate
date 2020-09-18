--[[
	Desc: Entity Manager
	Author: SerDing
	Since: 2019-11-07
	Alter: 2019-11-07
]]
local _keylist = {
    update = {
        'hitstop',
        'stats',
        'buff',
        'skills',
        'state',
        'input',
        'effect',
        'projectile',
        'movement',
        'render',
    },
    draw = {
        'render', 
	    'buff', 
	    'collider',
    },
}

---@class EntityManager
---@field protected _entities table<number, Entity>
---@field protected _count number 
---@field public player Entity
local _EntityMgr = {
    _entities = {},
    _count = 0,
    player = nil,
}

---@class Entity
---@field public transform Entity.Component.Transform
---@field public identity Entity.Component.Identity
---@field public input Entity.Component.Input
---@field public render Entity.Component.Render
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

---@param entity Entity
---@param dt number
local function _UpdateEntity(entity, dt)
    local component = nil ---@type Component
    for i = 1, #_keylist.update do
        component = entity[_keylist.update[i]] or nil
        if component and component.Update and component.enable then
            component:Update(dt)
        end
    end
end

---@param entity Entity
local function _DrawEntity(entity)
    local component = nil ---@type Component
    for i = 1, #_keylist.draw do
        component = entity[_keylist.draw[i]] or nil
        if component and component.Draw and component.enable then 
            component:Draw()
        end
    end
end

function _EntityMgr.Update(dt)
    --[[
        Using for loop to update entities will make the new entity 
        which is created in current loop cannot be update, 
        because the times of current for loop is fixed before you create new entity and add it into list, 
        and its value won't be changed when new entity be added.
        So it will make some bugs like the render component of a new effect entity cannot apply
        data from transform component leading to the effect is not in right position when its first draw 
        (first update of render component has not been performed).
    ]]
    -- for i = 1, #_EntityMgr._entities do
    --     _UpdateEntity(_EntityMgr._entities[i], dt)
    -- end 

    local i = 1
    while i <= #_EntityMgr._entities do
        _UpdateEntity(_EntityMgr._entities[i], dt)
        i = i + 1
    end

    for n = #_EntityMgr._entities, 1, -1 do
        if _EntityMgr._entities[n].identity.process == 0 then
            _EntityMgr.DelEntity(_EntityMgr._entities[n])
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
    table.sort(_EntityMgr._entities, _Sort)
    for i = 1, #_EntityMgr._entities do
        _DrawEntity(_EntityMgr._entities[i])
    end
end

---@param entity Entity
function _EntityMgr.AddEntity(entity)
    _EntityMgr._entities[#_EntityMgr._entities + 1] = entity
    _EntityMgr._count = _EntityMgr._count + 1
    entity.identity.id = _EntityMgr._count
end

---@param entity Entity
function _EntityMgr.DelEntity(entity)
    local index = 0
    for i = 1, #_EntityMgr._entities do
        if _EntityMgr._entities[i] == entity then
            index = i
        end
    end
    table.remove(_EntityMgr._entities, index)
    _EntityMgr._count = _EntityMgr._count - 1
end

return _EntityMgr
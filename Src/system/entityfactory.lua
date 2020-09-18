--[[
	Desc: Entity Factory
	Author: SerDing 
	Since: 2019-03-14
	Alter: 2019-11-07
]]

local _RESMGR = require("system.resource.resmgr")
local _Transform = require("component.transform") 
local _Identity = require("component.identity")
local _ENTITYMGR = require("system.entitymgr")
local _Skills = require("component.skills")

---@class EntityFactory
---@field public mainPlayer Entity
---@field public monsters table<number, Monster>
local _FACTORY = {
    mainPlayer = nil,
    monsters = {}
}
local this = _FACTORY

local _creationOrder = {
    "input", 
    "stats", 
    "movement", 
    "combat", 
    "buff", 
    "render",
    "skills", 
    "state", 
    "hitstop",
    "effect",
    "projectile",
    "equipment", 
}

---@param data string @entity instance data path
---@return Entity
function _FACTORY.NewEntity(data, param)
    if type(data) == "string" then
        data = _RESMGR.LoadEntityData(data)
    end

    ---@type Entity
    local entity = {}
    entity.transform = _Transform.New(data.transform or {}, param)
    entity.identity = _Identity.New(data.identity or {}, param)
    
    local key = ""
    for i=1,#_creationOrder do
        key = _creationOrder[i]
        if data[key] then
            entity[key] = data[key].class.New(entity, data[key], param)
        end 
    end

    _ENTITYMGR.AddEntity(entity)

    return entity
end

return _FACTORY
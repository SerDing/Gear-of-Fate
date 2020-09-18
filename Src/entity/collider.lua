--[[
    Desc: Collider, set of boxes.
    * contains damage boxes and attack boxes
    * set from data
    * frame->colliderData, frames->colliderDataGroup(table)
    * Frameani carry collider, colliderGroup, colliderGroupPool
 	Author: SerDing
	Since: 2020-04-19
	Alter: 2020-04-19 
]]

local _Box = require("entity.drawable.box")
local _Color = require("engine.graphics.config.color")

---@class Entity.Collider
---@field protected _lists table<string, table<int, Entity.Drawable.Box>>
local _Collider = require("core.class")()

---@class Entity.Collider.ColliderData
---@field public damage table
---@field public attack table
local _ColliderData = require("core.class")()

local function _HandleData(data, lists, key)
    if data[key] and #data[key] >= 1 then
        if #data[key][1] > 6 then -- all boxes in one table
            local args = data[key][1]
            for i=1,#data[key][1] / 6, 6 do
                lists[key][i] = _Box.New(args[i], args[i + 1], args[i + 2], args[i + 3], args[i + 4], args[i + 5])
            end
        else
            for i=1,#data[key] do
                lists[key][i] = _Box.New(unpack(data[key][i]))
            end
        end
    end
end

---@param data Entity.Collider.ColliderData
function _Collider:Ctor(data)
    self._lists = {
        damage = {},
        attack = {},
    }

    if data then
        _HandleData(data, self._lists, "damage")
        _HandleData(data, self._lists, "attack")
    end
end

function _Collider:Set(x, y, z, sx, sy)
    for key, list in pairs(self._lists) do
        for i=1,#list do
            list[i]:Set(x, y, z, sx, sy)
        end
    end
end

---@param opponent Entity.Collider
---@param selfKey string
---@param oppoKey string
function _Collider:Collide(opponent, selfKey, oppoKey)
    local selfList = self._lists[selfKey]
    local oppoList = opponent:GetBoxList(oppoKey)

    for i=1,#selfList do
        for j=1,#oppoList do
            local collision, x, y, z = selfList[i]:Collide(oppoList[j])
            if collision then
                return true, x, y, z
            end
        end
    end

    return false
end

function _Collider:Draw()
    for i=1,#self._lists.damage do
        self._lists.damage[i]:Draw(_Color.const.blue, _Color.const.green)
    end
    for i=1,#self._lists.attack do
        self._lists.attack[i]:Draw(_Color.const.blue, _Color.const.red)
    end
end

function _Collider:GetBoxList(key)
    return self._lists[key]
end

return _Collider
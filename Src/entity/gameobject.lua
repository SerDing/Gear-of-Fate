--[[
	Desc: game object base class
 	Author: SerDing
	Since: 2017-07-28 
	Alter: 2019-11-06 
]]

---@class GameObject

local _GameObject = require("core.class")()

function _GameObject:Ctor()
	self.type = "OBJECT"
    self.position = {x = 0, y = 0, z = 0}
	self.layerId = 1000
	self.layer = ""
	self.Y = 0

    self._children = {} ---@type GameObject[]
end

---@param dt number
function _GameObject:Update(dt)
    for i = 1, #self._children do
        self._children[i]:Update(dt)
    end
end

function _GameObject:Draw()
    for i = 1, #self._children do
        self._children[i]:Draw()
    end
end

---@param type string
function _GameObject:SetType(type)
    self.type = type
end

---@param x number
---@param y number
---@param z number
function _GameObject:SetPos(x, y, z)
    self.position.x = x or self.position.x
    self.position.y = y or self.position.y
    self.position.z = z or self.position.z
end

function _GameObject:SetLayerId(id)
    self.layerId = id
end

function _GameObject:SetLayer(layer)
    self.layer = layer
end

function _GameObject:GetLayer()
    return self.layer
end

function _GameObject:GetType()
    return self.type
end

function _GameObject:GetId()
    return self.layerId
end

function _GameObject:GetY()
    -- return self.pos.y
    if self.transform then
        return self.transform.position.y 
    end
    return self.position.y
end

---@param e table
function _GameObject:AddChild(e)
    assert(type(e) == "table", "Game object must be table!")
    self._children[#self._children + 1] = e
end

---@param e table
function _GameObject:RemoveChild(e)
    assert(type(e) == "table", "Game object must be table!")
    for i = 1, #self._children do
        if self._children[i] == e then
            table.remove(self._children, i)
        end
    end
end

return _GameObject
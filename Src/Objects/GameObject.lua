--[[
	Desc: game object interface
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* game object is the object which has a concrete image in game and stored in normal layer of scene
		* override the function getY() when you implement this interface
]]

---@class GameObject

local _GameObject = require("Src.Core.Class")()

function _GameObject:Ctor()
	self.type = "OBJECT"
    self.pos = {x = 0, y = 0, z = 0}
	self.layerId = 1000
	self.layer = ""
	self.Y = 0

    self.gameObjects = {}
end

---@param dt number
function _GameObject:Update(dt)
    for i = 1, #self.gameObjects do
        self.gameObjects[i]:Update(dt)
    end
end

function _GameObject:Draw()
    for i = 1, #self.gameObjects do
        self.gameObjects[i]:Draw()
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
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
    self.pos.z = z or self.pos.z
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
    return self.Y
end

---@param o table
function _GameObject:AddGameObject(o)
    assert(type(o) == "table", "Game object must be table!")
    self.gameObjects[#self.gameObjects + 1] = o
end

---@param o table
function _GameObject:RemoveGameObject(o)
    assert(type(o) == "table", "Game object must be table!")
    for i = 1, #self.gameObjects do
        if self.gameObjects[i] == o then
            table.remove(self.gameObjects, i)
        end
    end
end

return _GameObject
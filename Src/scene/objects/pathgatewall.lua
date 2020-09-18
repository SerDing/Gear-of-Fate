--[[	
	Desc: specail pathgate which is just a wall
	Author: SerDing 	
	Since: 2019-04-03 16:00:42 
	Alter: 2019-04-03 16:00:42 	

]]

local _obj = require "entity.gameobject"
local _PathgateWall = require("core.class")(_obj)

local _STRING = require("engine.string")
local _Animator = require "engine.animation.frameani"
local _Tile = require "scene.objects.tile"

function _PathgateWall:Ctor(dataPath, x, y)

    self:SetType("PASSIVEOBJ")

    self.data = dofile(dataPath)
    self.layer = self.data["[layer]"]
    self.position = {x = x, y = y}
    local pathArr = _STRING.split(dataPath, "/")
	self.pathHead = string.gsub(dataPath, pathArr[#pathArr], "")

    self.aniUp = _Animator.New()
    self.aniDown = _Animator.New() 
    
    self.dir = 0
    if self.data["[layer]"] == "[normal]" then
        self.dir = -1 -- left
    elseif self.data["[layer]"] == "[bottom]" then
        self.dir = 1 -- right
    end
    
    self.aniData = {}
    self.aniData["up"] = dofile(self.pathHead .. self.data["[string data]"][1])
    self.aniData["down"] = dofile(self.pathHead .. self.data["[string data]"][2])
    
    self.aniUp:SetImgPathArg(self.data["[int data]"][1], self.data["[int data]"][2])
    self.aniDown:SetImgPathArg(self.data["[int data]"][1], self.data["[int data]"][2])
    
    self.aniUp:Play(self.aniData["up"])
    self.aniDown:Play(self.aniData["down"])

    local _tilePath = self.pathHead .. self.data["[string data]"][3]
    self.tile = _Tile.New(_tilePath)
    self.tile:SetPos(self.position.x, 150 - 16 * 2)
    if self.dir == 1 then
        self.tile:SetOffset(-224 * self.dir, 0)
        self.tile:SetOffset_2(-224 * self.dir, 0) -- set grid data offset  80 + 80 - self.pos.y   + self.data["[int data]"][6]
    end
    -- self.tile.debug = true
    -- self.tile.debug = false
end 

function _PathgateWall:Update(dt)
    self.aniUp:Update(dt)
    self.aniDown:Update(dt)

end 

function _PathgateWall:Draw(x, y)
    
    self.aniUp:Draw(self.position.x , self.position.y + 200, 0, 1 * self.dir, 1)
    self.aniDown:Draw(self.position.x , self.position.y + 200, 0, 1 * self.dir, 1)
    self.tile:Draw()
    
    love.graphics.circle("fill", self.position.x, self.position.y, 3, 10)
end

return _PathgateWall 
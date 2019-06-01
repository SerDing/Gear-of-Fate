--[[	
	Desc: nomal pathgate (left or right)
	Author: SerDing 
	Since: 2019-04-06 18:11:48 
	Alter: 2019-04-06 18:11:48 	
	Docs: 
		* Write more details here 
]]
local _obj = require "Src.Scene.Object" 
local _PathgateSide = require("Src.Core.Class")()

local _Animation = require "Src.AniPack"
local _Tile = require "Src.Scene.Blocks.Tile"

function _PathgateSide:Ctor(dataPath, x, y, destMap)
	--[[
        ["[layer]"]="[normal]",
		["[string data]"]={
			"Animation/GranFlorisLeftU1.ani",
			"Animation/GranFlorisLeftGate.ani",
			"Animation/GranFlorisLeftCloseDoor.ani",
			"Animation/GranFlorisLeftOpenDoor.ani",
			"Animation/GranFlorisLeftLight.ani",
			"Animation/GranFlorisLeftO1.ani",
			"Tile/LeftDoor.til",
		},
		["[int data]"]={
			0,1,
			0,1,
			1,1,
			2,1,
			2,1,
			0,1,
			0,19,
		},
		["[name]"]="洛兰的左侧门",}
    ]]
	self:SetType("PATHGATE")

    self.data = require(dataPath)
    self.layer = self.data["[layer]"]
    self.pos = {x = x, y = y}
    local _pathArr = split(dataPath, "/")
	self.pathHead = string.gsub(dataPath, _pathArr[#_pathArr], "")

    self.aniUp = _Animation.New()
    self.aniDown = _Animation.New()
    
    
    self.dir = 0
    if self.data["[layer]"] == "[normal]" then
        self.dir = -1 -- left
    elseif self.data["[layer]"] == "[bottom]" then
        self.dir = 1 -- right
    end

    self.aniData = {}
    self.aniData["up"] = require(string.gsub(self.pathHead .. self.data["[string data]"][1], "%.ani", ""))
    self.aniData["down"] = require(string.gsub(self.pathHead .. self.data["[string data]"][2], "%.ani", ""))
    
    self.aniUp:SetFileNum(self.data["[int data]"][1], self.data["[int data]"][2])
    self.aniDown:SetFileNum(self.data["[int data]"][1], self.data["[int data]"][2])
    
    self.aniUp:SetAnimation(self.aniData["up"])
    self.aniDown:SetAnimation(self.aniData["down"])
    self.aniUp:SetPos(self.pos.x , self.pos.y + 200)
    self.aniDown:SetPos(self.pos.x , self.pos.y + 200)
    
    self.aniUp:SetDir(self.dir)
    self.aniDown:SetDir(self.dir)

    local _tilePath = self.pathHead .. self.data["[string data]"][3]
    self.tile = _Tile.New(_tilePath)
    self.tile:SetPos(self.pos.x, 80 * 2)
    if self.dir == 1 then
        self.tile:SetOffset(-224 * self.dir, 0)
        self.tile:SetOffset_2(-224 * self.dir, 0) -- set grid data offset  80 + 80 - self.pos.y   + self.data["[int data]"][6]
    end
    
    -- self.tile.debug = true
	
end 

function _PathgateSide:Update(dt)
    --body
end 

function _PathgateSide:Draw(x,y)
    --body
end

return _PathgateSide 
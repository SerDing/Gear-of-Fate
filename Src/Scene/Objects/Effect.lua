--[[
	Desc: Effect
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]
---@class _Effect
---@public field animation _Animation

local _obj = require "Src.Objects.GameObject"
local _Effect = require("Src.Core.Class")(_obj)

local _RESMGR = require "Src.Resource.ResManager"
local _Animation = require "Src.Engine.Animation.Animation"

local MathFloor = math.floor

function _Effect:Ctor(aniPath)
	
	self.aniPath = aniPath
	self.aniData = nil

	self.aniData = _RESMGR.LoadDataFile(aniPath)
	
	self:SetType("EFFECT")

	self.animation = _Animation.New(self.aniData)
	self.animation:Play()

	self.pos = {x = 0, y = 0, z = 0}
	self.offset = {x = 0,y = 0}

	self.speed = 0
	self.dir = 1

	self.destroyed = false
	self.over = false
	self.debug = true
	-- self.debug = false

	-- self.ani.debug = true

	self.layer = 0
	love.graphics.setPointSize(6)
end 

function _Effect:Update(dt)
	
	self.animation:Update(dt)
	
	if self.animation.playOver then
		self.over = true
	end
	
end 

function _Effect:Draw()
	self.animation:Draw()
	if self.debug then
		love.graphics.points(self.pos.x, self.pos.y)
	end
end

function _Effect:SetPos(x, y, z)
    self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
    self.pos.z = z or self.pos.z
    self.animation:SetPos(
            MathFloor( self.pos.x + self.offset.x),
            MathFloor( self.pos.y + self.offset.y),
            MathFloor(self.pos.z)
    )
end

function _Effect:SetDir(dir)
	self.dir = dir
	self.animation:SetDir(dir)
end

--function _Effect:SetLayer(layer)
--	self.layer = layer or 1
--end

function _Effect:GetY()
	return  self.pos.y
end

function _Effect:GetWidth()
    return self.animation:GetWidth()
end

function _Effect:GetHeight()
    return self.animation:GetHeight()
end

function _Effect:Destroy()
	self = {}
end 

function _Effect:IsDestroyed()
	return self.destroyed 
end 

function _Effect:IsOver()
	return self.over
end 

return _Effect 
--[[
	Desc: A new lua class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		*Write notes here even more
]]
local _obj = require "Src.Scene.Object" 
local _Effect = require("Src.Core.Class")(_obj)

local _AniPack = require "Src.AniPack" 
local _Rect = require "Src.Core.Rect" 

function _Effect:Ctor(aniPath)
	
	self.animas = {}
	
	if aniPath then -- a single effect which just has one animation
		self.animas[1] = require(string.sub(aniPath, 1, string.len(aniPath) - 4))
	else 
		self.aniPathArr = {}
	end 
	
	-- local tmpArr = string.split(self.path,"/")
	-- self.name = tmpArr[#tmpArr]
	
	self.ani = _AniPack.New()
	self.ani:SetAnimation(self.animas[1])

	self.pos = {x = 0,y = 0}

	self.offset = {x = 0,y = 0}
	self.offset_2 = {x = 0,y = 0}
	
	self.ani:SetFilter(true)

	self:SetType("EFFECT")

	self.rect = _Rect.New(0,0,20,20)
	
	self.debug = true
	
	self.display = 1

	self.destroyed = false

	self.over = false

	self.aniPath = aniPath

	self.speed = 0

	self.dir = 1

	-- self.ani.debug = true

	self.ani.plusOffset = true

	self.layer = 0 -- it's useable just when this effect entity in hero class as an extra effect

end 

function _Effect:Update(dt)
	
	self.ani:Update(dt)
	
	-- if self.ani:GetCount() + 1 == self.ani.num then
	-- 	self.over = true
	-- end 
	
	if self.ani:GetCurrentPlayNum() == 0 then
		self.over = true
	end 

	self.pos.x = self.pos.x + self.speed * self.dir
end 

function _Effect:Draw(x,y)

	self.ani:Draw(
	math.floor( self.pos.x + self.offset.x + (x or 0)),
	math.floor( self.pos.y + self.offset.y + (y or 0))
	)
	
	if self.debug then
		self.rect:SetPos(
			math.floor(self.pos.x  + (x or 0))-2,
			math.floor(self.pos.y  + (y or 0))-2
		)
		self.rect:SetColor(0,255,255,255)
		self.rect:Draw()
	end
	
end

function _Effect:SetPos(x,y)
    self.pos.x = x or 0
	self.pos.y = y or 0
end

function _Effect:SetMoveSpeed(v)
	self.speed = v
end

function _Effect:SetDir(dir)
	self.dir = dir
	self.ani:SetDir(self.dir)
end

function _Effect:SetOffset(x,y)
	self.offset = {x = x,y = y}
end

function _Effect:SetLayer(layer)
	self.layer = layer or 1
end

function _Effect:SetFilter(switch)
    self.ani:SetFilter(switch)
end

function _Effect:GetY()
	
	return  self.pos.y
end

function _Effect:GetWidth()
    return self.ani:GetWidth() 
end

function _Effect:GetHeight()
    return self.ani:GetHeight() 
end

function _Effect:GetAni()
    return self.ani
end

function _Effect:Destroy()
	-- self.ani = nil
	-- self.destroyed = true
	
end 

function _Effect:IsDestroyed()
	return self.destroyed 
end 

function _Effect:IsOver()
	return self.over
end 

return _Effect 
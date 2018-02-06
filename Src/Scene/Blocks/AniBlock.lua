--[[
	Desc: ani block in scene(*.map)
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]
local _obj = require "Src.Scene.Object" 
local _AniBlock = require("Src.Core.Class")(_obj)

local _AniPack = require "Src.AniPack" 
local _Rect = require "Src.Core.Rect" 
local _KEYBOARD = require "Src.Core.KeyBoard"
local _GAMEINI = require "Src.Config.GameConfig" 

function _AniBlock:Ctor(aniPath,layer)
	
    self.anima = require(string.sub(aniPath, 1, string.len(aniPath) - 4))
	
	-- self.path = string.sub(aniPath, 1, string.len(aniPath) - 4)	
	-- local tmpArr = string.split(self.path,"/")
	-- self.name = tmpArr[#tmpArr]

	self.ani = _AniPack.New("MAP_ANI_BLOCK")
	self.ani:SetAnimation(self.anima)

	self.pos = {x = 0,y = 0}

	self.offset = {x = 0,y = 0}
	self.offset_2 = {x = 0,y = 0}
	
	self.layer = layer or "[closeback]"
	self.ani:SetFilter(true)

	if self.layer == "[normal]" then
		self:SetType("OBJECT")
	end

	self.rect = _Rect.New(0,0,4,4)
	self.rect:SetDrawType(0)

	self.debug = false
	
	self.display = 1

end

function _AniBlock:Update(dt)
	
	self.ani:Update(dt)
	
	if _KEYBOARD.Press("f1") then
		if self.debug then
			self.debug = false
		else
			self.debug = true
		end
	end
end 

function _AniBlock:Draw(x,y)
	
	local _sx = self.ani:GetSpriteBox().position.x
	local _sy = self.ani:GetSpriteBox().position.y
	local _w = self.ani:GetWidth()
	local _h = self.ani:GetHeight()
	

	if _sx + _w < -10 or
		_sy + _h < -10 or
		_sx > _GAMEINI.winSize.width + 10 or
		_sy > _GAMEINI.winSize.height + 10 then
		
		self.display = 0

		print(_sx,_sy)
	else 
		self.display = 1
	end

	if self.display == 1 then
		self.ani:Draw(
		math.floor(self.offset.x + self.offset_2.x + self.pos.x + (x or 0)),
		math.floor(self.offset.y + self.offset_2.y + self.pos.y + (y or 0))
		)
		
	end 
	
	if self.layer == "[normal]"  then
		if self.debug then
			self.rect:SetPos(
				math.floor(self.offset.x + self.offset_2.x + self.pos.x + (x or 0))-2,
				math.floor(self.offset.y + self.offset_2.y + self.pos.y + (y or 0))-2
			)
			self.rect:SetColor(0,255,0,255)
			self.rect:Draw()
		end
	end

end

function _AniBlock:SetPos(x,y)
    self.pos.x = x or 0
	self.pos.y = y or 0
end

function _AniBlock:SetLayer(layer)
	self.layer = layer
end

function _AniBlock:SetOffset(x,y)
	self.offset = {x = x,y = y}
end

function _AniBlock:SetOffset_2(x,y)
    self.offset_2 = {x = x or 0,y = y or 0}
end

function _AniBlock:SetFilter(switch)
    self.ani:SetFilter(switch)
end

function _AniBlock:GetY()
	return  self.pos.y + self.offset_2.y
end

function _AniBlock:GetWidth()
    return self.ani:GetWidth() 
end

function _AniBlock:GetHeight()
    return self.ani:GetHeight() 
end

function _AniBlock:GetAni()
    return self.ani
end

return _AniBlock 
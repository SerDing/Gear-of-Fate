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
	
	self.path = string.sub(aniPath, 1, string.len(aniPath) - 4)	
	-- local tmpArr = string.split(self.path,"/")
	-- self.name = tmpArr[#tmpArr]

	self.subType = "MAP_ANI_OBJ"

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

function _AniBlock:Draw(x, y)
  --[[Notes:
		* x: MAP_ANI_OBJ -- cam_x  |  MAP_ANI_BACK -- scroll offset x
		* y: MAP_ANI_OBJ -- cam_y  |  MAP_ANI_BACK -- scroll offset y
    ]]
	
	local _sx = self.ani:GetRect():GetVertex()[1].x
	local _sy = self.ani:GetRect():GetVertex()[1].y
	local _w = self.ani:GetWidth()
	local _h = self.ani:GetHeight()

	if self.subType == "MAP_ANI_OBJ" then 
		x = -x
		y = -y

		self.display = 1
		
		-- four situations that this AniBlock is not in camera sight
		if _sx + _w < x then
			self.display = 0
			-- print("AniBlock disappeared ","_sx+w",_sx+_w," < cam_x",x)
		end

		if _sy + _h < y then
			self.display = 0
			-- print("AniBlock disappeared ","_sy+h",_sy+_h," < cam_y",y)
		end

		if _sx > x + _GAMEINI.winSize.width then
			self.display = 0
			-- print("AniBlock disappeared ","_sx",_sx," > cam_x+width",x + _GAMEINI.winSize.width)
		end
		
		if _sy > y + _GAMEINI.winSize.height then
			self.display = 0
			-- print("AniBlock disappeared ","_sy",_sy," > cam_y+height",y + _GAMEINI.winSize.height)
		end

		-- MAP_ANI_OBJ does not need camera position which is just used to decide whether draw itself
		x = 0
		y = 0
	end

	self.ani:SetPos(
		math.floor(self.offset.x + self.offset_2.x + (x or 0) + self.pos.x ),
		math.floor(self.offset.y + self.offset_2.y + (y or 0) + self.pos.y )
	)

	if self.display == 1 then
		self.ani:Draw()
	else
		-- print("ani block hidden")
	end 
	
	if self.layer == "[normal]"  then
		if self.debug then
			self.rect:SetPos(
				math.floor(self.offset.x + self.offset_2.x + (x or 0) + self.pos.x )-2,
				math.floor(self.offset.y + self.offset_2.y + (y or 0) + self.pos.y )-2
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

function _AniBlock:SetSubType(tp)
    self.subType = tp or "MAP_ANI_OBJ"
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
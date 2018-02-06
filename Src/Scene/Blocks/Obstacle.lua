--[[
	Desc: A subType of passiveObject
	Author: Night_Walker 
	Since: 2018-02-05 18:37:03 
	Last Modified time: 2018-02-05 18:37:03 
	Docs: 
		* Write notes here even more 
]]
local _obj = require "Src.Scene.Object" 
local _Obstacle = require("Src.Core.Class")(_obj)

local _AniPack = require "Src.AniPack" 
local _Rect = require "Src.Core.Rect" 
local _KEYBOARD = require "Src.Core.KeyBoard"
local _GAMEINI = require "Src.Config.GameConfig" 

function _Obstacle:Ctor(_path)
	
	self.path = _path
	
	self.property = {}

	local _fileContent = LoadFile(_path)
	-- print(_fileContent)
	local _filePieces = split(_fileContent,"\n")

	local _peiece

----[[  load width position  ]]
	for i=1,#_filePieces do

		_filePieces[i] = string.gsub( _filePieces[i],"\r","") -- delete "\r" of every line

		-- print("_filePiece:" .. _filePieces[i])

		if _filePieces[i] == "[width]" then
			
			_peiece = split(_filePieces[i + 1],"\t")
			-- _peiece[1] = string.gsub( _peiece[1],"\r","")
			-- _peiece[2] = string.gsub( _peiece[2],"\r","")
			self.property["[width]"] = {
				[1] = tonumber(_peiece[1]), 
				[2] = tonumber(_peiece[2]), 
			}
			
			print("self.[width]:",self.property["[width]"][1],self.property["[width]"][2])

		end

		if _filePieces[i] == "[floating height]" then
			_peiece = _filePieces[i + 1]
			_peiece = string.gsub( _peiece,"\r","")
			_peiece = string.gsub( _peiece,"\t","") 
			_peiece = tonumber(_peiece)
			self.property["[floating height]"] = _peiece
		end

		if _filePieces[i] == "[layer]" then
			_peiece = _filePieces[i + 1]
			_peiece = string.gsub( _peiece,"`","")
			_peiece = string.gsub( _peiece,"\r","")
			_peiece = string.gsub( _peiece,"\t","") 
			self.property["[layer]"] = _peiece
		end

		if _filePieces[i] == "[pass type]" then
			_peiece = _filePieces[i + 1]
			_peiece = string.gsub( _peiece,"`","")
			_peiece = string.gsub( _peiece,"\r","")
			_peiece = string.gsub( _peiece,"\t","") 
			self.property["[pass type]"] = _peiece
		end

		if _filePieces[i] == "[basic motion]" then
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"`","")
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],".ani","")
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"../../..","Data")
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"\r","")
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"\t","")
			_filePieces[i + 1] = string.lower(_filePieces[i + 1])
			self.property["[basic motion]"] = _filePieces[i + 1]
			
		end
		
	end
	if self.property["[layer]"] == "[normal]" then
		self:SetType("OBJECT")
	end
	
	self.anima = require(self.property["[basic motion]"])

	if self.anima['[FRAME MAX]'] == 1 then
		self.ani = _AniPack.New("MAP_ANI_BLOCK")
	else
		self.ani = _AniPack.New()
	end
	
	self.ani:SetAnimation(self.anima)
	
	self.ani:SetFilter(true)

	self.rect = _Rect.New(0,0,4,4)

	self.rect:SetDrawType(0)

	self.pos = {
		x = 0,
		y = 0,
		z = 0,
	}

	self.offset = {
		x = 0,
		y = 0,
	}

	self.debug = false
	
	self.display = 1

end 

function _Obstacle:Update(dt)
	
	self.ani:Update(dt)
	
	if _KEYBOARD.Press("f1") then
		if self.debug then
			self.debug = false
		else
			self.debug = true
		end
	end
end 

function _Obstacle:Draw(x,y)
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
		math.floor(self.pos.x + self.offset.x + (x or 0)),
		math.floor(self.pos.y + self.offset.y + (y or 0))
		)
		
	end 
	
	if self.property["[layer]"] == "[normal]"  then
		if self.debug then
			

			self.rect:SetSize(self.property["[width]"][1], self.property["[width]"][2])
			self.rect:SetCenter(self.property["[width]"][1] / 2, self.property["[width]"][2] / 2)
			self.rect:SetPos(
				math.floor(self.pos.x + self.offset.x + (x or 0)),
				math.floor(self.pos.y + self.offset.y + (y or 0)) + self.pos.z
			)
			self.rect:SetColor(255,255,0,100)
			self.rect:Draw()


			self.rect:SetSize(4, 4)
			self.rect:SetCenter(4 / 2, 4 / 2)
			self.rect:SetPos(
				math.floor(self.pos.x + self.offset.x + (x or 0)),
				math.floor(self.pos.y + self.offset.y + (y or 0)) + self.pos.z
			)
			self.rect:SetColor(0,255,0,255)
			self.rect:Draw()
		end
	end
end

function _Obstacle:SetPos(x, y, z)
    self.pos = {
		x = x or 0,
		y = y or 0,
		z = z or 0,
	}
end

function _Obstacle:SetOffset(x, y)
    self.offset = {
		x = x or 0,
		y = y or 0,
	}
end

function _Obstacle:GetY()
	return  self.pos.y + self.offset.y
end

function _Obstacle:GetLayer()
    return self.property["[layer]"]
end

return _Obstacle 
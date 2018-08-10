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
local _ObjectMgr = require "Src.Scene.ObjectManager"

function _Obstacle:Ctor(_path)
	
	self.hero_ = _ObjectMgr.GetHero()
	
	self.path = _path
	
	self:LoadData(_path)

	if self.property["[layer]"] == "[normal]" then
		self:SetType("OBJECT")
	end
	
	self.subType = "OBSTACLE"

	self.anima = require(self.property["[basic motion]"])

	if self.anima['[FRAME MAX]'] == 1 then
		self.ani = _AniPack.New("MAP_ANI_BLOCK")
	else
		self.ani = _AniPack.New()
	end
	
	self.ani:SetAnimation(self.anima)
	
	self.ani:SetFilter(true)

	self.rect = _Rect.New(0,0,self.property["[width]"][1],self.property["[width]"][2])
	self.rect:SetCenter(self.property["[width]"][1] / 2, self.property["[width]"][2] / 2)

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
	self.alpha = 255

end 

function _Obstacle:LoadData(_path)
	self.property = {}

	local _fileContent = LoadFile(_path)
	local _filePieces = split(_fileContent,"\n")
	local _peiece

	for i=1,#_filePieces do	
		if _filePieces[i] == "\r" or _filePieces[i] == "\n" then
			table.remove(_filePieces, i)
		end
	end
	
    ----[[  load obstacle data  ]]
	for i=1,#_filePieces do

		_filePieces[i] = string.gsub( _filePieces[i],"\r","") -- delete "\r" of every line

		if _filePieces[i] == "[width]" then
			_peiece = split(_filePieces[i + 1],"\t")
			self.property["[width]"] = {
				[1] = tonumber(_peiece[1]), 
				[2] = tonumber(_peiece[2]), 
			}
			-- print("[width] has been read,i = ",i)
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
end

function _Obstacle:Update(dt)
	
	self.ani:Update(dt)
	
	if _KEYBOARD.Press("f1") then
		if self.debug then
			self.debug = false
			log("obstacles debug = false")
		else
			self.debug = true
			log("obstacles debug = true")
		end
	end

	self.ani:SetPos(
		math.floor(self.pos.x + self.offset.x),
		math.floor(self.pos.y + self.offset.y)
	)
	self.rect:SetPos(
		math.floor(self.pos.x + self.offset.x),
		math.floor(self.pos.y + self.offset.y) + self.pos.z
	)

end 

function _Obstacle:Draw(cam_x, cam_y)
    local _sx = self.ani:GetRect():GetVertex()[1].x -- sprite x
	local _sy = self.ani:GetRect():GetVertex()[1].y -- sprite y
	local _w = self.ani:GetWidth()
	local _h = self.ani:GetHeight()
	
	cam_x = - cam_x
	cam_y = - cam_y
	
	if _sx + _w < cam_x or
		_sy + _h < cam_y or
		_sx > cam_x + love.graphics.getWidth() or
		_sy > cam_y + love.graphics.getHeight() then
		
		self.display = 0
		print("_sx+w",_sx+_w," < cam_x",cam_x)
	else 
		self.display = 1
	end

	if self.display == 1 then
		self:AutoAlpha()
		self.ani:Draw()
	end 

	self:Debug()

end

function _Obstacle:AutoAlpha()
	local _heroPos = self.hero_:GetPos()
	local _ObsVertex = self.rect:GetVertex()
	if _heroPos.x >= _ObsVertex[1].x and _heroPos.x <= _ObsVertex[2].x and _heroPos.y <= _ObsVertex[1].y then
		if self.alpha >= 100 then
			self.alpha = self.alpha - 10
			self.ani:SetColor(255, 255, 255, self.alpha)
		end
	else
		if self.alpha <= 255 then
			self.alpha = self.alpha + 10
			self.ani:SetColor(255, 255, 255, self.alpha)
		end
	end
end

function _Obstacle:Debug()
	if self.property["[layer]"] == "[normal]"  then
		if self.debug then
			self.rect:SetColor(255,255,0,200)
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
	self.rect:SetPos(
		math.floor(self.pos.x + self.offset.x),
		math.floor(self.pos.y + self.offset.y) + self.pos.z
	)
	-- print("obstacle vertex", self.rect:GetVertex()[1].x, self.rect:GetVertex()[1].y)
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

function _Obstacle:GetRect()
	return self.rect
end

return _Obstacle 
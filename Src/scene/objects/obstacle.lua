--[[
	Desc: Obstacle
	Author: SerDing
	Since: 2018-02-05 18:37:03 
	Last Modified time: 2020-02-05 18:37:03
]]

local _STRING = require("engine.string")
local _FILE = require('engine.filesystem')
local _Animator = require("engine.animation.frameani")
local _Rect = require("engine.graphics.drawable.rect")
local _ENTITYMGR = require("system.entitymgr")

local _obj = require("entity.gameobject")
local _Obstacle = require("core.class")(_obj)

function _Obstacle:Ctor(path)
	
	self._entity = _ENTITYMGR.mainPlayer

	self._path = path
	self:LoadData(path)

	self:SetType("OBSTACLE")
	self.anim = dofile(self.property["[basic motion]"])
	self.ani = _Animator.New()
	self.ani:Play(self.anim)

	self.rect = _Rect.New(0,0,self.property["[width]"][1],self.property["[width]"][2])

	self.position = { x = 0, y = 0, z = 0 }
	self.offset = { x = 0, y = 0 }
	self.debug = false
	self.display = 1
	self.alpha = 255

end 

function _Obstacle:LoadData(_path)
	self.property = {}

	local _fileContent = _FILE.LoadFile(_path)
	local _filePieces = _STRING.split(_fileContent,"\n")
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
			_peiece = _STRING.split(_filePieces[i + 1],"\t")
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
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"\r","")
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"\t","")
			_filePieces[i + 1] = string.lower(_filePieces[i + 1])
			_filePieces[i + 1] = string.gsub( _filePieces[i + 1],"../../..","Data")
			self.property["[basic motion]"] = _filePieces[i + 1]
		end
		
	end
end

function _Obstacle:Update(dt)
	
	self.ani:Update(dt)
	
	--self.ani:SetPos(
	--	math.floor(self.position.x + self.offset.x),
	--	math.floor(self.position.y + self.offset.y)
	--)
	self.rect:SetPosition(
		math.floor(self.position.x + self.offset.x),
		math.floor(self.position.y + self.offset.y) + self.position.z
	)

end 

function _Obstacle:Draw()
	self:AutoAlphaChange()
	self.ani:Draw(math.floor(self.position.x + self.offset.x), math.floor(self.position.y + self.offset.y))
	self:Debug()
end

function _Obstacle:AutoAlphaChange()
	local _heroPos = self._entity.transform.position
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
			-- self.rect:SetColor(255,255,0,200)
			self.rect:Draw(_, "fill")
		end
	end

end

function _Obstacle:SetPos(x, y, z)
	self.position.x = x or 0
	self.position.y = y or 0
	self.position.z = z or 0
	self.rect:SetPosition(
		math.floor(self.position.x + self.offset.x),
		math.floor(self.position.y + self.offset.y) + self.position.z
	)
end

function _Obstacle:SetOffset(x, y)
    self.offset.x = x or 0
	self.offset.y = y or 0
end

function _Obstacle:GetY()
	return  self.position.y + self.offset.y
end

function _Obstacle:GetLayer()
    return self.property["[layer]"]
end

function _Obstacle:GetRect()
	return self.rect
end

return _Obstacle 
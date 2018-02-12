--[[
    Desc: Tile block in scene (*.map)
    Author: Night_Walker
    Since: Thu Sep 07 2017 23:21:02 GMT+0800 (CST)
    Alter: Thu Sep 07 2017 23:21:02 GMT+0800 (CST)
    Docs: 
        * write notes here even more
]]

local _TileBlock = require("Src.Core.Class")()

local _Sprite = require "Src.Core.Sprite" 
local _Rect = require "Src.Core.Rect" 
local _RESMGR = require "Src.ResManager" 
local _ResPack = require "Src.ResPack"

function _TileBlock:Ctor(path)
    
    self.tile = require(string.sub(path, 1, string.len(path) - 4)) 
    self.sprite = _Sprite.New(_RESMGR.imageNull,0,0,1,1)
    
    self.offset = {x = 0,y = 0}
    self.offset_1 = {x = 0,y = 0}
	self.offset_2 = {x = 0,y = 0}

    local img = _ResPack.New(_RESMGR.pathHead .. self.tile["[IMAGE]"][1])
    
    self.sprite:SetTexture(img:GetTexture(self.tile["[IMAGE]"][2]+1))
	self.offset =img:GetOffset(self.tile["[IMAGE]"][2]+1)
	self.sprite:SetFilter(true)
    
    self.rect = _Rect.New(0,0,16,16)
    self.rect:SetDrawType(1)

    self.debug = false

end 

function _TileBlock:Update(dt)
    --body
end 

function _TileBlock:Draw(x, y)
    self.sprite:Draw(
        self.offset.x + self.offset_2.x + (x or 0),
        self.offset.y + self.offset_2.y + (y or 0) 
    )
    
	local j =0
	
    local lx = x
    local ly = y + self.offset_2.y + 48 --+ self.offset.y

    if self.debug then
        
		for n=1,#self.tile["[pass type]"],224/16 do
			lx = x
			for i=1,224/16 do
				j = j + 1
                if self.tile["[pass type]"][j] == 0 then
                    
                    self.rect:SetColor(255,255,255,200)
                else
                    self.rect:SetColor(0,130,255,255)
                end
                self.rect:SetSize(16, 16)
                self.rect:SetPos(lx,ly)
                self.rect:Draw()
				lx = lx + 16
            end
            
            ly = ly + 16
		end
    end
    
    

end

function _TileBlock:SetOffset(x,y)
	self.offset_1 = {x = x,y = y}
end

function _TileBlock:SetOffset_2(x,y)
    self.offset_2 = {x = x or 0,y = y or 0}
end

function _TileBlock:GetWidth()
	return self.sprite:GetWidth() 
end

return _TileBlock 
--[[
    Desc: Tile block in scene (*.map)
    Author: Night_Walker
    Since: Thu Sep 07 2017 23:21:02 GMT+0800 (CST)
    Alter: Thu Sep 07 2017 23:21:02 GMT+0800 (CST)
    Docs: 
        * write notes here even more
]]

local _Tile = require("Src.Core.Class")()

local _Sprite = require "Src.Core.Sprite" 
local _Rect = require "Src.Core.Rect" 
local _RESMGR = require "Src.Resource.ResManager" 
local _ResPack = require "Src.Resource.ResPack"
local _Collider = require "Src.Core.Collider"

function _Tile:Ctor(path)
    
    self.tile = require(string.sub(path, 1, string.len(path) - 4)) 
    self.sprite = _Sprite.New(_RESMGR.imageNull,0,0,1,1)
    
    self.pos = {x = 0, y = 0}
    self.offset = {x = 0, y = 0} -- sprite original offset
    self.offset_1 = {x = 0, y = 0} -- draw offset
	self.offset_2 = {x = 0, y = 0} -- grid offset

    local img = _ResPack.New(strcat(_RESMGR.pathHead, self.tile["[IMAGE]"][1]))
    
    self.sprite:SetTexture(img:GetTexture(self.tile["[IMAGE]"][2]+1))
	self.offset = img:GetOffset(self.tile["[IMAGE]"][2]+1)
	self.sprite:SetFilter(true)
    
    self.rect = _Rect.New(0,0,16,16)
    self.rect:SetDrawType(0)

    self.debug = false
    -- self.debug = true

end 

function _Tile:Update(dt)

end 

function _Tile:Draw(x, y)
    self.sprite:Draw(
        self.pos.x + self.offset.x + self.offset_1.x,
        self.pos.y + self.offset.y + self.offset_1.y
    )
    
    if self.debug then

        local j = 0
        local lx = x or self.pos.x
        local ly = y or self.pos.y + self.offset_2.y --+ self.offset.y
        
        -- #[pass type] = 420, tile_width = 224, 224/16 = 14, 420/14 = 30
        
        for n = 1, #self.tile["[pass type]"] / 14 do -- #self.tile["[pass type]"] / 14 - 5, 16 * 17 / 16
			lx = x or self.pos.x
			for i = 1, 224 / 16 do -- 224 / 16 = 14
				j = j + 1
                if self.tile["[pass type]"][j] == 0 then
                    self.rect:SetColor(255,255,255,100) -- passable area
                else
                    self.rect:SetColor(0,130,255,100) -- unpassable area
                end
                self.rect:SetSize(16, 16)
                self.rect:SetPos(lx, ly)
                self.rect:Draw()
				lx = lx + 16
            end
            ly = ly + 16
		end
    end
end

function _Tile:IsPassable(x, y, tableRef)
    -- return (bool)passable, if it's not passable then set grid data to tableRef
    
    local nx = math.floor((x - self.pos.x) / 16) + 1
    local ny = math.floor((y - (self.pos.y + self.offset_2.y)) / 16)
    local n = ny * 14 + nx
    
    if self.tile["[pass type]"][n] == 2 then
        return false
    elseif self.tile["[pass type]"][n] == 0 then
        return true
    else
        error("_Tile:IsPassable(x, y, tableRef): Unknown pass type data: " .. tostring(self.tile["[pass type]"][n]))
    end
end

function _Tile:SetPos(x, y)
    self.pos.x = x
    self.pos.y = y
end

function _Tile:SetOffset(x,y)
    self.offset_1.x = x or self.offset_1.x
    self.offset_1.y = y or self.offset_1.y
end

function _Tile:SetOffset_2(x,y)
    self.offset_2.x = x or self.offset_2.x
    self.offset_2.y = y or self.offset_2.y
end

function _Tile:GetWidth()
	return self.sprite:GetWidth()
end

return _Tile 
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
local _RESMGR = require "Src.Resource.ResManager" 
local _ResPack = require "Src.Resource.ResPack"
local _Collider = require "Src.Core.Collider"

function _TileBlock:Ctor(path)
    
    self.tile = require(string.sub(path, 1, string.len(path) - 4)) 
    self.sprite = _Sprite.New(_RESMGR.imageNull,0,0,1,1)
    
    self.pos = {x = 0, y = 0}
    self.offset = {x = 0, y = 0}
    self.offset_1 = {x = 0, y = 0}
	self.offset_2 = {x = 0, y = 0}

    local img = _ResPack.New(strcat(_RESMGR.pathHead, self.tile["[IMAGE]"][1]))
    
    self.sprite:SetTexture(img:GetTexture(self.tile["[IMAGE]"][2]+1))
	self.offset = img:GetOffset(self.tile["[IMAGE]"][2]+1)
	self.sprite:SetFilter(true)
    
    self.rect = _Rect.New(0,0,16,16)
    self.rect:SetDrawType(1)

    self.debug = false
    -- self.debug = true

end 

function _TileBlock:Update(dt)
    --body
end 

function _TileBlock:Draw(x, y)
    self.sprite:Draw(
        self.offset.x + self.offset_2.x + (x or 0),
        self.offset.y + self.offset_2.y + (y or 0)
    )
    
    self:SetPos(x, y)
	

    if self.debug then

        local j = 0
        local lx = x
        local ly = y + self.offset_2.y + 80 --+ self.offset.y

        for n = 0, #self.tile["[pass type]"] - 17, 16 * 17 / 16 do -- 16 * 17 / 16
            -- print("#self.tile[pass type]", #self.tile["[pass type]"], "n", n)
			lx = x
			for i = 1, 224 / 16 do -- 224 / 16 = 14
				j = j + 1
                if self.tile["[pass type]"][j] == 0 then
                    
                    self.rect:SetColor(255,255,255,100) -- passable area
                else
                    self.rect:SetColor(0,130,255,100) -- unpassable area
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

function _TileBlock:IsPassable(x, y) -- return (int)passable, (table)rectRef
    
    local j = 0
    local lx = x
    local ly = y + self.offset_2.y + 80 --+ self.offset.y

    -- check whether the pos(x, y) is in this tile block
    if x >= self.pos.x and x <= self.pos.x + self.sprite:GetWidth() then
        if y >= self.pos.y and y <= self.pos.y + self.sprite:GetHeight() then
            -- check each terrain block
            for n = 0, #self.tile["[pass type]"] - 17, 16 * 17 / 16 do -- 16 * 17 / 16
                lx = x
                for i = 1, 224 / 16 do -- 224 / 16 = 14
                    j = j + 1
                    self.rect:SetSize(16, 16)
                    self.rect:SetPos(lx,ly)
                    
                    if self.tile["[pass type]"][j] == 0 then -- passable terrain block
                        if self.rect:CheckPoint(x, y) then
                            return 1 -- passable
                        end
                    end
                    lx = lx + 16
                end
                ly = ly + 16
            end

            return 0 -- unpassable

        else
            return -1 -- not in this tile block
        end
    else
        return -1 -- not in this tile block
    end
    
end

function _TileBlock:SetPos(x, y)
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
end

function _TileBlock:SetOffset(x,y)
    self.offset_1.x = x or self.offset_1.x
    self.offset_1.y = y or self.offset_1.y
end

function _TileBlock:SetOffset_2(x,y)
    self.offset_2.x = x or self.offset_2.x
    self.offset_2.y = y or self.offset_2.y
end

function _TileBlock:GetWidth()
	return self.sprite:GetWidth() 
end

return _TileBlock 
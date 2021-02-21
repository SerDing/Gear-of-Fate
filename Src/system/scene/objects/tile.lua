--[[
    Desc: Tile block in scene (*.map)
    Author: SerDing
    Since: 2017-09-07
    Alter: 2019-11-30
]]

local _Tile = require("core.class")()

local _Sprite = require "engine.graphics.drawable.sprite"
local _Rect = require "engine.graphics.drawable.rect"
local _RESMGR = require "system.resource.resmgr"
local _ImgPack = require "system.resource.imgpack"

function _Tile:Ctor(path)

    self.tile = _RESMGR.LoadDataFile(path)
    self.sprite = _Sprite.New()
    
    self.position = {x = 0, y = 0}
    self.offset = {x = 0, y = 0} -- sprite original offset
    self.offset_1 = {x = 0, y = 0} -- draw offset
	self.offset_2 = {x = 0, y = 0} -- grid offset

    self.noImg = (self.tile["[IMAGE]"][1] == "")

    if not self.noImg then
        local img = _ImgPack.New(self.tile["[IMAGE]"][1])
        self.sprite:SetImage(img:GetTexture(self.tile["[IMAGE]"][2]+1))
        self.offset = img:GetOffset(self.tile["[IMAGE]"][2]+1)

    end
    
    self.rect = _Rect.New(0, 0, 16, 16)

    self.debug = false
    --self.debug = true
end 

function _Tile:Update(dt)
    if not self.noImg then
        self.sprite:SetRenderValue("position",
            self.position.x + self.offset.x + self.offset_1.x,
            self.position.y + self.offset.y + self.offset_1.y
        )
    end
end 

function _Tile:Draw(x, y)
    if not self.noImg then
        self.sprite:Draw()
    end
    
    if self.debug then

        local j = 0
        local lx = x or self.position.x + self.offset_2.x
        local ly = y or self.position.y + self.offset_2.y --+ self.offset.y
        
        -- #[pass type] = 420, tile_width = 224, 224/16 = 14, 420/14 = 30
        
        for n = 1, #self.tile["[pass type]"] / 14 do -- #self.tile["[pass type]"] / 14 - 5, 16 * 17 / 16
			lx = x or self.position.x + self.offset_2.x
			for i = 1, 224 / 16 do -- 224 / 16 = 14
				j = j + 1
                if self.tile["[pass type]"][j] == 0 then
                    -- self.rect:SetColor(255,255,255,100) -- passable area
                else
                    -- self.rect:SetColor(0, 130, 255, 200) -- unpassable area -- 0, 130, 255, 100
                    self.rect:SetSize(16, 16)
                    self.rect:SetPosition(lx, ly)
                    self.rect:Draw(_, "fill")
                end
                
				lx = lx + 16
            end
            ly = ly + 16
        end
        
        -- love.graphics.circle("fill", self.pos.x + self.offset_2.x, self.pos.y + self.offset_2.y, 4, 10)
    end
end

---@param x float
---@param y float
---@return boolean
function _Tile:IsPassable(x, y)
    local nx = math.floor((x - (self.position.x + self.offset_2.x) ) / 16) + 1
    local ny = math.floor((y - (self.position.y + self.offset_2.y) ) / 16)
    local n = ny * 14 + nx
    
    if self.tile["[pass type]"][n] == 2 then
        return false
    elseif self.tile["[pass type]"][n] == 0 then
        return true
    else
        error("_Tile:IsPassable(x, y, tableRef): Unknown pass type data: " .. tostring(self.tile["[pass type]"][n]))
    end
end

function _Tile:IsInTile(x, y)
    local rx = self.position.x + self.offset_2.x
    local ry = self.position.y + self.offset_2.y
    if x < rx or x > rx + 224 or y < ry or y > ry + #self.tile["[pass type]"] / 14 * 16 then
        return false
    end
    return true
end

function _Tile:SetPos(x, y)
    self.position.x = x
    self.position.y = y
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
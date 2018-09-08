--[[
	Desc: popup bubble frame
	Author: Night_Walker 
	Since: 2018-08-15 21:33:28 
	Last Modified time: 2018-08-15 21:33:28 
	Docs: 
		* Write more details here 
]]

local _Pop = require("Src.Core.Class")()

local _RESMGR = require("Src.Resource.ResManager")
local _Sprite = require("Src.Core.Sprite")

function _Pop:Ctor(w, h, imageInfo)
    self.w = w or 0
    self.h = h or 0
    assert(imageInfo, "_Button:Ctor()  imageInfo is nil!")
    self.spriteArr = {}
    for i = 0, 8 do
        self.spriteArr[i] = _Sprite.New(_RESMGR.pathHead .. imageInfo[i + 1])
    end
    self.cell_w = self.spriteArr[4]:GetWidth()
    self.cell_h = self.spriteArr[4]:GetHeight()
    self.w = math.floor((self.w) / self.cell_w)
    self.h = math.floor((self.h) / self.cell_h)
end 

function _Pop:Draw(x, y)
    -- draw upper-left corner
    self.spriteArr[0]:Draw(x, y)

    -- draw top side
    for i = 0 + self.spriteArr[0]:GetWidth(), self.w * self.cell_w, self.cell_w do
        self.spriteArr[1]:Draw(x + i, y)
    end

    -- draw upper-right corner
    self.spriteArr[2]:Draw(x + self.spriteArr[0]:GetWidth() + self.cell_w * self.w, y)

    -- draw left side
    for i = 0 + self.spriteArr[0]:GetHeight(), self.h * self.cell_h, self.cell_h do
        self.spriteArr[3]:Draw(x, y + i)
    end

    -- draw center blocks
    for k = 0 + self.spriteArr[0]:GetWidth(), self.w * self.cell_w, self.cell_w do
        for i = 0 + self.spriteArr[0]:GetHeight(), self.h * self.cell_h, self.cell_h do
            self.spriteArr[4]:Draw(x + k, y + i)
        end
    end

    -- draw right side
    for i = 0 + self.spriteArr[0]:GetHeight(), self.h * self.cell_h, self.cell_h do
        self.spriteArr[5]:Draw(x + self.spriteArr[0]:GetWidth() + self.cell_w * self.w , y + i)
    end

    -- draw bottom-left corner
    self.spriteArr[6]:Draw(x, y + self.spriteArr[0]:GetHeight() + self.h * self.cell_h)

    -- draw bottom side
    for i = 0 + self.spriteArr[0]:GetWidth(), self.w * self.cell_w, self.cell_w do
        self.spriteArr[7]:Draw(x + i, y + self.spriteArr[0]:GetHeight() + self.h * self.cell_h)
    end

    -- draw bottom-right corner
    self.spriteArr[8]:Draw(x + self.spriteArr[0]:GetWidth() + self.cell_w * self.w, y + self.spriteArr[0]:GetHeight() + self.h * self.cell_h)
end

return _Pop 
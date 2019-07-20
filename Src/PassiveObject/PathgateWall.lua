--[[	
	Desc: specail pathgate which is just a wall
	Author: SerDing 	
	Since: 2019-04-03 16:00:42 
	Alter: 2019-04-03 16:00:42 	
	Docs: 
		* Write more details here 
]]

local _obj = require "Src.Objects.GameObject"
local _PathgateWall = require("Src.Core.Class")(_obj)

local _Animator = require "Src.Engine.Animation.Animator"
local _Tile = require "Src.Scene.Objects.Tile"

--@param table data
function _PathgateWall:Ctor(dataPath, x, y)

    --[[
        潜在的问题：

            文件转换有错误：多出 ‘}’ 符号
            路径处理太过麻烦：要获取一个文件所在路径再获取附属的动画等其它文件，还要替换各种拓展格式名。
            图像资源文件 每个img每次都要手动整理偏移文件 有时候还会忘掉 直接导致 ResPack崩掉 游戏运行不起来
    ]]
    self:SetType("PASSIVEOBJ")

    self.data = require(dataPath)
    self.layer = self.data["[layer]"]
    self.pos = {x = x, y = y}
    local _pathArr = split(dataPath, "/")
	self.pathHead = string.gsub(dataPath, _pathArr[#_pathArr], "")

    self.aniUp = _Animator.New()
    self.aniDown = _Animator.New()
    
    
    self.dir = 0
    if self.data["[layer]"] == "[normal]" then
        self.dir = -1 -- left
    elseif self.data["[layer]"] == "[bottom]" then
        self.dir = 1 -- right
    end
    
    self.aniData = {}
    self.aniData["up"] = require(string.gsub(self.pathHead .. self.data["[string data]"][1], "%.ani", ""))
    self.aniData["down"] = require(string.gsub(self.pathHead .. self.data["[string data]"][2], "%.ani", ""))
    
    self.aniUp:SetImgPathArg(self.data["[int data]"][1], self.data["[int data]"][2])
    self.aniDown:SetImgPathArg(self.data["[int data]"][1], self.data["[int data]"][2])
    
    self.aniUp:Play(self.aniData["up"])
    self.aniDown:Play(self.aniData["down"])
    self.aniUp:SetPos(self.pos.x , self.pos.y + 200)
    self.aniDown:SetPos(self.pos.x , self.pos.y + 200)
    
    self.aniUp:SetDir(self.dir)
    self.aniDown:SetDir(self.dir)

    local _tilePath = self.pathHead .. self.data["[string data]"][3]
    self.tile = _Tile.New(_tilePath)
    self.tile:SetPos(self.pos.x, 150 - 16 * 2)
    if self.dir == 1 then
        self.tile:SetOffset(-224 * self.dir, 0)
        self.tile:SetOffset_2(-224 * self.dir, 0) -- set grid data offset  80 + 80 - self.pos.y   + self.data["[int data]"][6]
    end
    -- self.tile.debug = true
    -- self.tile.debug = false
end 

function _PathgateWall:Update(dt)
    self.aniUp:Update(dt)
    self.aniDown:Update(dt)

end 

function _PathgateWall:Draw(x, y)
    
    self.aniUp:Draw()
    self.aniDown:Draw()
    self.tile:Draw()
    
    love.graphics.circle("fill", self.pos.x, self.pos.y, 3, 10)
end

function _PathgateWall:GetY()
	return  self.pos.y
end

return _PathgateWall 
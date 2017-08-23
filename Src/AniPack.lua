--[[
	Desc: Animation Pack class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:36:07
	Docs:
		* This class can add many *.ani files by using :AddAnimation(path)
		* using :SetAnimation() to switch the class to objective state animation
]]


local _AniPack = require("Src.Class")()

local _Sprite = require "Src.Core.Sprite"
local _ResPack = require "Src.ResPack"
local _RESMGR = require "Src.ResManager"
local _Rect = require "Src.Core.Rect"

function _AniPack:Ctor() --initialize

	self.pos = {x = 0, y = 0}
	self.center = {x = 0, y = 0}
	self.size = {w = 1, h = 1}
	self.dir = 1

	self.playNum = 1 	-- 播放次数
	self.fileNum = 0000

	self.frameDataGrp = {} 	-- 帧数据组 包含多个ani数据
	self.frameData = {} -- 从ani文件中读取出的帧数据
	self.frameHead = "[FRAME000]" -- 每一帧的开头帧号

	if (not _RESMGR.imageNull) then
	    _RESMGR.imageNull = love.image.newImageData(1, 1)
	end
	self.playingSprite = _Sprite.New(_RESMGR.imageNull)

	self.count = 0
	self.time = 0

	self.box = _Rect.New(0,0,1,1)

	-- self.currentBox = _Rect.New(0,0,1,1)

	self.focus = {
		["focus"] = false,
		["max"] = 220,
		["min"] = 80,
		["dir"] = -1,
		["speed"] = 240,
		["ARGB"] = {["A"] = 200,["R"] = 0,["G"] = 255,["B"] = 0}
	}

end


function _AniPack:Update(dt)
	
	self.frameHead = string.format("[FRAME%03d]", self.count)

	if not  self.frameHead then
		print("Error:_AniPack:Update() --> frameHead is null")
		return self
	end

	self.time = self.time + (dt or 0)

	-- print("self.time:" .. tostring(self.time))

	if self.time >= (self.frameData[self.frameHead]["[DELAY]"] or 100) / 1000  then
		self.time = 0-- self.time - self.frameData[self.frameHead]["[DELAY]"] / 1000
		if self.playNum ~= 0 then
			self.count = self.count + 1
		end

		if self.count >= self.num then
			if self.playNum == -1 then
				self.count = 0
			elseif self.playNum > 1 then
				self.playNum = self.playNum - 1
				self.count = 0
			elseif self.playNum == 1 then
			 	self.count = self.count - 1
			 	self.playNum = self.playNum - 1
			end
		end
	end

	if self.frameData[self.frameHead]["[IMAGE]"][1]  ~= "" then
		--print(string.format("Sprite/"..self.frameData[self.frameHead]["[IMAGE]"][1],self.str))
		-- local img = require "sys/img"(string.format("playingSpriteite/"..self.frameData[self.frameHead]["[IMAGE]"][1], self.str))
		local tmpStr = string.format(self.frameData[self.frameHead]["[IMAGE]"][1],self.fileNum)
		local img = _ResPack.New(_RESMGR.pathHead .. tmpStr)

		if not img then
			print("Error:_AniPack:Update() --> load imgPack failed. " )
			return self
		end

		self.playingSprite:SetTexture(img:GetTexture(self.frameData[self.frameHead]["[IMAGE]"][2]+1))
		-- self.playingSprite = img:GetTexture(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
		self.offset = img:GetOffset(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
		img = nil
	else
		self.playingSprite = _RESMGR.imageNull
	end

	self:SetCenter(-self.frameData[self.frameHead]["[IMAGE POS]"][1],-self.frameData[self.frameHead]["[IMAGE POS]"][2])

	if self.num > 1 then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
			if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
				-- self.playingSprite:置混合(2)
				self:SetBlendMode(2)
			end
		end

		if self.frameData[self.frameHead]["[RGBA]"] then
			self:SetColor(ARGB(self.frameData[self.frameHead]["[RGBA]"][1],
				self.frameData[self.frameHead]["[RGBA]"][2],
				self.frameData[self.frameHead]["[RGBA]"][3],
				self.frameData[self.frameHead]["[RGBA]"][4]))
		end
	end

end

function _AniPack:Draw(x,y,r,w,h)
	
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.size.w = w or self.size.w
	self.size.h = h or self.size.h

	if (r == nil) then
	    r = 0
	end

	if self.focus["focus"]  then --霸体状态下的外线效果

		self.focus["ARGB"]["A"]  = self.focus["ARGB"]["A"]   + self.focus["dir"] * self.focus["speed"] * 引擎.取帧时间()
		if self.focus["ARGB"]["A"]  >= self.focus["max"] or
			self.focus["ARGB"]["A"] <= self.focus["min"] then

			self.focus["dir"] = -self.focus["dir"]
		end
		self:SetColor(ARGB(self.focus["ARGB"]["A"] ,self.focus["ARGB"]["R"],self.focus["ARGB"]["G"],self.focus["ARGB"]["B"]))

		self.playingSprite:SetCenter(self.center.x,self.center.y)
		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x ) - 1,
			math.floor(self.pos.y + self.offset.y ) - 1,
			r,
			self.size.w * self.dir,
			self.size.h)

		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x ) + 1,
			math.floor(self.pos.y + self.offset.y ) - 1,
			r,
			self.size.w * self.dir,
			self.size.h)

		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x ) + 1,
			math.floor(self.pos.y + self.offset.y ) + 1,
			r,
			self.size.w * self.dir,
			self.size.h)

		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x ) - 1,
			math.floor(self.pos.y + self.offset.y ) + 1,
			r,
			self.size.w * self.dir,
			self.size.h)
	end

	self.playingSprite:SetCenter(self.center.x,self.center.y)
	self.playingSprite:Draw(
		self.pos.x + self.offset.x * self.dir,
		self.pos.y + self.offset.y,
		r, 		-- rotation 旋转参数
		self.size.w * self.dir,
		self.size.h
	)

		
	-- self:DrawBox()

end

function _AniPack:DrawBox()
	local boxTab = self.frameData[self.frameHead]["[DAMAGE BOX]"]
	local dmgBox = _Rect.New(0,0,1,1)
	dmgBox:SetColor(0,255,0,255)
	if (boxTab) then
	    for n=1,#boxTab,6 do
			dmgBox:SetPos(self.pos.x + boxTab[n] * self.size.w,self.pos.y + - boxTab[n+2])
			dmgBox:SetSize(boxTab[n+3] * self.size.w,-boxTab[n+5] * self.size.h)
			dmgBox:Draw()
	    end
	end


	local boxTab = self.frameData[self.frameHead]["[ATTACK BOX]"]
	local atkBox = _Rect.New(0,0,1,1)
	atkBox:SetColor(255,0,0,255)
	if (boxTab) then
	    for n=1,#boxTab,6 do
			atkBox:SetPos(self.pos.x + boxTab[n] * self.size.w,self.pos.y + - boxTab[n+2])
			atkBox:SetSize(boxTab[n+3] * self.size.w,-boxTab[n+5] * self.size.h)
			atkBox:Draw()
	    end
	end
end

function _AniPack:SetAnimation(id)

	if (type(id) ~= "string") then
	    print("Warning! _AniPack:setAnimation()--the type of id must be string ")
	    return
	end

	self.frameData = self.frameDataGrp[id].data
	self.playNum = self.frameDataGrp[id].num or 1

	self.count = 0
	self.time = 0
	self.num = self.frameData["[FRAME MAX]"]

	self:Update(0)

	if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
			-- self.playingSprite:置混合(2)
			self:SetBlendMode(2) -- Alpha线性渐变混合 Alpha.one
		end
	end

	if self.frameData[self.frameHead]["[RGBA]"] then
		self:SetColor(self.frameData[self.frameHead]["[RGBA]"][1],
			self.frameData[self.frameHead]["[RGBA]"][2],
			self.frameData[self.frameHead]["[RGBA]"][3],
			self.frameData[self.frameHead]["[RGBA]"][4])
	end
end

function _AniPack:AddAnimation(aniPath,__num,id)
	-- aniPath	ani文件的路径
	-- __num	播放次数
	-- id		ani的对应动作(状态)名称


	if(type(aniPath) == "string")then
		local content = require(aniPath) -- content is a table
		self.frameDataGrp[id] = {data = content, num = __num}
	elseif (type(aniPath) == "table") then
	    print("Error: _AniPack:AddAnimation() --> aniPath expect a string ,not a table.")
	    return self
	else
	    print("Error: _AniPack:AddAnimation() --> aniPath get a unexpected type!")
	    return self
	end
end

function _AniPack:SetCenter(x,y)
	self.center.x = x or self.center.x
	self.center.y = y or self.center.y
end

function _AniPack:SetColor(r,g,b,a)
	self.color = {r = r, g = g, b = b, a = a }
end

function _AniPack:SetBlendMode(mode)
	-- statements
end

function _AniPack:SetFileNum(num)
	self.fileNum = num
	-- print("fileNum changed :" .. tostring(self.fileNum))
end

function _AniPack:SetDir(dir_)
	self.dir = dir_
end

return _AniPack
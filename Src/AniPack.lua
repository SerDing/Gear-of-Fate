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

local _RESMGR = require "ResManager"
local _ResPack = require "ResPack"

function _AniPack:Ctor() --initialize

	self.pos = {x = 0, y = 0}
	self.center = {x = 0, y = 0}
	self.size = {w = 1, h = 1}

	self.playingSprite = 0
	self.playNum = 1 	-- 播放次数

	self.frameDataGrp = {} 	-- 帧数据组 包含多个ani的帧数据
	self.frameData = {} -- 从"*.ani.lua"文件中读取出的帧数据
	self.frameHead = "[FRAME000]" -- 每一帧的开头帧号

	if (not _RESMGR.imageNull) then
	    _RESMGR.imageNull = love.image.newImageData(1, 1)
	end
	self.playingSprite = _RESMGR.imageNull

	self.count = 0
	self.time = 0

	self.box = require ("Rect")(0,0,1,1)
	self.currentBox = require ("Rect")(0,0,1,1)

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
		return self
	end

	self.time = self.time + (dt or 0)

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
		--print(string.format("sprite/"..self.frameData[self.frameHead]["[IMAGE]"][1],self.str))
		-- local img = require "sys/img"(string.format("sprite/"..self.frameData[self.frameHead]["[IMAGE]"][1], self.str))

		local img = _ResPack.New(self.frameData[self.frameHead]["[IMAGE]"][1])
		if not img then
			print("Error:_AniPack: (update)load imgPack failed. " )
			return self
		end

		-- self.spr:置纹理(img:取纹理(self.frameData[self.frameHead]["[IMAGE]"][2]+1))
		self.playingSprite = img:GetTexture(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
		self.offset = img:GetOffset(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
	else
		self.playingSprite = _RESMGR.imageNull
	end



	self:Setcenter(self.frameData[self.frameHead]["[IMAGE POS]"][1],self.frameData[self.frameHead]["[IMAGE POS]"][2])

	if self.num > 1 then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
			if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
				-- self.spr:置混合(2)
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


	if self.focus["focus"]  then --霸体状态下的外线效果

		self.focus["ARGB"]["A"]  = self.focus["ARGB"]["A"]   + self.focus["dir"] * self.focus["speed"] * 引擎.取帧时间()
		if self.focus["ARGB"]["A"]  >= self.focus["max"] or
			self.focus["ARGB"]["A"] <= self.focus["min"] then

			self.focus["dir"] = -self.focus["dir"]
		end
		self:setColor(ARGB(self.focus["ARGB"]["A"] ,self.focus["ARGB"]["R"],self.focus["ARGB"]["G"],self.focus["ARGB"]["B"]))

		self.spr:Draw(
			math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) - 1,
			math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)-1,
			r or 0,
			self.size.w,
			self.size.h)

		self.spr:Draw(math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) + 1,math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)-1,
			r or 0,
			self.size.w,
			self.size.h)

		self.spr:Draw(math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) + 1,
			math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)+1,
			r or 0,
			self.size.w,
			self.size.h)

		self.spr:Draw(math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) - 1,
			math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)+1,
			r or 0,
			self.size.w,
			self.size.h)
	end



	love.graphics.draw(self.playing_sprite,
		self.pos.x,
		self.pos.y,
		r, 		-- rotation 旋转参数
		w,
		h,
		self.center.x,
		self.center.y)


	self.CurrentRect:SetPos(self.pos.x,self.pos.y)

	local tmp_width = self.playing_sprite:getWidth()
	local tmp_height = self.playing_sprite:getHeight()

	self.CurrentRect:SetSize(tmp_width,tmp_height)
	self.CurrentRect:Draw()
end

function _AniPack:SetAnimation(id,__num)

	if (type(id) ~= "string") then
	    print("Warning! _AniPack:setAnimation()--the type of id must be string ")
	    return
	end

	self.frameData = self.frameDataGrp[id].data
	self.playNum = self.frameDataGrp[id].__num or 1

	self.count = 0
	self.time = 0
	self.num = self.frameData["[FRAME MAX]"]

	if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
			-- self.spr:置混合(2)
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
		sellf.frameDataGrp[id] = {data = content, num = __num}
	elseif (type(aniPath) == "table") then
	    print("Error: _AniPack:AddAnimation() --> aniPath expect a string ,not a table.")
	    return self
	else
	    print("Error: _AniPack:AddAnimation() --> aniPath get a unexpected type!")
	    return self
	end


end

function _AniPack:Setcenter(x,y)
	self.center.x = x or self.center.x
	self.center.y = y or self.center.y
end

function _AniPack:SetColor(r,g,b,a)
	self.color = {r = r, g = g, b = b, a = a }
end

function _AniPack:SetBlendMode(mode)
	-- statements
end

return _AniPack
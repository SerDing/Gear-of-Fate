-- @作者: Night_Walker
-- @邮箱:  1076438225@qq.com
-- @创建时间:   2017-07-18 16:39:54
-- @最后修改来自: Night_Walker
-- @Last Modified time: 2017-07-27 00:34:18


AniPack = class()


function AniPack:init() --initialize

	self.pos = {x = 0, y = 0}
	self.center = {x = 0, y = 0}
	self.size = {w = 1, h = 1}

	self.playingSprite = 0 	-- 当前正在播放的帧图片
	self.playNum = 1 	-- 播放次数

	self.frameDataGrp = {} 	-- 帧数据组 包含多个ani的帧数据
	self.frameData = {} -- 从"*.ani.lua"文件中读取出的帧数据
	self.frameHead = "[FRAME000]" -- 每一帧的开头帧号

	if (not ImageNull) then
	    ImageNull = love.image.newImageData(1, 1)
	end
	self.playingSprite = ImageNull

	self.count = 0
	self.time = 0

	self.box = Rect.new(0,0,1,1)
	self.CurrentBox = Rect.new(0,0,1,1)

	self.focus = {
		["focus"] = false,
		["max"] = 220,
		["min"] = 80,
		["dir"] = -1,
		["speed"] = 240,
		["ARGB"] = {["A"] = 200,["R"] = 0,["G"] = 255,["B"] = 0}
	}

end


function AniPack:update(dt)
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

		local img = ResPack2.new(self.frameData[self.frameHead]["[IMAGE]"][1])
		if not img then
			print("Error:AniPack: (update)load imgPack failed. " )
			return self
		end

		-- self.spr:置纹理(img:取纹理(self.frameData[self.frameHead]["[IMAGE]"][2]+1))
		self.playingSprite = img:getTexture(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
		self.offset = img:getOffset(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
	else
		self.playingSprite = ImageNull
	end



	self:setcenter(self.frameData[self.frameHead]["[IMAGE POS]"][1],self.frameData[self.frameHead]["[IMAGE POS]"][2])

	if self.num > 1 then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
			if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
				-- self.spr:置混合(2)
				self:setBlendMode(2)
			end
		end

		if self.frameData[self.frameHead]["[RGBA]"] then
			self:setColor(ARGB(self.frameData[self.frameHead]["[RGBA]"][1],
				self.frameData[self.frameHead]["[RGBA]"][2],
				self.frameData[self.frameHead]["[RGBA]"][3],
				self.frameData[self.frameHead]["[RGBA]"][4]))
		end
	end

end

function AniPack:draw(x,y,r,w,h)

	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.size.w = w or self.size.w
	self.size.h = h or self.size.h


	if self.focus["focus"]  then --聚焦 即霸体状态下的外线效果

		self.focus["ARGB"]["A"]  = self.focus["ARGB"]["A"]   + self.focus["dir"] * self.focus["speed"] * 引擎.取帧时间()
		if self.focus["ARGB"]["A"]  >= self.focus["max"] or
			self.focus["ARGB"]["A"] <= self.focus["min"] then

			self.focus["dir"] = -self.focus["dir"]
		end
		self:setColor(ARGB(self.focus["ARGB"]["A"] ,self.focus["ARGB"]["R"],self.focus["ARGB"]["G"],self.focus["ARGB"]["B"]))

		self.spr:显示(
			math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) - 1,
			math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)-1,
			r or 0,
			self.size.w,
			self.size.h)

		self.spr:显示(math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) + 1,math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)-1,
			r or 0,
			self.size.w,
			self.size.h)

		self.spr:显示(math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) + 1,
			math.floor(self.pos.y - self.center.y * self.size.h + self.offset.y * self.size.h)+1,
			r or 0,
			self.size.w,
			self.size.h)

		self.spr:显示(math.floor(self.pos.x - self.center.x * self.size.w + self.offset.x * self.size.w) - 1,
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


	self.CurrentRect:setPos(self.pos.x,self.pos.y)

	local tmp_width = self.playing_sprite:getWidth()
	local tmp_height = self.playing_sprite:getHeight()

	self.CurrentRect:setSize(tmp_width,tmp_height)
	self.CurrentRect:draw()

end

function AniPack:setAnimation(id,__num)

	if (type(id) ~= "string") then
	    print("Warning! AniPack:setAnimation()--the type of id must be string ")
	    return
	end

	self.frameData = self.frameDataGrp[id].data -- 获取ani帧数据
	self.playNum = self.frameDataGrp[id].__num or 1  -- 获取播放次数

	self.count = 0
	self.time = 0
	self.num = self.frameData["[FRAME MAX]"]

	if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
			-- self.spr:置混合(2)
			self:setBlendMode(2) -- Alpha线性渐变混合 Alpha.one
		end
	end

	if self.frameData[self.frameHead]["[RGBA]"] then
		self:setColor(self.frameData[self.frameHead]["[RGBA]"][1],
			self.frameData[self.frameHead]["[RGBA]"][2],
			self.frameData[self.frameHead]["[RGBA]"][3],
			self.frameData[self.frameHead]["[RGBA]"][4])
	end

end

function AniPack:addAnimation(aniPath,__num,id)
	-- aniPath	ani文件的路径
	-- __num	播放次数
	-- id		ani的对应动作(状态)名称

	local content = require(aniPath) -- 加载返回ani的table数据
	sellf.frameDataGrp[id] = {data = content, num = __num}

end

function AniPack:setcenter(x,y)
	self.center.x = x or self.center.x
	self.center.y = y or self.center.y
end

function AniPack:setColor(r,g,b,a)
	self.color = {r = r, g = g, b = b, a = a }
end

function AniPack:setBlendMode(mode)
	-- statements
end

return AniPack
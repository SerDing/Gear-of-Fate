--[[
	Desc: Animation Pack class
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 23:36:07
	Docs:
		* This class can add many *.ani files by using :AddAnimation(path)
		* using :SetAnimation() to switch the class to objective state animation
]]


local _AniPack = require("Src.Core.Class")()

local _KEYBOARD = require "Src.Core.KeyBoard" 
local _Sprite = require "Src.Core.Sprite"
local _ResPack = require "Src.ResPack"
local _RESMGR = require "Src.ResManager"
local _Rect = require "Src.Core.Rect"

function _AniPack:Ctor(_type) --initialize

	self.type = _type or "NORMAL_ANI"
	self.pos = {x = 0, y = 0}
	self.center = {x = 0, y = 0}
	self.offset = {x = 0, y = 0}
	self.scale = {x = 1, y = 1}
	self.angle = 0
	self.dir = 1 -- direction

	self.playNum = 1 	-- 播放次数
	self.fileNum = 0000

	self.frameDataGrp = {} 	-- 帧数据组 包含多个ani数据
	self.frameData = {} -- 从ani文件中读取出的帧数据
	self.frameHead = "[FRAME000]" -- 每一帧的开头帧号

	self.aniId = "" -- example: attack1 upperslash sit ...

	if not _RESMGR.imageNull then
		local _tmpImageData = love.image.newImageData(1, 1)
	    _RESMGR.imageNull = love.graphics.newImage(_tmpImageData)
	end
	self.playingSprite = _Sprite.New(_RESMGR.imageNull)

	self.count = 0
	self.time = 0

	self.updateCount = 0

	self.baseRate = 1

	self.box = _Rect.New(0,0,1,1)

	self.focus = {
		["focus"] = false,
		["max"] = 220,
		["min"] = 80,
		["dir"] = -1,
		["speed"] = 240,
		["ARGB"] = {["A"] = 200,["R"] = 0,["G"] = 255,["B"] = 0}
	}

	self.filter = false

	self.debug = false

	self.plusOffset = true

	self.blendModeList = {
		[1] = "add", -- The pixel colors of what's drawn are added to the pixel colors already on the screen. The alpha of the screen is not modified.
		[2] = "alpha", -- Alpha blending (normal). The alpha of what's drawn determines its opacity.
		[3] = "replace", -- The colors of what's drawn completely replace what was on the screen, with no additional blending. The BlendAlphaMode specified in love.graphics.setBlendMode still affects what happens.
		[4] = "screen", -- 'Screen' blending.
		[5] = "subtrac", -- The pixel colors of what's drawn are subtracted from the pixel colors already on the screen. The alpha of the screen is not modified.
		[6] = "multiply", -- The pixel colors of what's drawn are multiplied with the pixel colors already on the screen (darkening them). The alpha of drawn objects is multiplied with the alpha of the screen rather than determining how much the colors on the screen are affected, even when the "alphamultiply" BlendAlphaMode is used.
		[7] = "lighten", -- The pixel colors of what's drawn are compared to the existing pixel colors, and the larger of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
		[8] = "darken", -- The pixel colors of what's drawn are compared to the existing pixel colors, and the smaller of the two values for each color component is used. Only works when the "premultiplied" BlendAlphaMode is used in love.graphics.setBlendMode.
		
	}

	self.blendMode = self.blendModeList[1]
 
end

function _AniPack:NextFrame()
	if self.playNum == 0 then
		return
	end
	if self.count == self.num-1 then
		if self.playNum > 1 then
			self.playNum = self.playNum
		end
		self.count = 0
	else
		self.count = self.count + 1
		self.time = 0
	end
end

function _AniPack:Update(dt)

	--[[ Debug Switch ]]
	if _KEYBOARD.Press("f1") then
		if self.debug then
			self.debug = false
		else 
			self.debug = true
		end 
	end 

	--[[
		When the aniData just has one frame 
		and this class has updata one time 
		then doesn't update any more
	]]
	
	if self.type == "MAP_ANI_BLOCK" then
		if self.num <= 1 then 
			if self.updateCount >= 1 then
				return 0
			end 
		end 	
	end


	self.frameHead = string.format("[FRAME%03d]", self.count)

	if not  self.frameHead then
		print("Error:_AniPack:Update() --> frameHead is null")
		return self
	end

	self.time = self.time + (dt or 0)

	-- print("self.time:" .. tostring(self.time))

	if self.time >= (self.frameData[self.frameHead]["[DELAY]"] or 100) / (1000 * self.baseRate)  then
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
		--local img = require "sys/img"(string.format("playingSpriteite/"..self.frameData[self.frameHead]["[IMAGE]"][1], self.str))
		local tmpStr = string.format(string.lower(self.frameData[self.frameHead]["[IMAGE]"][1]),self.fileNum)
		
		local img = _ResPack.New(_RESMGR.pathHead .. tmpStr)
		
		if not img then
			print("Error:_AniPack:Update() --> load imgPack failed. " )
			print("    " .. self.frameData[self.frameHead]["[IMAGE]"][1])
			return self
		end

		self.playingSprite:SetTexture(img:GetTexture(self.frameData[self.frameHead]["[IMAGE]"][2]+1))
		self.offset = img:GetOffset(self.frameData[self.frameHead]["[IMAGE]"][2]+1)
		
		img = nil
	else
		self.playingSprite:SetTexture( _RESMGR.imageNull)
	end

	self:SetCenter(-self.frameData[self.frameHead]["[IMAGE POS]"][1],-self.frameData[self.frameHead]["[IMAGE POS]"][2])

	if self.num > 1 then
		if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
			if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] =="lineardodge" then
				-- self:SetBlendMode(1)
				self.playingSprite:SetFilter(self.filter)
			end
		end

		if self.frameData[self.frameHead]["[RGBA]"] then
			self:SetColor(self.frameData[self.frameHead]["[RGBA]"][1],
				self.frameData[self.frameHead]["[RGBA]"][2],
				self.frameData[self.frameHead]["[RGBA]"][3],
				self.frameData[self.frameHead]["[RGBA]"][4])
		end
	end

	self.updateCount = self.updateCount + 1

end

function _AniPack:Draw(x,y,r,sx,sy)
	
	if x and y then
		self:SetPos(x, y)
	end

	if sx and sy then
		self:SetScale(sx, sy)
	end
	
	if r then
		self:SetAngle(r)
	end

	if self.focus["focus"]  then --霸体状态下的外线效果

		self.focus["ARGB"]["A"]  = self.focus["ARGB"]["A"]   + self.focus["dir"] * self.focus["speed"] * 引擎.取帧时间()
		if self.focus["ARGB"]["A"]  >= self.focus["max"] or
			self.focus["ARGB"]["A"] <= self.focus["min"] then

			self.focus["dir"] = -self.focus["dir"]
		end
		self:SetColor(
			self.focus["ARGB"]["R"],
			self.focus["ARGB"]["G"],
			self.focus["ARGB"]["B"],
			self.focus["ARGB"]["A"])

		self.playingSprite:SetCenter(self.center.x,self.center.y)
		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x * self.dir ) - 1,
			math.floor(self.pos.y + self.offset.y ) - 1,
			self.angle,
			self.scale.x * self.dir,
			self.scale.y)

		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x * self.dir ) + 1,
			math.floor(self.pos.y + self.offset.y ) - 1,
			self.angle,
			self.scale.x * self.dir,
			self.scale.y)

		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x * self.dir ) + 1,
			math.floor(self.pos.y + self.offset.y ) + 1,
			self.angle,
			self.scale.x * self.dir,
			self.scale.y)

		self.playingSprite:Draw(
			math.floor(self.pos.x + self.offset.x * self.dir ) - 1,
			math.floor(self.pos.y + self.offset.y ) + 1,
			self.angle,
			self.scale.x * self.dir,
			self.scale.y)
	end
	
	self.playingSprite:SetCenter(self.center.x,self.center.y)
	self.playingSprite:Draw(
		self.pos.x + self.offset.x * self.dir,
		self.pos.y + self.offset.y,
		self.angle or 0, 		-- rotation 旋转参数
		self.scale.x * self.dir,
		self.scale.y
	)
	
	if self.debug then
		self:DrawBox()
		self.playingSprite.rect:Draw()
	end 
	
	
end

function _AniPack:DrawBox()
	local boxTab = self.frameData[self.frameHead]["[ATTACK BOX]"]
	local atkBox = _Rect.New(0,0,1,1)
	atkBox:SetColor(255,0,180,150)
	if boxTab then
	    for n=1,#boxTab,6 do
			atkBox:SetPos(self.pos.x + boxTab[n] * self.dir,self.pos.y + - boxTab[n+2])
			atkBox:SetSize(boxTab[n+3] * self.scale.x, - boxTab[n+5] * self.scale.y)
			atkBox:SetDir(self.dir)
			atkBox:Draw()
	    end
	end

	local boxTab = self.frameData[self.frameHead]["[DAMAGE BOX]"]
	local dmgBox = _Rect.New(0,0,1,1)
	dmgBox:SetColor(0,255,0,100)
	if boxTab then
	    for n=1,#boxTab,6 do
			dmgBox:SetPos(self.pos.x + boxTab[n] * self.dir,self.pos.y + - boxTab[n+2])
			dmgBox:SetSize(boxTab[n+3] * self.scale.x,-boxTab[n+5] * self.scale.y)
			dmgBox:SetDir(self.dir)
			dmgBox:Draw()
	    end
	end
end

function _AniPack:GetAttackBox()
	return self.frameData[self.frameHead]["[ATTACK BOX]"] or nil
end

function _AniPack:GetDamageBox()
	return self.frameData[self.frameHead]["[DAMAGE BOX]"] or nil
end

function _AniPack:SetAnimation(id,num,rate)

	local _idType = type(id)

	if _idType == "string" then
	    if not self.frameDataGrp[id] then
			print(
				"Err:_AniPack:SetAnimation() -- cannot find ani：" .. 
				id .. 
				"in frameDataGrp"
			)
			return false 
		else 
			self.frameData = self.frameDataGrp[id].data
			self.playNum = self.frameDataGrp[id].num or 1
			self.aniId = id
		end
	elseif _idType == "table" then
		self.frameData = id
		self.playNum = num or -1
	else 
		error("Err:_AniPack:SetAnimation() -- id type is wrong")
		return false 
	end

	
	self.count = 0
	self.time = 0
	self.num = self.frameData["[FRAME MAX]"]

	self:Update(0)
	self.frameHead = string.format("[FRAME%03d]", self.count)
	
	if self.frameData[self.frameHead]["[GRAPHIC EFFECT]"] then
		if string.lower(self.frameData[self.frameHead]["[GRAPHIC EFFECT]"]) =="lineardodge" then
			self:SetBlendMode(1)
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
	
	if type(aniPath) == "string" then
		local content = require(aniPath) -- content is a table
		self.frameDataGrp[id] = {data = content, num = __num}
		
		if content["[LOOP]"] == 1 then
			self.frameDataGrp[id].num = -1
		else
			self.frameDataGrp[id].num = 1
		end

	elseif type(aniPath) == "table" then
	    print("Err: _AniPack:AddAnimation() --> aniPath expect a string ,not a table.")
	    return false
	else
	    print("Err: _AniPack:AddAnimation() --> aniPath get a unexpected type!")
	    return false
	end
end

function _AniPack:SetPos(x, y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.playingSprite:SetPos(
		self.pos.x + self.offset.x * self.dir,
		self.pos.y + self.offset.y
	)
end

function _AniPack:SetScale(x, y)
	self.scale.x = x or self.scale.x
	self.scale.y = y or self.scale.y
	self.playingSprite:SetScale(x, y)
end

function _AniPack:SetAngle(r)
	self.angle = r or self.angle
	self.playingSprite:SetAngle(r)
end

function _AniPack:SetPlayNum(id,num)
	-- id	ani的对应动作(状态)名称
	-- num	播放次数

	if type(id) == "string" then
		self.frameDataGrp[id].num = num
	elseif type(id) == "number" then
		print("Err:_AniPack:SetPlayNum() --> id expected a string not number!")
	else 
		print("Err:_AniPack:SetPlayNum() --> id get a unexpected type")
	end 
	
end

function _AniPack:SetCurrentPlayNum(num)
	-- num	播放次数
	self.playNum = num
end

function _AniPack:SetFrame(num)
	-- num	指定帧数
	self.count = num
end

function _AniPack:SetBaseRate(baseRate)
	self.baseRate = baseRate
end

function _AniPack:SetCenter(x,y)
	self.center.x = x or self.center.x
	self.center.y = y or self.center.y
end

function _AniPack:SetColor(r,g,b,a)
	self.color = {r = r, g = g, b = b, a = a }
	self.playingSprite:SetColor(r,g,b,a)
end

function _AniPack:SetBlendMode(modeNum)
	self.blendMode = self.blendModeList[modeNum]
	self.playingSprite:SetBlendMode(self.blendMode)
end

function _AniPack:SetFilter(switch)
	self.filter = switch or false
end

function _AniPack:SetFileNum(num)
	self.fileNum = num
	-- print("fileNum changed :" .. tostring(self.fileNum))
end

function _AniPack:SetDir(dir)
	self.dir = dir
end

function _AniPack:GetCount()
	return self.count or 0 
end

function _AniPack:GetAniId()
	return self.aniId or "" 
end

function _AniPack:GetRect()
	return self.playingSprite:GetRect()
end

function _AniPack:GetScale()
	return self.scale
end

function _AniPack:GetWidth()
	return self.playingSprite:GetWidth()
end

function _AniPack:GetHeight()
	return self.playingSprite:GetHeight()
end

function _AniPack:GetCurrentPlayNum()
	return self.playNum
end

function _AniPack:GetCountTime()
	return self.time
end

function _AniPack:GetSpriteBox()
	return self.box
end

function _AniPack:Destroy()
	
	self.pos = nil
	self.center = nil
	self.offset = nil
	self.dir = nil
	
	self.playNum = nil
	self.fileNum = nil
	
	self.frameDataGrp = nil
	self.frameData = nil
	self.frameHead = nil
	
	self.playingSprite:Destroy()
	
	self.count = nil
	self.time = nil
	
	self.updateCount = nil
	
	self.box:Destroy()
	
	self.focus = nil
	
	self.filter = nil
	
	self.debug = nil
	
	self.blendModeList = nil
	
	self.blendMode = nil

	_AniPack = nil
end

return _AniPack
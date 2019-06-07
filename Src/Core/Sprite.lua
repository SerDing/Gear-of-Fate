--[[
	Desc: A simple sprite class
 	Author: Night_Walker
	Since: 2017-07-26 23:41:15
	Alter: 2017-07-31 22:57:40
	Docs:
		* when do Ctor() you should give it a null texture or a file path
]]


local _Sprite = require("Src.Core.Class")()

local _Rect = require "Src.Core.Rect"
local _RESMGR = require "Src.Resource.ResManager" 
local _GameCamera = require "Src.Game.GameCamera"

local _Scissor = love.graphics.setScissor
local _GraphNewShader = love.graphics.newShader
local _GraphSetShader = love.graphics.setShader

local _spriteCount = 0

function _Sprite:Ctor(path, x, y, w, h) --initialize

	local tp = type(path)

	if tp == "string" then
	    self.texture = _RESMGR.LoadTexture(path)
	else -- path为空纹理时
	   self.texture = path
	end

	self.rect = _Rect.New(x,y,w,h)

	self.x = x or 0
	self.y = y or 0
	self.size = {}
	self.center = {}
	self.pos = {x = x, y = y}
	self.scale = {x = 1, y = 1}
	self.size.w = w or 1
	self.size.h = h or 1
	self.center.x = 0
	self.center.y = 0
	self.angle = 0
	self.color = {r = 255, g = 255, b = 255, a = 255}
	self.blendMode = "alpha"
	self.shader = nil

	local tWidth = self.texture:getWidth()
	local tHeight = self.texture:getHeight()
	self.area = {x = 0, y = 0, w = tWidth, h = tHeight}
	self.scissor = false
	self.rect:SetSize(tWidth,tHeight)
	self.rect:SetColor(0,0,255,50)
	
	_spriteCount = _spriteCount + 1

	-- print("_spriteCount = ", _spriteCount)

end

function _Sprite:Draw(x, y, rotation, sx, sy)

	if x and y then self:SetPos(x, y) end
	if rotation then self:SetAngle(rotation) end
	if sx and sy then self:SetScale(sx, sy) end

	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)

	local _blendMode = love.graphics.getBlendMode()
	love.graphics.setBlendMode(self.blendMode)
	
	if self.scissor then
		_Scissor(
			self.pos.x * _GameCamera.scale.x - self.center.x * self.scale.x + self.area.cam_x, 
			self.pos.y * _GameCamera.scale.y - self.center.y * self.scale.y + self.area.cam_y, 
			self.area.w * _GameCamera.scale.x, 
			self.area.h * _GameCamera.scale.y
		)
	end

	love.graphics.draw(self.texture,
		self.pos.x - self.area.x,
		self.pos.y - self.area.y,
		self.angle,
		self.size.w * self.scale.x, -- 
		self.size.h * self.scale.y,
		self.center.x,
		self.center.y
	)

	if self.scissor then
		_Scissor()
	end

	love.graphics.setColor(r, g, b, a)
	love.graphics.setBlendMode(_blendMode)

	self.rect:SetPos(self.pos.x,self.pos.y)

	-- self.rect:Draw()

end

function _Sprite:SetTexture(tex)

	if not tex then
	    print("Error:_Sprite:SetTexture() --> tex get nil")
	    return
	else
		self.texture = tex
	end

	self.rect:SetSize(self.texture:getWidth(), self.texture:getHeight())
end

function _Sprite:SetPos(x, y)
	self.pos.x = x or self.pos.x
	self.pos.y = y or self.pos.y
	self.rect:SetPos(x, y)
end

function _Sprite:SetSize(w, h)
	self.size.w = sx or self.size.w
	self.size.h = sy or self.size.h
	self.rect:SetSize(sx, sy)
end

function _Sprite:SetScale(x, y)
	self.scale.x = x or self.scale.x
	self.scale.y = y or self.scale.y
	self.rect:SetScale(x, y)
end

function _Sprite:SetDir(dir)
	-- self.rect:SetDir(dir)
end

function _Sprite:SetAngle(r)
	self.angle = r or self.angle
end

function _Sprite:SetCenter(x, y)
	self.center.x = x or 0
	self.center.y = y or 0
	self.rect:SetCenter(x,y)
end

function _Sprite:SetDrawArea(x, y, w, h, cam_x, cam_y)
	self.area.x = x or 0
    self.area.y = y or 0
    self.area.w = w or 0
	self.area.h = h or 0
	self.area.cam_x = cam_x or 0
	self.area.cam_y = cam_y or 0
	self.scissor = true
end

function _Sprite:SetColor(r, g, b, a)
	self.color.r = r
	self.color.g = g
	self.color.b = b
	self.color.a = a
end

function _Sprite:SetColorEx(r, g, b, a)
	local imagedata = self.texture:getData()
	local w = imagedata:getWidth()
	local h = imagedata:getHeight()
	function replacePixel(x, y)
		return r,g,b,a
	end
	imagedata:mapPixel(replacePixel)
	self.texture:refresh()
	--[[  mapPixel() protoType
		for x = 0, w - 1 do
			for y = 0, h - 1 do
				local _r,_g,_b,_a = imagedata:getPixel(x, y)
				-- print("x, y, a", x, y, _a)
				if _a > 0 then
					imagedata:setPixel(x, y, r, g, b, a) -- set color of pixel to white
				end		
			end
		end
	]]
end

---Turn on or off nearest filter of the sprite
---@param bool switch
function _Sprite:SetFilter(switch)
	if switch then
		self.texture:setFilter( "linear", "nearest" )
	end 
end

function _Sprite:SetBlendMode(mode)
	self.blendMode = mode 
end

function _Sprite:GetTexture()
	return self.texture
end

function _Sprite:GetRect()
	return self.rect
end

function _Sprite:GetWidth()
	return self.texture:getWidth()
end

function _Sprite:GetHeight()
	return self.texture:getHeight()
end

function _Sprite:Destroy()
	
	self.texture = nil
		
	self.rect:Destroy()

	self.x = nil
	self.y = nil
	self.size = nil
	self.center = nil
	self.pos = nil
	self.color = nil
	self.blendMode = nil

	_Sprite = nil

end

return _Sprite
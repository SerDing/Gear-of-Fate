--[[
	Desc: animation object
 	Author: Night_Walker
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
	Docs:
		* 
]]

---@class AnimObj:GameObject

local _obj = require "Src.Objects.GameObject"
local _AnimObj = require("Src.Core.Class")(_obj)

local _RESMGR = require "Src.Resource.ResManager" 
local _Animation = require "Src.Engine.Animation.Animation"

function _AnimObj:Ctor(aniPath, layer)
	_obj.Ctor(self)
	self.pos = {x = 0, y = 0}
	self.animation = _Animation.New(_RESMGR.LoadDataFile(aniPath))
	self.animation:Play()
	self.layer = layer or "[closeback]"
end

function _AnimObj:Update(dt)
	self.animation:Update(dt)
end 

function _AnimObj:Draw()
	self.animation:Draw(math.floor(self.pos.x), math.floor(self.pos.y))
	if self.layer == "[normal]" then
		if GDebug then
			love.graphics.points(self.pos.x, self.pos.y)
		end
	end
end

function _AnimObj:GetY()
	return  self.pos.y
end

return _AnimObj
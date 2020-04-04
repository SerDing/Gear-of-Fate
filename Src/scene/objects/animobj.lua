--[[
	Desc: animation object
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]

---@class AnimObj:GameObject

local _obj = require "entity.gameobject"
local _AnimObj = require("core.class")(_obj)

local _RESMGR = require "system.resource.resmgr"
local _Animator = require("engine.animation.frameani")

function _AnimObj:Ctor(aniPath, layer)
	_obj.Ctor(self)
	self.position = {x = 0, y = 0}
	self.animation = _Animator.New()
	self.animation:Play(_RESMGR.LoadDataFile(aniPath))
	self.layer = layer or "[closeback]"
end

function _AnimObj:Update(dt)
	self.animation:Update(dt)
	self.animation.sprite:SetRenderValue("position", self.position.x, self.position.y)
end 

function _AnimObj:Draw()
	self.animation:Draw(math.floor(self.position.x), math.floor(self.position.y), 0, 1, 1)
end

return _AnimObj
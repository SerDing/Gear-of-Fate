--[[
	Desc: Drawable base
 	Author: SerDing
	Since: 2020-02-09
	Alter: 2020-02-09
]]

local _Vector3 = require("utils.vector3")
local _Vector2 = require("utils.vector2")
local _Event = require("core.event")
local _GRAPHICS = require("engine.graphics.graphics")
local _Blendmode = require("engine.graphics.config.blendmode")
local _Color = require("engine.graphics.config.color")
local _Shader = require("engine.graphics.config.shader")
local _Radian = require("engine.graphics.config.radian") 

---@class Engine.Graphics.Drawable.Base
---@field protected _quad Quad
---@field protected _children table<number, Engine.Graphics.Drawable.Base>
---@field public order number
local _Drawable = require("core.class")()

local _eventNotifyMap = {
	position = "setPosition",
	scale = "setScale",
	origin = "setOrigin"
}

function _Drawable:Ctor()
	self._baseValues = { -- basic render values
		position = _Vector3.New(0, 0, 0),
		radian = _Radian.New(),
		scale = _Vector2.New(1, 1),
		origin = _Vector2.New(0, 0),
		blendmode = _Blendmode.New(),
		color = _Color.White(),
		shader = _Shader.New(),
	}
	self._upperValues = {}
	self._actualValues = {
		position = _Vector3.New(0, 0, 0),
		radian = _Radian.New(),
		scale = _Vector2.New(1, 1),
		origin = self._baseValues.origin,
		blendmode = self._baseValues.blendmode,
		color = _Color.White(),
		shader = self._baseValues.shader,
	}
	self._values = { -- simplified basic render values
		x = 0,
		y = 0,
		r = 0,
		sx = 1,
		sy = 1,
		ox = 0,
		oy = 0
	}
	self.eventMap = {
		setPosition = _Event.New(),
		setScale = _Event.New(),
		setOrigin = _Event.New(),
	}
	self._quad = nil 
	self._children = {}
	self.order = 0
end

function _Drawable:Apply()
	self._actualValues.color:Apply()
	self._actualValues.blendmode:Apply()
	self._actualValues.shader:Apply()
end

function _Drawable:Draw()
	_Drawable.Apply(self)
	self:_OnDraw()
	_Drawable.Reset(self)
end

function _Drawable:Reset()
	-- self._actualValues.color:Reset()
	-- self._actualValues.blendmode:Reset()
	-- self._actualValues.shader:Reset()
	if self._upperValues.color then
		self._upperValues.color:Apply()
	end
	if self._upperValues.blendmode then
		self._upperValues.blendmode:Apply()
	end
	if self._upperValues.shader then
		self._upperValues.shader:Apply()
	end
end

function _Drawable:DrawObj(obj)
	local v = self._values
	if self._quad then
		_GRAPHICS.Draw(obj, self._quad, v.x, v.y, v.r, v.sx, v.sy, v.ox, v.oy)
	else
		_GRAPHICS.Draw(obj, v.x, v.y, v.r, v.sx, v.sy, v.ox, v.oy)
	end
end

function _Drawable:_OnDraw()
end

---@param type string
---@param ... any
function _Drawable:SetRenderValue(type, ...)
	self._baseValues[type]:Set(...)
	self:Merge(type)
	self:RefreshValues(type)
	for i=1,#self._children do
		self._children[i]:SetUpperValue(type, self._actualValues[type])
	end

	local eventKey = _eventNotifyMap[type]
	if eventKey then
		self.eventMap[eventKey]:Notify()
	end
end

local function _NewValueObj(type, ...)
	local _newValuefns = {
		position = function ()
			return _Vector3.New(0, 0, 0)
		end,
		radian = function ()
			return _Radian.New(0)
		end,
		scale = function ()
			return _Vector2.New(1, 1)
		end,
		origin = function ()
			return _Vector2.New(0, 0)
		end,
		blendmode = function ()
			return _Blendmode.New()
		end,
		color = function ()
			return _Color.White()
		end,
		shader = function ()
			return _Shader.New()
		end
	}
	return _newValuefns[type]()
end

function _Drawable:SetUpperValue(type, value)
	self._upperValues[type] = value
	self:Merge(type)
	self:RefreshValues(type)
	for i=1,#self._children do
		self._children[i]:SetUpperValue(type, self._actualValues[type])
	end

	local eventKey = _eventNotifyMap[type]
	if eventKey then
		self.eventMap[eventKey]:Notify()
	end
end

function _Drawable:Merge(type)
	-- local memory = collectgarbage("count")
	local _mergeFuncs = {
		position = function ()
			if self._upperValues.position then
				local bx, by, bz = self._baseValues.position:Get()
				local ux, uy, uz = self._upperValues.position:Get()
				self._actualValues.position:Set(bx + ux, by + uy, bz + uz)
			else
				self._actualValues.position:Set(self._baseValues.position:Get())
			end
		end, 
		radian = function ()
			if self._upperValues.radian then
				self._actualValues.radian:Set(self._baseValues.radian:Get(true) + self._upperValues.radian:Get(true))
			else
				self._actualValues.radian:Set(self._baseValues.radian:Get(true))
			end
		end, 
		scale = function ()
			if self._upperValues.scale then
				local bx, by = self._baseValues.scale:Get()
				local ux, uy = self._upperValues.scale:Get()
				self._actualValues.scale:Set(bx * ux, by * uy)
			else
				self._actualValues.scale:Set(self._baseValues.scale:Get())
			end
		end, 
		origin = function ()
			if self._upperValues.origin then
				local bx, by = self._baseValues.origin:Get()
				local ux, uy = self._upperValues.origin:Get()
				self._actualValues.origin:Set(bx + ux, by + uy)
			else
				self._actualValues.origin:Set(self._baseValues.origin:Get())
			end
		end, 
		blendmode = function ()
			self._actualValues.blendmode = self._baseValues.blendmode
		end, 
		color = function ()
			if self._upperValues.color then
				local br, bg, bb, ba = self._baseValues.color:Get()
				local ur, ug, ub, ua = self._upperValues.color:Get()
				self._actualValues.color:Set(br * ur / 255, bg * ug / 255, bb * ub / 255, ba * ua / 255)
			else
				self._actualValues.color:Set(self._baseValues.color:Get())
			end
		end, 
		shader = function ()
			self._actualValues.shader = self._baseValues.shader
		end, 
	}
	-- memory = collectgarbage("count") - memory
	-- print("merge fns memory:", memory)
	_mergeFuncs[type](self)
end

function _Drawable:RefreshValues(type)
	local _refreshFuncs = {
		position = function()
			self._values.x = self._actualValues.position.x
			self._values.y = self._actualValues.position.y + self._actualValues.position.z
		end,
		radian = function()
			self._values.r = self._actualValues.radian:Get()
		end,
		scale = function()
			self._values.sx = self._actualValues.scale.x
			self._values.sy = self._actualValues.scale.y
		end,
		origin = function()
			self._values.ox = self._baseValues.origin.x
			self._values.oy = self._baseValues.origin.y
		end
	}
	if _refreshFuncs[type] then
		_refreshFuncs[type](self)
	end
end

function _Drawable:GetRenderValue(type)
	return self._actualValues[type]:Get()
end

function _Drawable:SetQuad(quad)
	self._quad = quad
end

function _Drawable:AddChild(child)
	self._children[#self._children + 1] = child
end

return _Drawable
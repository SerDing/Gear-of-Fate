--[[
	Desc: Drawable base (high-layer)
 	Author: SerDing
	Since: 2020-02-09
	Alter: 2020-02-09
]]

local _Vector3 = require("utils.vector3")
local _Vector2 = require("utils.vector2")
local _Event = require("core.event")
local _GRAPHICS = require("engine.graphics")
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

function _Drawable:Draw(...)
	_Drawable.Apply(self)
	self._OnDraw(self, ...)
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

--- draw an object of love2d drawable type
---@param obj Drawable
function _Drawable:DrawObj(obj)
	local v = self._values
	if self._quad then
		_GRAPHICS.Draw(obj, self._quad, v.x, v.y, v.r, v.sx, v.sy, v.ox, v.oy)
	else
		_GRAPHICS.Draw(obj, v.x, v.y, v.r, v.sx, v.sy, v.ox, v.oy)
	end
end

function _Drawable:_OnDraw(...)
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

---@param type string
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

---@param type string
---@param value table
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

---@param type string
function _Drawable:Merge(type)
	local mergeFuncs = {
		---@param obj Engine.Graphics.Drawable.Base
		position = function (obj)
			if obj._upperValues.position then
				local bx, by, bz = obj._baseValues.position:Get()
				local ux, uy, uz = obj._upperValues.position:Get()
				obj._actualValues.position:Set(bx + ux, by + uy, bz + uz)
			else
				obj._actualValues.position:Set(obj._baseValues.position:Get())
			end
		end, 
		---@param obj Engine.Graphics.Drawable.Base
		radian = function (obj)
			if obj._upperValues.radian then
				obj._actualValues.radian:Set(obj._baseValues.radian:Get(true) + obj._upperValues.radian:Get(true))
			else
				obj._actualValues.radian:Set(obj._baseValues.radian:Get(true))
			end
		end, 
		---@param obj Engine.Graphics.Drawable.Base
		scale = function (obj)
			if obj._upperValues.scale then
				local bx, by = obj._baseValues.scale:Get()
				local ux, uy = obj._upperValues.scale:Get()
				obj._actualValues.scale:Set(bx * ux, by * uy)
			else
				obj._actualValues.scale:Set(obj._baseValues.scale:Get())
			end
		end, 
		---@param obj Engine.Graphics.Drawable.Base
		origin = function (obj)
			if obj._upperValues.origin then
				local bx, by = obj._baseValues.origin:Get()
				local ux, uy = obj._upperValues.origin:Get()
				obj._actualValues.origin:Set(bx + ux, by + uy)
			else
				obj._actualValues.origin:Set(obj._baseValues.origin:Get())
			end
		end, 
		---@param obj Engine.Graphics.Drawable.Base
		blendmode = function (obj)
			obj._actualValues.blendmode = obj._baseValues.blendmode
		end, 
		---@param obj Engine.Graphics.Drawable.Base
		color = function (obj)
			if obj._upperValues.color then
				local br, bg, bb, ba = obj._baseValues.color:Get()
				local ur, ug, ub, ua = obj._upperValues.color:Get()
				obj._actualValues.color:Set(br * ur / 255, bg * ug / 255, bb * ub / 255, ba * ua / 255)
			else
				obj._actualValues.color:Set(obj._baseValues.color:Get())
			end
		end, 
		---@param obj Engine.Graphics.Drawable.Base
		shader = function (obj)
			obj._actualValues.shader = obj._baseValues.shader
		end, 
	}
	mergeFuncs[type](self)
end

---@param type string
function _Drawable:RefreshValues(type)
	local refreshFuncs = {
		---@param obj Engine.Graphics.Drawable.Base
		position = function(obj)
			obj._values.x = obj._actualValues.position.x
			obj._values.y = obj._actualValues.position.y + obj._actualValues.position.z
		end,
		---@param obj Engine.Graphics.Drawable.Base
		radian = function(obj)
			obj._values.r = obj._actualValues.radian:Get()
		end,
		---@param obj Engine.Graphics.Drawable.Base
		scale = function(obj)
			obj._values.sx = obj._actualValues.scale.x
			obj._values.sy = obj._actualValues.scale.y
		end,
		---@param obj Engine.Graphics.Drawable.Base
		origin = function(obj)
			obj._values.ox = obj._baseValues.origin.x
			obj._values.oy = obj._baseValues.origin.y
		end
	}
	if refreshFuncs[type] then
		refreshFuncs[type](self)
	end
end

---@param type string
---@param relative boolean
function _Drawable:GetRenderValue(type, relative)
	if relative then
		return self._baseValues[type]:Get()
	else
		return self._actualValues[type]:Get()
	end
end

---@param quad Quad
function _Drawable:SetQuad(quad)
	self._quad = quad
end

---@param parentObj Engine.Graphics.Drawable.Base
function _Drawable:SetParent(parentObj)
	for key, _ in pairs(self._baseValues) do
		self:SetUpperValue(key, parentObj._actualValues[key])
	end
end

---@param child Engine.Graphics.Drawable.Base
function _Drawable:AddChild(child)
	self._children[#self._children + 1] = child
end

---@param index int
---@return Engine.Graphics.Drawable.Base
function _Drawable:GetChild(index)
	return self._children[index]
end

return _Drawable
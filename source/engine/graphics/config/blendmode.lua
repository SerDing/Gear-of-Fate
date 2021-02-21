--[[
    Desc: Blendmode 
    Author: SerDing
    Since:2020-02-07
    Alter:2020-03-20
]]

local _GRAPHICS = require("engine.graphics.graphics")

---@class Engine.Graphics.Config.Blendmode
local _Blendmode = require("core.class")()

function _Blendmode:Ctor(value)
    self:Set(value or "alpha")
end

function _Blendmode:Set(value)
    self._value = value
end

function _Blendmode:Get()
    return self._value 
end

function _Blendmode:Apply()
    _GRAPHICS.SetBlendmode(self._value)
end

function _Blendmode:Reset()
    _GRAPHICS.ResetBlendmode()
end

return _Blendmode
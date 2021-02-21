--[[
    Desc: Shader, a radius convertion object.
    Author: SerDing
    Since:2020-02-07
    Alter:2020-03-20
]]
local _GRAPHICS = require("engine.graphics.graphics")
local _RESOURCE = require("engine.resource")

---@class Engine.Graphics.Config.Shader
---@field protected _obj Shader
local _Shader = require("core.class")()

function _Shader:Ctor(code)
    self._code = ""
    self._obj = nil
    self:Set(code)
end

function _Shader:Set(code)
    if code then
        if code == self._code  then
            return 
        end
        self._code = code
        self._obj = _RESOURCE.NewShader(code)
    end
    self._obj = nil
end

function _Shader:Get()
    return self._obj
end

function _Shader:Apply()
    _GRAPHICS.SetShader(self._obj)
end

function _Shader:Reset()
    _GRAPHICS.SetShader()
end

return _Shader
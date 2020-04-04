--[[
    Desc: Render Component
    Author: SerDing
    Since: 2019-12-04
    Alter: 2019-12-04
]]
local _Color = require("engine.graphics.config.color")
local _Drawable = require("engine.graphics.drawable.base")
local _Base = require("component.base")

---@class Entity.Component.Render : Entity.Component.Base
---@field public renderObj Engine.Graphics.Drawable.Base
local _Render = require("core.class")(_Base)

function _Render.HandleData(data)
    if data.obj then
        data.objClass = require("entity.drawable." .. data.obj)
        if data.objClass.HandleData then 
            data.objClass.HandleData(data)
        end
    end
end

function _Render:Ctor(entity, data, param)
    _Base.Ctor(self, entity)
    self.renderObj = data.objClass.New(data)
    self.height = data.height or 0
    self.color = data.color and _Color.New(data.color.red, data.color.green, data.color.blue, data.color.alpha) or _Color.White()
    self.rate = 1.0

    if data.obj == "frameani" or data.obj == "sprite" then
        self.layer = _Drawable.New()
        self.layer:AddChild(self.renderObj)
    end    
    
    -- link to other methods of renderObj
    -- for key, value in pairs(data.objClass) do
    --     if type(value) == "function" then
    --         if key ~= "HandleData" and key ~= "New" and key ~= "Ctor" and key ~= "Update" and key ~= "Draw" then
    --             print("_Render:Ctor, key = ", key)
    --             _Render[key] = function (...)
    --                 value(self.renderObj, ...)
    --             end
    --         end
    --     end
    -- end
end

function _Render:Update(dt)

    if self.renderObj.Update then
        self.renderObj:Update(dt, self.rate)
    end
    
    local e = self._entity
    local px, py, pz = e.transform.position:Get()
    local sx, sy = e.transform.scale:Get()

    local obj = self.layer or self.renderObj
    obj:SetRenderValue("position", px, py + pz)
    obj:SetRenderValue("radian", e.transform.rotation)
    obj:SetRenderValue("scale", sx * e.transform.direction, sy)
    obj:SetRenderValue("color", self.color:Get())
end

function _Render:Draw()
    local transform = self._entity.transform
    self.renderObj:Draw()
end

-- function _Render:GetPart(key)
--     return self.renderObj:GetPart(key)
-- end

return _Render
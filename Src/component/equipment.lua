--[[
	Desc: Equipment Component
 	Author: SerDing
	Since: 2019-08-31 01:52:21
    Alter: 2019-09-27 19:32:25
]]

local _RESMGR = require("system.resource.resmgr")
local _Event = require("core.event")

---@class Entity.Component.Equipment : Entity.Component.Base
---@field protected _entity Entity 
local _Equipment = require("core.class")()

local _EQU_TYPE_ENUM = {
    ['weapon'] = 1,
    ['ring'] = 2,
    ['stone'] = 3, 
    ['coat'] = 4,
}

function _Equipment.HandleData(data)
    for key, value in pairs(data) do
        if key ~= "class" then
            data[key] = _RESMGR.LoadEquipmentData(value)
        end
    end
end

function _Equipment:Ctor(entity, data)
    self._entity = entity ---@type GameObject
    self.equipments = {} -- entity's current equipments
    -- self.equPathList = dofile("Data/equipment/equipmentlist.lua")
    self.onEquipmentChanged = _Event.New()
    -- self.onEquipmentChanged:AddListener(self, self._printEquInfo)

    for key, value in pairs(data) do
        if key ~= "class" then
            self:Equip(value) 
        end
    end

end

--- equip the equipment and update animation
---@param equ table equipment data 
---@param slotIndex string 
function _Equipment:Equip(equ)
    if self._entity.type == "character" then
        local slotIndex = _EQU_TYPE_ENUM[equ.type]
        self.equipments[slotIndex] = equ
        self.onEquipmentChanged:Notify(equ, "equiped")
    else -- for monster
        self.equipments[#self.equipments + 1] = equ
    end
    
    self._entity.render.renderObj:Refresh(equ.avatar)
end

---@param slot string 
function _Equipment:Unequip(slot)
    -- statements
end

---@param part string 
---@return table equipment data 
function _Equipment:GetCurrentEqu(part)
    return self.equipments[_EQU_TYPE_ENUM[part]]
end

function _Equipment:GetSubtype(part)
    return self.equipments[_EQU_TYPE_ENUM[part]].subtype
end

function _Equipment:_printEquInfo(equ, msgType)
    -- weapon
    print("_print equipment:")
    print("\tname:", equ.name)
    print("\texplain:", equ.explain)
    print("\tbackground_text:", equ.background_text)
    print("\ttype:", equ.type) 
    print("\tsubtype:", equ.subtype)
    print("\tattack:", equ.add.attack)
end

return _Equipment

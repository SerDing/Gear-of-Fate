--[[
	Desc: component weapon
 	Author: Night_Walker
	Since: 2017-08-08 17:30:16
	Alter: 2017-08-09 02:21:38
	Docs:
		* 
]]

local _Weapon = require("Src.Core.Class")()

local _RESMGR = require "Src.Resource.ResManager"

function _Weapon:Ctor(heroType, actor_) --initialize
	self.actor_ = actor_ or nil
	self.pathHeads = {
		["[swordman]"] = "character/swordman/equipment/avatar/weapon/",
	}
	self.pathHead = self.pathHeads[actor_:GetProperty('job')]
	self.mainType = ""
	self.subType = ""
end

function _Weapon:SetEqpID(id) -- set equipment id
	local _equipment = ItemMgr.GetEquipment(id)
	if _equipment:GetType() == "weapon" and _equipment:LayerNum() == 4 then
		self.actor_.animMap:GetWidget("weapon_b2"):SetActive(not bool)
		self.actor_.animMap:GetWidget("weapon_c2"):SetActive(not bool)
	end
end

function _Weapon:SetRes(weaponType, fileNum)
	local _resPathHead = self.pathHead .. weaponType .. "/" .. weaponType .. string.format("%04d", fileNum)
	local _resPathEnd = ".img"
	local _path_b = _resPathHead .. "b" .. _resPathEnd
	local _path_c = _resPathHead .. "c" .. _resPathEnd
	if self.single then
		if love.filesystem.exists(_RESMGR.pathHead .. _path_b) then
			self.actor_.animMap:GetWidget("weapon_b1"):SetFileNum(_path_b)
		elseif love.filesystem.exists(_RESMGR.pathHead .. _path_c) then
			self.actor_.animMap:GetWidget("weapon_c1"):SetFileNum(_path_c)
		else
			print(_path_b)
			print(_path_c)
			error("_Weapon:SetRes()  no useable file path")
		end
	else
		self.actor_.animMap:GetWidget("weapon_b1"):SetFileNum(_path_b)
		self.actor_.animMap:GetWidget("weapon_c1"):SetFileNum(_path_c)
	end

	-- in default, we set b2 and c2 to inactive unless the 
	-- weapon of hero is light sword or a complex weapon 
	-- like ming-dao or Evil Sword：Apophis
	self.actor_.animMap:GetWidget("weapon_b2"):SetActive(false)
	self.actor_.animMap:GetWidget("weapon_c2"):SetActive(false)
end

function _Weapon:SetType(mainType, subType)
	self.mainType, self.subType = mainType, subType
end

function _Weapon:SetSingle(bool)
	self.single = bool
	self.actor_.animMap:GetWidget("weapon_b1"):SetActive(not bool)
end

function _Weapon:GetType()
	return self.mainType, self.subType
end

return _Weapon
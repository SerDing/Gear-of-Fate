--[[
	Desc: weapon class
 	Author: Night_Walker
	Since: 2017-08-08 17:30:16
	Alter: 2017-08-09 02:21:38
	Docs:
		* weapon component
]]

local _Weapon = require("Src.Core.Class")()

local _AniPack = require "Src.AniPack"

local _RESMGR = require "Src.Resource.ResManager"

function _Weapon:Ctor(heroType) --initialize

	self.pathHeads = {
		["HERO_SWORDMAN"] = "character/swordman/equipment/avatar/weapon/",
	}

	self.pathHead = self.pathHeads[heroType]
	self.dir = 1
	self.mainType = ""
	self.subType = ""

	self.pak_b = _AniPack.New()
	self.pak_c = _AniPack.New()
	self.singlePak = self.pak_b
end

function _Weapon:NextFrame()

	if self.single then
		self.singlePak:NextFrame()
	else
		self.pak_b:NextFrame()
		self.pak_c:NextFrame()
	end
	
end

function _Weapon:Update(dt)

	if self.single then
		self.singlePak:Update(dt)
	else
		self.pak_b:Update(dt)
		self.pak_c:Update(dt)
	end
end

function _Weapon:Draw(x, y, r, sx, sy)

	if self.single then
		self.singlePak:Draw(x, y, r, sx, sy)
	else
		self.pak_b:Draw(x, y, r, sx, sy)
		self.pak_c:Draw(x, y, r, sx, sy)
	end
end

function _Weapon:Clear()
	self.pak_b = {}
	self.pak_c = {}
end

function _Weapon:AddAnimation(aniPath,__num,id)
	self.pak_b:AddAnimation(aniPath,__num,id)
	self.pak_c:AddAnimation(aniPath,__num,id)
end

function _Weapon:SetAnimation(id)

	self.pak_b:SetAnimation(id)
	self.pak_c:SetAnimation(id)
end

function _Weapon:SetPlayNum(id,num)

	self.pak_b:SetPlayNum(id,num)
	self.pak_c:SetPlayNum(id,num)
end

function _Weapon:SetCurrentPlayNum(num)

	self.pak_b:SetCurrentPlayNum(num)
	self.pak_c:SetCurrentPlayNum(num)
end

function _Weapon:SetFrame(num)

	self.pak_b:SetFrame(num)
	self.pak_c:SetFrame(num)
end

function _Weapon:SetColor(r,g,b,a)
	
	self.pak_b:SetColor(r,g,b,a)
	self.pak_c:SetColor(r,g,b,a)
end

function _Weapon:SetBaseRate(rate)
	
	self.pak_b:SetBaseRate(rate)
	self.pak_c:SetBaseRate(rate)
end

function _Weapon:SetRes(weaponType, fileNum)
	local _resPathHead = self.pathHead .. weaponType .. "/" .. weaponType .. string.format("%04d", fileNum)
	local _resPathEnd = ".img"
	local _path_b = _resPathHead .. "b" .. _resPathEnd
	local _path_c = _resPathHead .. "c" .. _resPathEnd
	if self.single then
		if love.filesystem.exists(_RESMGR.pathHead .. _path_b) then
			self.pak_b:SetFileNum(_path_b)
			self.singlePak = self.pak_b
		elseif love.filesystem.exists(_RESMGR.pathHead .. _path_c) then
			self.pak_c:SetFileNum(_path_c)
			self.singlePak = self.pak_c
		else
			print(_path_b)
			print(_path_c)
			error("_Weapon:SetRes()  no useable file path")
		end
	else
		self.pak_b:SetFileNum(_path_b)
		self.pak_c:SetFileNum(_path_c)
	end
end

function _Weapon:SetType(mainType, subType)
	self.mainType, self.subType = mainType, subType
end

function _Weapon:SetSingle(bool)
	self.single = bool or self.single
end

function _Weapon:SetDir(dir_)
	self.dir = dir_
	self.pak_b:SetDir(dir_)
	self.pak_c:SetDir(dir_)
end

function _Weapon:GetAttackBox()
	return self.pak_c:GetAttackBox()
end

function _Weapon:GetType()
	return self.mainType, self.subType
end

return _Weapon
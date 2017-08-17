--[[
	Desc: weapon class
 	Author: Night_Walker
	Since: 2017-08-08 17:30:16
	Alter: 2017-08-09 02:21:38
	Docs:
		* the class contain "b" and "c" two pack animation
]]

local _Weapon = require("Src.Class")()

local _AniPack = require "Src.AniPack"

function _Weapon:Ctor() --initialize

	self.pak_b = _AniPack.New()
	self.pak_c = _AniPack.New()
	self.dir = 1
end

function _Weapon:Update(dt)

	if self.single then
		self.pak_b:Update(dt)
	else
		self.pak_b:Update(dt)
		self.pak_c:Update(dt)
	end
end

function _Weapon:Draw(x,y)

	if self.single then
		self.pak_b:Draw(x,y)
	else
		self.pak_b:Draw(x,y)
		self.pak_c:Draw(x,y)
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

function _Weapon:SetFileNum(cont,tp)
	-- cont 	武器资源包路径
	-- tp 		需更改的pak标记 如 1-b  2-c

	if (tp == 1) then
	    self.pak_b:SetFileNum(cont)
	else
	    self.pak_c:SetFileNum(cont)
	end
end

function _Weapon:SetSingle(bool)
	self.single = bool or self.single
end
function _Weapon:SetDir(dir_)
	self.dir = dir_
	self.pak_b:SetDir(dir_)
	self.pak_c:SetDir(dir_)
end
return _Weapon
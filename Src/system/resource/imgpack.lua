--[[
	Desc: Image resource pack
 	Author: SerDing
	Since: 2017-07-28 21:54:14
	Alter: 2017-07-30 12:40:40
]]
local _STRING = require("engine.string")
local _FILE = require('engine.filesystem')
local _RESMGR = require("system.resource.resmgr")
local _RESOURCE = require('engine.resource')

---@class ImgPack
local _ImgPack = require("core.class")()

function _ImgPack:Ctor(path)
	if path then
		self:Load(path)
	end
end

function _ImgPack:Load(path)
	if path == self.path then
		return
	end
	
	self.path = path
	
	local tmpArray = _STRING.split(self.path,"/")
	local offsetName = string.gsub(tmpArray[#tmpArray],".img",".txt")

	if love.filesystem.exists(_RESMGR.imgPathHead .. self.path .. "/offset.txt") == false
	and love.filesystem.exists(_RESMGR.imgPathHead .. self.path, "/" .. offsetName) == false then
		print("The img pack is not existing:",self.path)
		return
	end
	
	if love.filesystem.exists(_RESMGR.imgPathHead .. self.path .. "/" .. offsetName) then
		self.offsetData = _FILE.LoadFile(_RESMGR.imgPathHead .. self.path .. "/" .. offsetName)
	else 
		self.offsetData = _FILE.LoadFile(_RESMGR.imgPathHead .. self.path .. "/offset.txt")
	end 

	if self.offsetData == nil then
		print("Error:_ResPack:Ctor() --> Can not get offset data!", self.path)
		return
	end
	
	local  first_cut = _STRING.split(self.offsetData, "\n")

	self.pakInfo = {}

	for n =1 , table.getn(first_cut) do
		local re_cut = _STRING.split(first_cut[n], " ")
		if table.getn(re_cut) == 2 then
			self.pakInfo[n]=
			{
				origin_x = tonumber(re_cut[1]),
				origin_y = tonumber(re_cut[2]),
				texture = 0
			}
		end
	end

	self.imageNum = table.getn(self.pakInfo)
end

function _ImgPack:GetTexture(num)
	if not self.pakInfo then
		return 
	end 
	
	if self.pakInfo[num].texture == 0 then
		local path = self.path .. "/" .. tostring(num - 1)
		local tex = _RESOURCE.LoadImage(path)
		self.pakInfo[num].texture = tex
	end

	return self.pakInfo[num].texture
end

function _ImgPack:GetOffset(num)
	
	local offset
	
	if not self.pakInfo then
		offset = {
			x = 0 ,
			y = 0 ,
		}
	else
		offset = {
			x = self.pakInfo[num].origin_x or 0 ,
			y = self.pakInfo[num].origin_y or 0 ,
		}
	end

	return offset
end

function _ImgPack:GetImageNum()
	return self.imageNum
end

function _ImgPack:Release()

	for n=1,table.getn(self.pakInfo) do
		if self.pakInfo[n].texture ~= 0 then
			self.pakInfo[n].texture:release()
		end
	end

end

return _ImgPack